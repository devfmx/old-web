ActiveAdmin.register Application do
  
  belongs_to :batch
  permit_params :accepted, :rating, :tag_list

  filter :taggings_tag_name, :as => :check_boxes, :collection => proc { Application.tag_counts.map(&:name) }
  filter :rating
  filter :user_email, :as => :string
  filter :created_at

  index do
    selectable_column
    column :user
    column :tags do |app|
      app.tag_list.map do |tag|
        link_to(tag, url_for(:q => {:taggings_tag_name_in => [tag]}))
      end.join(", ").html_safe
    end
    column :accepted
    column :rating
    column :created_at
    column :updated_at
    actions
  end

  show do |app|
    attributes_table do 
      row :user
      row :tags do
        app.tag_list.map do |tag|
          link_to(tag, url_for(:q => tag))
        end.join("")
      end
      row :rating
      row :accepted
      row :updated_at
      row :answers do
        YAML.load(app.application_answers).each_pair.map do |pair|
          "<div class='answer'><h6>#{pair.first}</h6><p>#{pair.last}</p></div>"
        end.join.html_safe
      end
    end
    active_admin_comments
  end

  member_action :rate, :method => :put do
    app = Application.find(params[:id])
    app.rating = params[:rating].to_i
    saved = app.save
    if saved
      SlackNotifier.application_rated(app, current_user)
    end
    render :text => saved, :status => saved ? 200 : 500
  end 

  member_action :accept, :method => :put do
    accept_application(true)
  end 

  member_action :reject, :method => :put do
    accept_application(false)   
  end 

  action_item :only => :show do
    link_to "Accept", accept_admin_batch_application_path, :method => :put
  end

  action_item :only => :show do
    link_to "Reject", reject_admin_batch_application_path, :method => :put
  end

  form do |f|
    f.inputs "Batch Details" do
      f.input :rating
      f.input :tag_list,
        label: "Tags",
        input_html: {
          data: {
            placeholder: "Enter tags",
            tags: Application.tag_counts.map(&:name).to_json }
        }
    end
    f.actions
  end

  controller do
    def accept_application(accepted)
      app = Application.find(params[:id])
      app.accepted = accepted
      if app.save
        ApplicationsMailer.send(accepted ? :accepted : :rejected, app).deliver!
        notice = accepted ? "Accepted" : "Rejected"
        notice += "! A notification email has been sent to #{app.user.email}"
        redirect_to({:action => :show}, {:notice => notice})
        SlackNotifier.application_decided(app, current_user)
      else
        redirect_to({:action => :show}, {:notice => app.errors.full_messages.join(',')})
      end
    end
  end

end

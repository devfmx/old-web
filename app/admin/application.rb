ActiveAdmin.register Application do
  
  belongs_to :batch
  permit_params :accepted, :rating

  index do
    selectable_column
    column :user
    column :accepted
    column :rating
    column :created_at
    column :updated_at
    actions
  end

  show do |app|
    attributes_table do 
      row :user
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

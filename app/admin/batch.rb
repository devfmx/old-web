ActiveAdmin.register Batch do
  permit_params :batch_size, :starts_at, :ends_at, :active, :name, :application_questions

  index do
    selectable_column
    column :name
    column :starts_at
    column :ends_at
    column :active
    column :batch_size
    column :applications do |batch|
      link_to batch.applications.count, admin_batch_applications_path(batch)
    end
    column :accepted do |batch|
      link_to batch.applications.where(:accepted => true).count, admin_batch_applications_path(batch, :q => {:accepted_eq => 1})
    end
    actions
  end

  show do |batch|
    attributes_table do
      row :name
      row :batch_size
      row :applications do |batch|
        link_to batch.applications.count, admin_batch_applications_path(batch)
      end
      row :accepted do |batch|
        link_to batch.applications.where(:accepted => true).count, admin_batch_applications_path(batch, :q => {:accepted_eq => 1})
      end      

      row :active
      row :starts_at
      row :ends_at
      row :updated_at

      row :application_questions do
        content_tag(:pre, batch.application_questions)
      end
    end
    active_admin_comments
  end

  form do |f|
    f.inputs "Batch Details" do
      f.input :name
      f.input :batch_size
      f.input :starts_at
      f.input :ends_at
      f.input :active
      f.input :application_questions
    end
    f.actions
  end

end

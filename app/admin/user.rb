ActiveAdmin.register User do
  index do
    selectable_column
    column :name
    column :identities do |user|
      user.identities.map do |identity|
        link_to(identity.provider, identity.url, :target => "_blank")
      end.join(' ').html_safe
    end
    actions
  end
end

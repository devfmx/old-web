module ApplicationHelper

  def link_to_devf(options = {})
    link_to root_url, options.reverse_merge(title: "Desarrollamos.(developers);") do
      "<b>Dev</b>.<i>f</i>".html_safe
    end
  end

end

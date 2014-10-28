require 'settingslogic'
class Settings < Settingslogic
  ATTN_HACKERS = %w[ vic@devf.mx kike@devf.mx ]

  source "config/settings.yml"
  namespace ENV['RAILS_ENV'] || 'development'
  load!

  def default_url_options
    {:host => domain}
  end

  def notify_postulations_to
    namespace_choice test: developer_email, development: developer_email, production: contact_email
  end

  def no_reply_email
    namespace_email 'noreply'
  end

  def contact_email
    namespace_email 'hola'
  end

  def support_email
    namespace_email 'hola'
  end

  def namespace_email(inbox)
    namespace_choice(test: developer_email, development: developer_email, production: inbox + '@' + domain)
  end

  def namespace_choice(hash)
    hash[namespace]
  end

  def namespace
    Settings.namespace.to_sym
  end

  def smtp_settings
    super.merge password: secrets.smtp_password
  end

  # def secrets
  #   Secrets
  # end

  # class Secrets < Settingslogic
  #   source "config/secrets.yml"
  #   namespace ENV['RAILS_ENV'] || 'development'
  #   load!
  # end
end

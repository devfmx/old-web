class ApplicationsMailer < ActionMailer::Base

  default from: Settings.contact_email
  helper :application, :social_share
  layout 'email'

  def default_url_options
    Settings.default_url_options
  end

  def notification(application)
    @application = application
    @user  = application.user
    @batch = application.batch
    mail to: Settings.notify_postulations_to
  end

  def confirmation(application)
    @application = application
    @user  = application.user
    @batch = application.batch
    mail to: @user.email
  end

  def accepted(application)
    @application = application
    @user  = application.user
    @batch = application.batch
    mail to: @user.email
  end

  def rejected(application)
    @application = application
    @user  = application.user
    @batch = application.batch
    mail to: @user.email
  end

end

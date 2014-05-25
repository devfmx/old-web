# Preview all emails at http://localhost:3000/rails/mailers/applications
class ApplicationsMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/applications/confirmation
  def confirmation
    application = Application.first
    ApplicationsMailer.confirmation(application)
  end

  def notification
    application = Application.first
    ApplicationsMailer.notification(application)
  end

  def accepted
    application = Application.first
    ApplicationsMailer.accepted(application)
  end  

  def rejected
    application = Application.first
    ApplicationsMailer.rejected(application)
  end  
  
end

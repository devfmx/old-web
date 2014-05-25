class ApplicationsController < ApplicationController

  before_action :authenticate_user!

  def index
    redirect_to :action => :new
  end

  def new
    @questions = batch_questions
    @application = current_batch.applications.build(:user => current_user)
  end

  def create
    @application = current_batch.applications.create(:user => current_user, 
      :application_answers => YAML.dump(params[:answers].as_json))
    if @application.save
      notify_emails(@application)
      redirect_to :root
    else
      @questions = batch_questions
      render :new
    end
  end

  protected

  def notify_emails(application)
    ApplicationsMailer.notification(application).deliver!
    ApplicationsMailer.confirmation(application).deliver!
  end

  def current_batch
    Batch.where(active: true).first
  end

  def batch_questions
    YAML.load(current_batch.application_questions).map { |h| OpenStruct.new h }
  end

end

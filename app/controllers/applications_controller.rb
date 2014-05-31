class ApplicationsController < ApplicationController

  before_action :authenticate_user!

  def index
    redirect_to :action => :new
  end

  def new
    @questions = batch_questions
    @application = current_batch.applications.build(:user => current_user)
    @answers = OpenStruct.new(params[:answers] || YAML.load(@application.application_answers || '--- {}'))
  end

  def create
    @application = current_batch.applications.create(:user => current_user, 
      :application_answers => YAML.dump(params[:answers].as_json))
    if @application.save
      notify_emails(@application)
      redirect_to :action => :thanks
    else
      @questions = batch_questions
      @answers = OpenStruct.new(params[:answers] || YAML.load(@application.application_answers || '--- {}'))
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

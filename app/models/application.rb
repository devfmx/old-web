class Application < ActiveRecord::Base

  belongs_to :user
  belongs_to :batch

  validate :answers_has_email

  acts_as_taggable

  def answers
    @answers ||= OpenStruct.new YAML.load(application_answers || '--- {}')
  end

  def answers=(answers)
    answers = OpenStruct.new(answers) if answers.kind_of?(Hash)
    @answers = answers
    self.application_answers = YAML.dump(answers.instance_variable_get(:@table))
  end

  def answers_has_email
    unless answers.email.present?
      errors.add(:base, "Email es requerido")
    end
  end

end
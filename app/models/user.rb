class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :omniauthable,  :omniauth_providers => [:facebook, :twitter, :github]
  has_many :identities, :dependent => :destroy

  class << self
    def find_or_build_for_identity(identity, user=nil)
      if identity.email.present?
        user ||= Identity.find_by_email(identity.email).try(:user) || User.find_by_email(identity.email)
      end
      unless user
        token = Devise.friendly_token[0,20]
        user = User.new(:name => identity.name, :email => identity.email, :password => token, :password_confirmation => token)
      end
      user.identities << identity
      user
    end    
  end
  
end

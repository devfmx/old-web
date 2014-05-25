class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    oauthorize :facebook
  end
  
  def twitter
    oauthorize :twitter
  end
  
  def github
    oauthorize :github
  end
  
  def passthru
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end
  
private
 
  def oauthorize(kind)
    identity = build_identity(kind, env['omniauth.auth'])
    @user = user_for_identity(identity, current_user)
    if @user.save!
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => kind
      session["devise.#{kind}_data"] = env["omniauth.auth"]
      sign_in :user, @user
      redirect_to root_url
    end    
  end

  def build_identity(provider, access_token)
    uid    = access_token['uid']
    token  = access_token['credentials']['token']
    secret = access_token['credentials']['secret']
    email  = access_token['info']['email']
    name   = access_token['info']['name']
    handle = access_token['info']['nickname']

    auth_attr = { :provider => provider.to_s, :handle => handle,
      :uid => uid, :token => token, :secret => secret, 
      :name => name, :email => email }

    case provider
    when :facebook
      auth_attr[:url] = access_token['info']['urls']['Facebook'] 
      auth_attr[:handle] = name
    when :twitter
      auth_attr[:url] = access_token['info']['urls']['Twitter'] 
      auth_attr[:email] = handle + '@twitter.no-email'
    when :github
    else
      raise "Provider #{provider} not handled"
    end
    
    Identity.find_by_uid(uid) || Identity.new(auth_attr)
  end


  def user_for_identity(identity, resource=nil)
    resource ||= Identity.find_by_email(identity.email).try(:user) || User.find_by_email(identity.email)
    unless resource
      token = Devise.friendly_token[0,20]
      resource = User.new(:name => identity.name, :email => identity.email, :password => token, :password_confirmation => token)
    end
    resource.identities << identity
    resource
  end
 
end
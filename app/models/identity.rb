class Identity < ActiveRecord::Base

  belongs_to :user

  class << self
    def build_from_oauth(provider, access_token)
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
      when :github
        auth_attr[:name] ||= (access_token['extra']['raw_info']['name'] rescue nil).to_s
      else
        raise "Provider #{provider} not handled"
      end
      identity = Identity.find_by_uid(uid) || Identity.new(auth_attr)
      identity.attributes = auth_attr
    end
  end

end
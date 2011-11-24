class OauthRequestToken < ActiveRecord::Base
  validates_uniqueness_of :token, :secret
end

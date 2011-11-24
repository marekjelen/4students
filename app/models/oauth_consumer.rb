class OauthConsumer < ActiveRecord::Base
  validates_uniqueness_of :secret, :key
end

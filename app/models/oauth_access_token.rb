class OauthAccessToken < ActiveRecord::Base
  belongs_to :user
  belongs_to :consumer, :class_name => 'OauthConsumer'
  validates_uniqueness_of :token, :secret
end

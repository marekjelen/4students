class Feed < ActiveRecord::Base
  has_many  :entries,       :class_name => 'FeedEntry'
  has_many  :subscriptions, :class_name => 'FeedSubscription'
end

class FeedReader < ActiveRecord::Base
  belongs_to    :user
  belongs_to    :entry, :class_name => 'FeedEntry'
end

class Profile < ActiveRecord::Base
  belongs_to  :user
  has_many    :sections, :class_name => 'ProfileSection'
end

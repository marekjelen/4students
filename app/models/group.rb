class Group < ActiveRecord::Base
  has_many    :memberships
  has_many    :members, :through => :memberships, :source => :user
  has_many    :permission
  belongs_to  :owner, :polymorphic => true
  belongs_to  :type, :class_name => 'GroupType'
end

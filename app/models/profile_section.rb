class ProfileSection < ActiveRecord::Base
  set_inheritance_column :inheritance_column
  belongs_to  :profile
  has_many    :items, :class_name => 'ProfileItem', :foreign_key => 'section_id'
end

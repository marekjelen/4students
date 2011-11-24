class ProfileItem < ActiveRecord::Base
  set_inheritance_column :inheritance_column
  belongs_to  :section, :class_name => 'ProfileSection', :foreign_key => 'section_id', :include => [:items]
end

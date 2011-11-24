class ClubCategory < ActiveRecord::Base
  has_many                :clubs, :class_name => 'Club', :foreign_key => 'category_id'
  acts_as_nested_set      :scope => 'active = 1'
  belongs_to              :parent, :class_name => 'ClubCategory'
  has_many                :categories, :foreign_key => 'parent_id', :class_name => 'ClubCategory'

end

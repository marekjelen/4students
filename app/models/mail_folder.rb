class MailFolder < ActiveRecord::Base
  set_inheritance_column :inheritance_column
  has_many    :messages, :class_name => 'MailMessage', :foreign_key => 'folder_id'
  belongs_to  :parent, :class_name => 'MailFolder', :foreign_key => 'parent_id'
  belongs_to  :user, :class_name => 'User'
  
end

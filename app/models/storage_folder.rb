class StorageFolder < ActiveRecord::Base
  belongs_to  :parent, :class_name => 'StorageFolder'
end

class Permission < ActiveRecord::Base
  belongs_to    :right
  belongs_to    :object, :polymorphic => true
  belongs_to    :group
end

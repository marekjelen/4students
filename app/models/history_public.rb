class HistoryPublic < ActiveRecord::Base
    set_inheritance_column :inheritance_column
    belongs_to :user
end

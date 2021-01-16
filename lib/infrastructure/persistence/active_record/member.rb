class ActiveRecord::Member < ActiveRecord::Base
  belongs_to :group, class_name: 'Group', foreign_key: 'group_id'
  self.table_name = 'group_members'
end
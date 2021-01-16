class ActiveRecord::Role < ActiveRecord::Base
  belongs_to :group, class_name: 'Group', foreign_key: 'group_id'

  validates :name, uniqueness: { scope: :tenant_id_id }
end

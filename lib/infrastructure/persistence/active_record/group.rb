class ActiveRecord::Group < ActiveRecord::Base
  has_many :members, class_name: 'Member', foreign_key: 'group_id', dependent: :delete_all
  has_many :one, class_name: 'Role', foreign_key: 'group_id', dependent: :delete_all
  validates :name, uniqueness: { scope: :tenant_id_id }
end
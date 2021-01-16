class ActiveRecord::Person < ActiveRecord::Base
  belongs_to :user, class_name: 'User', foreign_key: 'user_id'
  self.table_name = 'persons'
end

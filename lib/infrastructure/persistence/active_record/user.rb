require 'bcrypt'

class ActiveRecord::User < ActiveRecord::Base
  include BCrypt
  has_one :person, class_name: 'Person', foreign_key: 'user_id', dependent: :delete

  validates :username, uniqueness: { scope: :tenant_id_id }

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = new_password
    self.password_hash = @password
  end
end
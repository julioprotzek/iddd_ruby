require 'bcrypt'

# fast encryption for test environment
BCrypt::Engine.cost = 1 if ENV['APP_ENV'] == 'test'

class BCryptEncryptionService
  def self.encrypt(value)
    BCrypt::Password.create(value)
  end
end
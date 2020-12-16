class DomainRegistry
  def self.encryption_service
    BCryptEncryptionService
  end

  def self.password_service
    PasswordService.new
  end
end
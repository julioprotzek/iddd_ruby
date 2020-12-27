class InMemoryUserRepository
  def initialize
    @repository = {}
  end

  def add(user)
    key = key_of(user)
    raise StandardError, 'Duplicate Key' if @repository.key?(key)
    @repository[key] = user
  end

  def all_similar_named_users(tenant_id:, first_name_prefix:, last_name_prefix:)
    @repository
      .values
      .select do |user|
        next unless tenant_id == user.tenant_id

        name = user.person.name
        next unless name.first_name.starts_with?(first_name_prefix)
        next unless name.last_name.starts_with?(last_name_prefix)

        true
      end
  end

  def remove(user)
    @repository.delete(key_of(user))
  end

  def user_from_authentic_credentials(tenant_id, username, encrypted_password)
    @repository
      .values
      .find do |user|
        tenant_id == user.tenant_id &&
        username == user.username &&
        user.internal_access_only_encrypted_password == encrypted_password
      end
  end

  def find_by(tenant_id:, username:)
    @repository[key_with(tenant_id, username)]
  end

  def clean
    @repository.clear
  end

  private

  def key_of(user)
    key_with(user.tenant_id, user.username)
  end

  def key_with(tenant_id, username)
    "#{tenant_id}##{username}"
  end
end
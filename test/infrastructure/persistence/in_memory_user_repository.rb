class InMemoryUserRepository
  def initialize
    @repository = {}
  end

  def add(an_user)
    key = key_of(an_user)
    raise StandardError, 'Duplicate Key' if @repository.key?(key)
    @repository[key] = an_user
  end

  def remove(an_user)
    @repository.delete(key_of(an_user))
  end

  def clean
    @repository.clear
  end

  def find_by(tenant_id:, username:)
    key = "#{tenant_id}##{username}"
    @repository[key]
  end

  def all_similar_named_users(tenant_id:, first_name_prefix:, last_name_prefix:)
    @repository
      .values
      .select do |an_user|
        next unless tenant_id == an_user.tenant_id

        name = an_user.person.name
        next unless name.first_name.starts_with?(first_name_prefix)
        next unless name.last_name.starts_with?(last_name_prefix)

        true
      end
  end

  def user_from_authentic_credentials(a_tenant_id, an_username, an_encrypted_password)
    @repository
      .values
      .find do |an_user|
        a_tenant_id == an_user.tenant_id &&
        an_username == an_user.username &&
        an_user.internal_access_only_encrypted_password == an_encrypted_password
      end
  end

  private

  def key_of(an_user)
    "#{an_user.tenant_id}##{an_user.username}"
  end
end
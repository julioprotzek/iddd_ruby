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

  private

  def key_of(an_user)
    "#{an_user.tenant_id}##{an_user.username}"
  end
end
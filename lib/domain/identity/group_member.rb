class GroupMember
  include Assertion

  attr_reader :tenant_id, :name, :type

  def initialize(tenant_id:, name:, type:)
    self.tenant_id = tenant_id
    self.name = name
    self.type = type
  end

  def group?
    type == 'Group'
  end

  def user?
    type == 'User'
  end

  def tenant_id=(tenant_id)
    assert_presence(tenant_id, 'Tenant Id is required.')
    @tenant_id = tenant_id
  end

  def name=(name)
    assert_presence(name, 'Name is required.')
    assert_length(name, 1, 100, 'Name should be 100 characters or less.')
    @name = name
  end

  def type=(type)
    assert_presence(type, 'Type is required.')
    @type = type
  end

  def ==(other)
    self.class == other.class &&
    self.tenant_id == other.tenant_id &&
    self.name == other.name &&
    self.type == other.type
  end
end
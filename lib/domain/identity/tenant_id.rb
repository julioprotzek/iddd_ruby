class TenantId
  attr_reader :id

  def initialize(id)
    @id = id
  end

  def ==(other)
    self.class == other.class && self.id == other.id
  end
end
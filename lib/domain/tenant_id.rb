class TenantId
  attr_reader :id

  def initialize(an_id)
    @id = an_id
  end

  def ==(other)
    self.class == other.class && self.id == other.id
  end
end
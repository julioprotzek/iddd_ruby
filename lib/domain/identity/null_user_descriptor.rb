class NullUserDescriptor < UserDescriptor
  def initialize
  end

  def null_descriptor?
    true
  end
end
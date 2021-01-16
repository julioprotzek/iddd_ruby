class DomainEvent
  def version
    1
  end

  def occurred_at
    Time.now
  end
end
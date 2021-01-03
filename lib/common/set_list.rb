class SetList
  include Enumerable

  def initialize(members = [])
    @members = members.uniq
  end

  def add(item)
    @members << item unless item.in?(@members)
    self
  end

  def add?(item)
    if item.in?(@members)
      false
    else
      @members << item
      true
    end
  end

  def delete(item)
    @members.delete(item) if item.in?(@members)
    self
  end

  def delete?(item)
    if item.in?(@members)
      @members.delete(item)
      true
    else
      false
    end
  end

  def each(&block)
    @members.each(&block)
  end

  def size
    @members.size
  end
end

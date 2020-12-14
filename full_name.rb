class FullName
  def initialize(first_name, last_name)
    @first_name = first_name
    @last_name = last_name
  end

  def with_changed_first_name(first_name)
    FullName.new(first_name, @last_name)
  end

  def as_formatted_name
    @first_name + ' ' + @last_name
  end
end
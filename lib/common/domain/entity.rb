class Entity
  def hydrate(attrs)
    attrs.each do |attr|
      self.set_instance_var("@#{attr.key}", attr.value)
    end
  end
end
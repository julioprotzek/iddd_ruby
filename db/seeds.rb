tenant_id = TenantId.new(SecureRandom.uuid)
group_a = Group.new(
  tenant_id,
  'Group A',
  'A group named A'
)
DomainRegistry.group_repository.add(group_a)

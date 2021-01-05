require './test/domain/identity_access_test'
require './test/domain/identity/group_repository_tests'

class InMemoryGroupRepositoryTest < IdentityAccessTest
  extend GroupRepositoryTests

  setup do
    DomainRegistry.stubs(:group_repository).returns(InMemory::GroupRepository.new)
    DomainRegistry.group_repository.clean
  end

  it_behaves_like_a_group_repostiory
end
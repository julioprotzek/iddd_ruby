require './test/domain/identity_access_test'
require './test/domain/identity/group_repository_shared_tests'

class ActiveRecordGroupRepositoryTest < IdentityAccessTest
  extend GroupRepositorySharedTests

  setup do
    # Ensure correct subject under test (ignores IdentityAccessTest stub config)
    DomainRegistry.stubs(:group_repository).returns(ActiveRecord::GroupRepository.new)
    DomainRegistry.group_repository.clean
  end

  it_behaves_like_a_group_repository
end
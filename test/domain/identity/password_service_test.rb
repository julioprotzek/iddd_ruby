require './test/domain/identity_access_test'

class PasswordServiceTest < IdentityAccessTest
  test 'generate strong password' do
    password = DomainRegistry.password_service.generate_strong_password

    assert DomainRegistry.password_service.strong?(password)

    assert !DomainRegistry.password_service.weak?(password)
  end

  test 'strong password' do
    password = 'Th1sShudBStrong.'

    assert DomainRegistry.password_service.strong?(password)

    assert !DomainRegistry.password_service.very_strong?(password)
    assert !DomainRegistry.password_service.weak?(password)
  end

  test 'very strong password' do
    password = 'Th1sSh0uldBV3ryStrong!'

    assert DomainRegistry.password_service.very_strong?(password)
    assert DomainRegistry.password_service.strong?(password)

    assert !DomainRegistry.password_service.weak?(password)
  end

  test 'weak password' do
    password = 'Weakness'

    assert !DomainRegistry.password_service.very_strong?(password)
    assert !DomainRegistry.password_service.strong?(password)

    assert DomainRegistry.password_service.weak?(password)
  end
end
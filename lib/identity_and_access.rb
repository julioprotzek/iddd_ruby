class IdentityAndAccess < AbstractJSONResource
  use GroupResource
  use NotificationResource
  use TenantResource
  use UserResource
  use AdminResource
end
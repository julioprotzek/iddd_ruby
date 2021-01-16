class IdentityAndAccess < AbstractJsonResource
  use GroupResource
  use NotificationResource
  use TenantResource
  use UserResource
  use AdminResource
end
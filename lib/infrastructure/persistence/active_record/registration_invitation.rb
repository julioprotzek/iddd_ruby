class ActiveRecord::RegistrationInvitation < ActiveRecord::Base
  belongs_to :tenant, class_name: 'Tenant', foreign_key: 'tenant_id'
  self.table_name = 'registration_invitations'

  validates :invitation_id, uniqueness: { scope: :tenant_id_id }
end
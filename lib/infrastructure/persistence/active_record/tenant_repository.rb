class ActiveRecord::TenantRepository
  class TenantModel < ActiveRecord::Base
    has_many :registration_invitations, class_name: 'RegistrationInvitationModel', foreign_key: 'tenant_id', dependent: :delete_all
    self.table_name = 'tenants'

    validates :tenant_id_id, :name, uniqueness: true
  end

  class RegistrationInvitationModel < ActiveRecord::Base
    belongs_to :tenant, class_name: 'TenantModel', foreign_key: 'tenant_id'
    self.table_name = 'registration_invitations'

    validates :invitation_id, uniqueness: { scope: :tenant_id_id }
  end

  def add(tenant)
    record = find_record_for(tenant)

    if record.present?
      record.update(hash_from_aggregate(tenant))
    else
      record = TenantModel.create!(hash_from_aggregate(tenant))
    end

    as_aggregate(record)
  # rescue
  #   raise StandardError, 'Tenant is not unique.'
  end

  def next_identity
    TenantId.new(SecureRandom.uuid)
  end

  def tenant_named(name)
    as_aggregate TenantModel.find_by(name: name)
  end

  def tenant_of_id(tenant_id)
    as_aggregate TenantModel.find_by(tenant_id_id: tenant_id.id)
  end

  def remove(tenant)
    find_record_for(tenant).delete
    nil
  end

  def clean
    TenantModel.delete_all
  end

  private

  def as_aggregate(record)
    return unless record.present?

    tenant = Tenant.new(
      tenant_id: TenantId.new(record.tenant_id_id),
      name: record.name,
      description: record.description,
      active: record.active
    )

    tenant.registration_invitations = record.registration_invitations.map do |invitation_record|
      invitation = RegistrationInvitation.new(
        tenant_id: TenantId.new(invitation_record.tenant_id_id),
        invitation_id: invitation_record.invitation_id,
        description: invitation_record.description
      )

      invitation
        .starting_at(invitation_record.starts_at)
        .ending_at(invitation_record.starts_at)
    end

    tenant
  end

  def hash_from_aggregate(tenant)
    tenant_hash = tenant.as_json.deep_symbolize_keys
    tenant_hash[:tenant_id_id] = tenant_hash.delete(:tenant_id)[:id]
    tenant_hash[:registration_invitations] = tenant_hash[:registration_invitations].map do |invitation_hash|
      invitation_hash[:tenant_id_id] = invitation_hash.delete(:tenant_id)[:id]
      RegistrationInvitationModel.new(invitation_hash)
    end

    tenant_hash
  end

  def find_record_for(tenant)
    TenantModel.find_by(tenant_id_id: tenant.tenant_id.id)
  end
end
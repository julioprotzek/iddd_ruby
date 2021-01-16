  class ActiveRecord::Tenant < ActiveRecord::Base
    has_many :registration_invitations, class_name: 'RegistrationInvitation', foreign_key: 'tenant_id', dependent: :delete_all

    validates :tenant_id_id, :name, uniqueness: true
  end
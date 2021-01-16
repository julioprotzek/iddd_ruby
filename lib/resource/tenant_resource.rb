class TenantResource < AbstractJSONResource
  get '/tenants/:tenant_id' do
    tenant = identity_application_service.tenant(params[:tenant_id])

    if tenant.present?
      tenant.to_json
    else
      halt 404, { error: "Tenant not found" }.to_json
    end
  end
end
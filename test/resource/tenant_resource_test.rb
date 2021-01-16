require './test/resource/abstract_resource_test'

class TenantResourceTest < AbstractResourceTest
  test 'tenant' do
    tenant = tenant_aggregate

    get "/tenants/#{tenant.tenant_id.id}"

    refute json_response.key?(:error), json_response[:error]
    assert_equal tenant.tenant_id.id, json_response[:tenant_id][:id]
    assert_equal tenant.name, json_response[:name]
  end
end
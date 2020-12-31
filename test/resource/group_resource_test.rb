require './test/resource/abstract_resource_test'

class GroupResourceTest < AbstractResourceTest
  test 'group' do
    group = group_1_aggregate
    DomainRegistry.group_repository.add(group)

    get "/tenants/#{group.tenant_id.id}/groups/#{url_encode(group.name)}"

    assert_equal group.tenant_id.id, json_response[:tenant_id][:id]
    assert_equal group.name, json_response[:name]
  end
end
class GroupResource < AbstractResource
  before do
    content_type :json
  end

  get '/tenants/:tenant_id/groups/:group_name' do
    group = identity_application_service.group(params[:tenant_id], params[:group_name])

    if group.present?
      group.to_json
    else
      halt 404, { error: "Group not found for tenant_id=#{params[:tenant_id]} and group_name=#{params[:group_name]}" }.to_json
    end
  end
end
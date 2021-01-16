class UserResource < AbstractJsonResource
  get '/tenants/:tenant_id/users/:username/authenticate_with/:password' do
    user_descriptor = identity_application_service.authenticate_user(
      AuthenticateUserCommand.new(
        tenant_id: params[:tenant_id],
        username: params[:username],
        password: params[:password]
      )
    )

    if user_descriptor.null_descriptor?
      halt 401, { error: "User not authenticated." }.to_json
    else
      user_descriptor.to_json
    end
  end

  get '/tenants/:tenant_id/users/:username' do
    user = identity_application_service.user(params[:tenant_id], params[:username])

    if user.present?
      UserRepresentation.new(user).to_json
    else
      halt 404, { error: "User not found." }.to_json
    end
  end

  get '/tenants/:tenant_id/users/:username/in_role/:role_name' do
    user = access_application_service.user_in_role(
      tenant_id: params[:tenant_id],
      username: params[:username],
      role_name: params[:role_name]
    )

    if user.present?
      UserInRoleRepresentation.new(user, params[:role_name]).to_json
    else
      halt 404, { error: "User not found in role #{params[:role_name]}." }.to_json
    end
  end
end
class AdminResource < AbstractJsonResource
  get '/admin' do
    {
      tenants: ActiveRecord::Tenant.all,
      groups: ActiveRecord::Group.all.as_json(include: :members),
      users: ActiveRecord::User.all.as_json(include: :person),
      roles: ActiveRecord::Role.all.as_json(include: :group),
    }.to_json
  end
end
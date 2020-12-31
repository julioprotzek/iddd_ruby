require './lib/identity_and_access'

map '/api' do
  run IdentityAndAccess
end

map '/' do
  run Sinatra.new { get('/') { 'Only API for now...' } }
end
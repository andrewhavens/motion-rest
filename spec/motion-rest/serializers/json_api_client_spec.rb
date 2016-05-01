# describe Motion::Rest::Client do
#   extend WebStub::SpecHelpers
#
#   before do
#     disable_network_access!
#     Motion::Rest::Client.base_uri = 'http://api.example.com/v1/'
#   end
#
#   describe '.base_uri' do
#     it 'allows you to specify the base uri of subsequent requests' do
#       Motion::Rest::Client.base_uri = 'http://api.example.com/'
#       Motion::Rest::Client.base_uri.should == 'http://api.example.com' # removes trailing slash
#     end
#   end
#
#   describe '.request' do
#     it 'performs a JSON API request' do
#       request_stub = stub_request(:get, "http://api.example.com/v1/foobar").
#         with(headers: {
#           "Content-Type" => "application/vnd.api+json",
#           # "Accept" => "application/vnd.api+json", # Not currently true
#         }).
#         to_return(json: {"foo" => "bar"})
#
#       Motion::Rest::Client.request :get, 'foobar' do |response|
#         @response = response
#         resume
#       end
#
#       wait_max 1.0 do
#         request_stub.should.be.requested
#         @response.should.be.success
#         @response.object.should == {"foo" => "bar"}
#       end
#     end
#
#     it 'scopes root relative requests to the base URI' do
#       request_stub = stub_request(:get, "http://api.example.com/v1/foobar")
#       Motion::Rest::Client.request :get, '/foobar' { resume }
#
#       wait_max 1.0 do
#         request_stub.should.be.requested
#       end
#     end
#
#     it 'allows requests to non-relative hosts' do
#       request_stub = stub_request(:get, "http://google.com")
#       Motion::Rest::Client.request :get, 'http://google.com' { resume }
#
#       wait_max 1.0 do
#         request_stub.should.be.requested
#       end
#     end
#   end
#
#   describe '.get' do
#     it 'performs a GET request' do
#       request_stub = stub_request(:get, "http://api.example.com/v1/foobar?baz=bat")
#       Motion::Rest::Client.get '/foobar', baz: 'bat' { resume }
#
#       wait_max 1.0 do
#         request_stub.should.be.requested
#       end
#     end
#   end
#
#   describe '.post' do
#     it 'performs a POST request with params encoded in request body' do
#       request_stub = stub_request(:post, "http://api.example.com/v1/foobar").
#         with(body: '{"baz":"bat"}')
#
#       Motion::Rest::Client.post '/foobar', baz: 'bat' { resume }
#
#       wait_max 1.0 do
#         request_stub.should.be.requested
#       end
#     end
#   end
#
#   describe '.put' do
#     it 'performs a PUT request with params encoded in request body' do
#       request_stub = stub_request(:put, "http://api.example.com/v1/foobar").
#         with(body: '{"baz":"bat"}')
#
#       Motion::Rest::Client.put '/foobar', baz: 'bat' { resume }
#
#       wait_max 1.0 do
#         request_stub.should.be.requested
#       end
#     end
#   end
#
#   describe '.patch' do
#     it 'performs a PATCH request with params encoded in request body' do
#       request_stub = stub_request(:patch, "http://api.example.com/v1/foobar").
#         with(body: '{"baz":"bat"}')
#       Motion::Rest::Client.patch '/foobar', baz: 'bat' { resume }
#
#       wait_max 1.0 do
#         request_stub.should.be.requested
#       end
#     end
#   end
#
#   describe '.delete' do
#     it 'performs a DELETE request' do
#       request_stub = stub_request(:delete, "http://api.example.com/v1/foobar/123")
#       Motion::Rest::Client.delete '/foobar/123' { resume }
#
#       wait_max 1.0 do
#         request_stub.should.be.requested
#       end
#     end
#   end
#
# end

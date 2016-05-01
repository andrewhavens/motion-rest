describe Motion::Rest::Resource do

  class TestModel
    include Motion::Rest::Resource
    attribute :name
    has_many :tests
  end

  describe '.collection_name' do
    it 'collection_name' do
      TestModel.collection_name.should == 'test_models'
    end
  end

  # describe '.has_many' do
  #   it 'always creates a collection wrapper' do
  #     model = TestModel.new
  #     model.id = '123'
  #     col = model.tests
  #     col.should.be.a.kind_of(Motion::Rest::Collection)
  #     col.collection_name.should == :tests
  #     col.parent.should == model
  #   end
  # end

  # describe '.find' do
  #   it 'requests an individual resource by id' do
  #     @response = stub(:success?, return: true)
  #     @response.stub!(:object, return: {
  #       'data' => {
  #         'type' => 'test_models'
  #       }
  #     })
  #     @model = nil

  #     Motion::Rest::Client.mock!(:get) do |uri|
  #       uri.should == 'test_models/123'
  #       yield @response
  #     end

  #     TestModel.find('123') do |response, model|
  #       @model = model
  #     end

  #     @model.should.be.a.kind_of TestModel
  #   end
  # end

  # describe '.find_or_initialize_model_from_data' do
  #   it 'initializes the correct model class' do
  #     sample_data = {
  #       "type"     => "posts",
  #       "id"       => "dd191df4-0b1e-49d2-9f81-a94448351f84"
  #     }
  #     result = TestModel.find_or_initialize_model_from_data(sample_data)
  #     result.should.be.kind_of(Post)
  #   end
  # end

  # describe '.parse_response' do
  #   def sample_data
  #     {
  #       "data" => {
  #         "id"                  => "e3c6f2a1-0260-448a-aefd-951d113be85b",
  #         "relationships"       => {
  #           "owner"           => {
  #             "data"           => {
  #               "type"             => "users",
  #               "id"               => "d1a81ce0-168a-4812-9c46-01839ff9db15"
  #             }
  #           },
  #           "posts"           => {
  #             "data"           => []
  #           },
  #           "members"         => {
  #             "data"           => [
  #               {
  #                 "type"               => "users",
  #                 "id"                 => "c0a5651d-aa11-42f2-b077-f4743b5097cf"
  #               }
  #             ]
  #           }
  #         },
  #         "type"                => "spaces",
  #         "attributes"          => {
  #           "name"                     => "Just me and my brother",
  #           "members_can_post"         => true,
  #           "description"              => "We can both post."
  #         }
  #       },
  #       "included"   => [
  #         {
  #           "id"               => "d1a81ce0-168a-4812-9c46-01839ff9db15",
  #           "type"             => "users",
  #           "attributes"       => {
  #             "email"              => "david@example.com",
  #             "full_name"          => "David Havens",
  #             "last_name"          => "Havens",
  #             "first_name"         => "David"
  #           }
  #         }
  #       ]
  #     }
  #   end

  #   it 'initializes the correct model and relationships' do
  #     result = TestModel.parse_response(sample_data)

  #     result.should.be.kind_of(Space)
  #     space = result
  #     space.id.should == 'e3c6f2a1-0260-448a-aefd-951d113be85b'
  #     space.name.should == 'Just me and my brother'
  #     space.description.should == 'We can both post.'

  #     space.owner.should.be.a.kind_of(User)
  #     space.owner.id.should == 'd1a81ce0-168a-4812-9c46-01839ff9db15'
  #     space.owner.full_name.should == 'David Havens'

  #     space.members.should.be.a.kind_of(ApiCollection)
  #     space.members.count.should == 1
  #     space.members.first.id.should == 'c0a5651d-aa11-42f2-b077-f4743b5097cf'
  #     space.members.first.full_name.should == nil # this record was not included
  #   end
  # end

  # describe '.create' do
  #   it 'formats request in JSON API format' do
  #     Motion::Rest::Client.mock!(:post) do |url, data|
  #       url.should == 'test_models'
  #       data.should == {
  #         "data" => {
  #           "type" => "test_models",
  #           "attributes" => {
  #             name: "hello"
  #           }
  #         }
  #       }
  #     end
  #     TestModel.create(name: 'hello')
  #   end
  # end

  # describe '#resource_uri' do
  #   it 'returns the uri of the resource' do
  #     model = TestModel.new
  #     model.id = '123'
  #     model.resource_uri.should == 'test_models/123'
  #   end
  # end
end

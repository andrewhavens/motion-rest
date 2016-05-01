describe Motion::Rest::Serializers::Flat do
  extend WebStub::SpecHelpers

  class FlatSerializerTestModel
    include Motion::Rest::Resource
    base_uri "https://api.example.com/v1"
    serializer :flat
    attributes :name, :age
    belongs_to :parent, class_name: FlatSerializerTestModel
    has_many :children, class_name: FlatSerializerTestModel
    # has_one :dog, class_name: 'Pet'
  end

  describe 'parsing responses' do
    it 'creates the models' do
      # TODO: stub the request and response
      request_stub = stub_request(:get, "https://api.example.com/v1/flat_serializer_test_models").
        with(headers: {
          "Content-Type" => "application/vnd.api+json",
          # "Accept" => "application/vnd.api+json", # Not currently true
        }).
        to_return(json: {"foo" => "bar"})
      FlatSerializerTestModel.all do |response, models|
        @response = response
        @models = models
        resume
      end

      wait_max 1.0 do
        request_stub.should.have.been.requested
        expect(@response).to be_success
        expect(@models.first.name).to eq "John Smith"
        expect(@models.first.age).to eq 21

        expect(@models.last.name).to eq "Joe Shmoe"
        expect(@models.last.age).to eq 31
      end
    end
  end
end

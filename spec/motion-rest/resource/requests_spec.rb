describe 'Motion::Rest::Resource::Requests' do
  class RequestTestModel
    include Motion::Rest::Resource
    attribute :name
  end

  extend WebStub::SpecHelpers
  disable_network_access!

  before do
    Motion::Rest::Client.base_uri = 'http://api.example.com/v1/'
  end

  describe '.all' do
    before do
      @request_stub = stub_request(:get, @request_url).to_return(json: @response_json)
      after { @request_stub.should.have.been.requested }
    end

    context 'when request returns no records' do
      @request_url = "http://api.example.com/v1/request_test_models"
      @response_json = { "data" => [] }

      it 'returns an empty array' do
        RequestTestModel.all do |response, models|
          @response = response
          @models = models
          resume
        end
        wait_max 1.0 do
          @response.should.be.success
          @models.should == []
        end
      end
    end

    context 'when request returns some records' do
      @request_url = "http://api.example.com/v1/request_test_models"
      @response_json = {
        "data" => [
          {"id" => 1, "type" => "request_test_models"},
          {"id" => 2, "type" => "request_test_models"},
        ]
      }

      it 'returns an array of all records' do
        RequestTestModel.all do |response, models|
          @response = response
          @models = models
          resume
        end
        wait_max 1.0 do
          @response.should.be.success
          @models.count.should == 2
          @models.first.id.should == 1
          @models.last.id.should == 2
        end
      end
    end
  end

  describe '.find' do
    let!(:request_stub) do
      stub_request(:get, request_url).to_return(json: response_body)
    end
    after { request_stub.should.have.been.requested }

    let(:request_url){ "http://api.example.com/v1/request_test_models/123" }
    let(:response_body) do
      {
        "data" => {
          "id" => "123",
          "type" => "request_test_models",
          "attributes" => {
            "name" => "foo"
          }
        }
      }
    end

    it 'returns a single model' do
      RequestTestModel.find(123) do |response, model|
        puts "running in block"
        # expect(model).to be.a.kind_of RequestTestModel
        @response = response
      end
      wait_max 1.0 do
        @response.should.be.success
      end
    end
  end

  # describe '.create' do
  #   it '' do
  #   end
  # end
  #
  # describe '#reload' do
  #   it '' do
  #   end
  # end
  #
  # describe '#create' do
  #   it '' do
  #   end
  # end
  #
  # describe '#update' do
  #   it '' do
  #   end
  # end
  #
  # describe '#save' do
  #   it '' do
  #   end
  # end

end

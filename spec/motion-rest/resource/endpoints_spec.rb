describe 'Motion::Rest::Resource::Endpoints' do

  class EndpointsTestModel
    include Motion::Rest::Resource
  end

  describe '.collection_uri' do
    it 'returns the pluralized form of the class name' do
      EndpointsTestModel.collection_uri.should == 'endpoints_test_models'
    end
  end

  describe '#resource_uri' do
    it 'returns an endpoint which includes the ID of the resource' do
      instance = EndpointsTestModel.new
      instance.id = '1234'
      instance.resource_uri.should == 'endpoints_test_models/1234'
    end
  end

  describe '#collection_uri' do
    it 'returns the pluralized form of the class name' do
      EndpointsTestModel.new.collection_uri.should == 'endpoints_test_models'
    end

    it 'returns the parent collection URI if specified' do
      collection = Motion::Rest::Collection.new
      collection.stub!(:collection_uri, return: 'foobars')

      instance = EndpointsTestModel.new
      instance.parent_collection = collection
      instance.collection_uri.should == 'foobars'
    end
  end
end

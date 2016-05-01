describe 'Motion::Rest::Resource::Naming' do

  class NamingTestModel
    include Motion::Rest::Resource
  end

  describe '.collection_name' do
    it 'returns the pluralized form of the class name' do
      NamingTestModel.collection_name.should == 'naming_test_models'
    end
  end

end

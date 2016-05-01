describe Motion::Rest::Configuration do
  describe "initialize" do
    it 'has defaults' do
      config = Motion::Rest::Configuration.new

      expect(config.base_uri).to be_nil
      expect(config.serializer).to eq :flat

      expect(Motion::Rest.config.base_uri).to be_nil
      expect(Motion::Rest.config.serializer).to eq :flat
    end
  end

  describe "Motion::Rest.configure" do
    it 'can be configured' do
      Motion::Rest.configure do |config|
        config.base_uri = "https://api.example.com/v2"
        config.serializer = :json_api
      end

      expect(Motion::Rest.config.base_uri).to eq "https://api.example.com/v2"
      expect(Motion::Rest.config.serializer).to eq :json_api
    end
  end
end

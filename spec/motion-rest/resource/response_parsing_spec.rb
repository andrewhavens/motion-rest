describe 'Motion::Rest::Resource::ResponseParsing' do
  class Person
    include Motion::Rest::Resource
    attribute :name
    belongs_to :parent
    has_one :guardian_angel
    has_many :children
    # define a class attribute for the purposes of testing
    class << self
      attr_accessor :initialized_models
    end
  end

  class Angel
    include Motion::Rest::Resource
    attribute :name
    has_one :person
    # define a class attribute for the purposes of testing
    class << self
      attr_accessor :initialized_models
    end
  end

  before do
    Person.initialized_models = nil
    Angel.initialized_models = nil
  end

  describe '.parse_response' do
    context 'when response is an empty array' do
      @json = {
        'data' => []
      }
      it 'returns an empty array' do
        result = Person.parse_response(@json)
        result.should == []
      end
    end

    context 'when response is an array of records' do
      @json = {
        'data' => [
          {'id' => 123, 'type' => 'people'},
          {'id' => 456, 'type' => 'people'},
        ]
      }
      it 'returns an array of models' do
        result = Person.parse_response(@json)
        result.should.be.a.kind_of(Array)
        result.count.should == 2
        result.first.should.be.a.kind_of(Person)
        result.first.id.should == 123
        result.last.id.should == 456
      end
    end

    context 'when response is a single record' do
      @json = {
        'data' => {
          'type' => 'people',
          'id' => 123,
          'attributes' => {
            'name' => 'foobar'
          }
        }
      }
      it 'returns a single model' do
        result = Person.parse_response(@json)
        result.should.be.a.kind_of(Person)
        result.name.should == 'foobar'
      end
    end
  end

  describe '.find_or_initialize_model_from_data' do
    @data = {
      'type' => 'people',
      'id' => 123,
      'attributes' => {
        'name' => 'foobar'
      }
    }

    it 'initializes a single model from a hash of data' do
      result = Person.find_or_initialize_model_from_data(@data)
      result.should.be.a.kind_of(Person)
      result.name.should == 'foobar'
    end

    it 'caches the initialized model in a temporary cache' do
      Person.find_or_initialize_model_from_data(@data)
      people_cache = Person.initialized_models['people']
      people_cache[123].should.be.a.kind_of(Person)
      people_cache[123].name.should == 'foobar'
    end
  end

  describe '.initialize_relationships_on_initialized_models' do
    @data = {
      'type' => 'people',
      'id' => '4',
      'attributes' => {
        'name' => 'Andrew'
      },
      'relationships' => {
        'parent' => {
          'data' => { 'id' => '1', 'type' => 'people'}
        },
        'guardian_angel' => {
          'data' => { 'id' => '1', 'type' => 'angels'}
        },
        'children' => {
          'data' => [
            { 'id' => '2', 'type' => 'people'},
            { 'id' => '3', 'type' => 'people'},
          ]
        }
      }
    }
    @include_data = [
      { 'id' => '1', 'type' => 'people', 'attributes' => {'name' => 'Joe'}, 'relationships' => {'children' => {'data' => [{ 'id' => '4', 'type' => 'people'}]}}},
      { 'id' => '2', 'type' => 'people', 'attributes' => {'name' => 'Elmer'}, 'relationships' => {'parent' => {'data' => { 'id' => '4', 'type' => 'people'}}}},
      { 'id' => '3', 'type' => 'people', 'attributes' => {'name' => 'Ralph'}, 'relationships' => {'parent' => {'data' => { 'id' => '4', 'type' => 'people'}}}},
      { 'id' => '1', 'type' => 'angels', 'attributes' => {'name' => 'Michael'}}
    ]

    it 'initializes relationships from the primary model data as well as the included list' do
      models = Person.initialize_relationships_on_initialized_models(@data, @include_data)
      people_cache = Person.initialized_models['people']
      people_cache['1'].should.be.a.kind_of(Person)
      people_cache['2'].should.be.a.kind_of(Person)
      people_cache['3'].should.be.a.kind_of(Person)
      people_cache['4'].should.be.a.kind_of(Person)
      angels_cache = Person.initialized_models['angels']
      angels_cache['1'].should.be.a.kind_of(Angel)
    end
  end

  describe '.initialize_relationships' do
    @instance = Person.new
    @relationships_data = {
      'parent' => {
        'data' => { 'id' => '1', 'type' => 'people'}
      },
      'guardian_angel' => {
        'data' => { 'id' => '1', 'type' => 'angels'}
      },
      'children' => {
        'data' => [
          { 'id' => '2', 'type' => 'people'},
          { 'id' => '3', 'type' => 'people'},
        ]
      }
    }

    it 'initializes the relationships from the provided data' do
      # @instance.parent.should == nil
      # @instance.guardian_angel.should == nil
      # @instance.children.should.be.a.kind_of(Motion::Rest::Collection)
      # @instance.children.count.should == 0
      Person.initialize_relationships(@instance, @relationships_data)
      @instance.parent.should.be.a.kind_of(Person)
      @instance.parent.id.should == '1'
      @instance.guardian_angel.should.be.a.kind_of(Angel)
      @instance.guardian_angel.id.should == '1'
      @instance.children.should.be.a.kind_of(Motion::Rest::Collection)
      @instance.children.count.should == 2
      @instance.children.first.id.should == '2'
      @instance.children.last.id.should == '3'
    end
  end
end

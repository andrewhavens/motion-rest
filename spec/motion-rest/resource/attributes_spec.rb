describe 'Motion::Rest::Resource::Attributes' do

  class AttributesTestModel
    include Motion::Rest::Resource
    attributes :name,
               :description
    attribute :created_at, type: :date
    attribute :awesome, type: :boolean, default: true
    attribute :dont_persist_me, read_only: true
    attribute :initialized_at, read_only: true, default: -> { Time.now }
  end

  describe '[class methods]' do
    describe '.attribute' do
      it 'accepts a name and a hash of options and creates getters and setters' do
        instance = AttributesTestModel.new
        %w[created_at awesome dont_persist_me].each do |attr_name|
          instance.should.respond_to "#{attr_name}"
          instance.should.respond_to "#{attr_name}="
        end
      end
    end

    describe '.attributes' do
      it 'accepts an array of names and creates getters and setters' do
        instance = AttributesTestModel.new
        %w[name description].each do |attr_name|
          instance.should.respond_to "#{attr_name}"
          instance.should.respond_to "#{attr_name}="
        end
      end

      it 'returns a hash of all the attributes that have been defined' do
        attrs = AttributesTestModel.attributes
        # make sure there aren't any rogue attributes
        attrs.keys.should == [:name, :description, :created_at, :awesome, :dont_persist_me, :initialized_at]
        attrs[:name].should == {}
        attrs[:description].should == {}
        attrs[:created_at].should == { type: :date }
        attrs[:awesome].should == { type: :boolean, default: true }
        attrs[:dont_persist_me].should == { read_only: true }
        attrs[:initialized_at][:read_only].should == true
        attrs[:initialized_at][:default].should.be.a.kind_of(Proc)
        attrs[:initialized_at][:default].call.should.be.a.kind_of(Time)
      end
    end
  end

  describe '#id' do
    it 'has an id attribute by default' do
      instance = AttributesTestModel.new
      instance.id.should == nil
      instance.id = '123'
      instance.id.should == '123'
    end
  end

  describe '#new_record?' do
    it 'returns true when id is nil' do
      instance = AttributesTestModel.new
      instance.new_record?.should == true
    end

    it 'returns false when id is not nil' do
      instance = AttributesTestModel.new
      instance.id = '1234'
      instance.new_record?.should == false
    end
  end

  describe '#initialize' do
    it 'sets passed attribute values' do
      time = Time.now
      instance = AttributesTestModel.new id: 123, name: 'test', created_at: time, dont_persist_me: 'foo'
      instance.id.should == 123
      instance.name.should == 'test'
      instance.created_at.should.be.a.kind_of(Time)
      instance.created_at.to_s.should == time.to_s
      instance.dont_persist_me.should == 'foo'
    end

    describe '[attribute options]' do
      describe ':default' do
        it 'sets default value, when attribute is not specified' do
          # TODO: freeze time to check time value
          instance = AttributesTestModel.new
          instance.awesome.should == true
          instance.initialized_at.should.be.a.kind_of(Time)
        end
      end

      describe ':read_only' do
        it 'creates an attribute that is not persisted' do
          instance = AttributesTestModel.new dont_persist_me: 'foobar'
          instance.dont_persist_me.should == 'foobar'
          # TODO: expect request not to send dont_persist_me
          instance.save
          true.should == false
        end
      end

      describe ':type' do
        it 'coerces date strings into NSDate objects if type is specified' do
          time = '2015-11-10T11:27:31-08:00'
          instance = AttributesTestModel.new created_at: time
          instance.created_at.should.be.a.kind_of(NSDate)
          instance.created_at.to_s.should == '2015-11-10 11:27:31 -0800'
        end

        it 'coerces boolean strings into boolean objects if type is specified' do
          truthy_values = [true, 'true', 'T', 1, 'YES', 'y']
          truthy_values.each do |value|
            instance = AttributesTestModel.new awesome: value
            instance.awesome.should.be.a.kind_of(TrueClass)
            instance.awesome.should == true
          end

          falsey_values = [false, 'false', 0, nil, 'foo']
          falsey_values.each do |value|
            instance = AttributesTestModel.new awesome: value
            instance.awesome.should.be.a.kind_of(FalseClass)
            instance.awesome.should == false
          end
        end
      end
    end
  end

end

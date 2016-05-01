describe 'Motion::Rest::Resource::Relationships' do

  class RelationshipsTestModel
    include Motion::Rest::Resource
    belongs_to :parent
    has_many :children
    has_one :dog, class_name: 'Pet'
  end

  describe '.relationships' do
    it 'returns a hash of the defined relationships' do
      rels = RelationshipsTestModel.relationships
      rels.should.be.a.kind_of Hash
      rels.keys.should == [:parent, :children, :dog]
    end
  end

  describe '.belongs_to' do
    it 'defines a belongs to relationship' do
      RelationshipsTestModel.relationships[:parent].should == { type: :belongs_to, class_name: 'Parent' }
    end

    it 'initializes as nil' do
      RelationshipsTestModel.new.parent.should == nil
    end
  end

  describe '.has_many' do
    it 'defines a belongs to relationship' do
      RelationshipsTestModel.relationships[:children].should == { type: :has_many, class_name: 'Child' }
    end

    it 'initializes as an empty collection' do
      has_many_collection = RelationshipsTestModel.new.children
      has_many_collection.should.be.a.kind_of(Motion::Rest::Collection)
    end
  end

  describe '.has_one' do
    it 'defines a has one relationship' do
      RelationshipsTestModel.relationships[:dog].should == { type: :has_one, class_name: 'Pet' }
    end

    it 'initializes as nil' do
      RelationshipsTestModel.new.dog.should == nil
    end
  end

  describe '.define_relationship' do
    it 'infers class name based on the name of the relationship' do
      RelationshipsTestModel.define_relationship 'employer', {}
      RelationshipsTestModel.relationships[:employer].should == { class_name: 'Employer' }
    end

    it 'allows class name to be specified' do
      RelationshipsTestModel.define_relationship :foo_bar, { class_name: 'Bonkers' }
      RelationshipsTestModel.relationships[:foo_bar].should == { class_name: 'Bonkers' }
    end
  end

  describe '#parent_collection' do
    it 'allows us to set a parent collection' do
      instance = RelationshipsTestModel.new
      instance.parent_collection.should.be.nil
      instance.parent_collection = 'something'
      instance.parent_collection.should == 'something'
    end
  end

end

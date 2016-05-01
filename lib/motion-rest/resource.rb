module Motion
  module Rest
    module Resource
      def self.included(base)
        base.extend Naming::ClassMethods
        base.extend Endpoints::ClassMethods
        base.extend Attributes::ClassMethods
        base.extend Relationships::ClassMethods
        base.extend Requests::ClassMethods
        base.extend ResponseParsing::ClassMethods
        base.extend Serialization::ClassMethods
      end

      include Attributes::InstanceMethods
      include Endpoints::InstanceMethods
      include Relationships::InstanceMethods
      include Serialization::InstanceMethods

      def initialize(data = {}, options = {})
        # set_parent_collection(options) # TODO: set this from outside
        data = Hash[data.map{|(k,v)|[k.to_sym,v]}]
        initialize_attributes(data)
        # initialize_relationships(data) # TODO: set these from outside, or handle in the init attributes method
      end

      # def instantiate_model_with_data(data)
      # data = {
      #   id: data.fetch('id')
      # }.merge(data.fetch('attributes', nil))
      #
      #   id = data.fetch('id')
      #   type = data.fetch('type')
      #   class_const = MotionSupport::Inflector.singularize(type).camelize.constantize
      #   class_const.new(data)
      # end
    end
  end
end

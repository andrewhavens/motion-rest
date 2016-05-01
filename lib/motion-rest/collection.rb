module Motion
  module Rest
    class Collection
      include Enumerable

      attr_accessor :parent, :collection_name, :models

      def initialize(models = [], options = {})
        @dirty = false
        @models = models
        @parent = options.fetch(:parent, nil)
        @collection_name = options.fetch(:collection_name, nil)
      end

      def each(&block)
        models.each(&block)
      end

      def first
        models.first
      end

      def last
        models.last
      end
      
      def to_a
        models
      end

      def count
        models.count
      end
    end
  end
end
#
# class ApiCollection
#   include Enumerable
#
#   attr_accessor :parent, :collection_name, :models
#
#   def initialize(models = [], options = {})
#     @dirty = false
#     @models = models
#     @parent = options.fetch(:parent, nil)
#     @collection_name = options.fetch(:collection_name, nil)
#   end
#
#   def collection_uri
#     uri = ''
#     if parent
#       uri = "#{parent.resource_uri}/"
#     end
#     uri + collection_name.to_s
#   end
#
#   def each(&block)
#     models.each(&block)
#   end
#
#   def to_a
#     models
#   end
#
#   def count
#     models.count
#   end
#
#   def <<(model)
#     @dirty = true
#     models << model
#   end
#
#   def dirty?
#     @dirty == true
#   end
#
#   def all(params = {}, &block)
#     ApiClient.get collection_uri, params do |response|
#       if response.success? and response.object
#         models = ApiResource.parse_response(response.object)
#         block.call(response, models)
#       else
#         block.call(response)
#       end
#     end
#   end
#
#   def create(data, &block)
#     model_class = MotionSupport::Inflector.singularize(collection_name.to_s).camelize.constantize
#     model_instance = model_class.new({}, parent_collection: self)
#
#     model_instance.class.relationships.each do |name, options|
#       if options[:type] == :belongs_to || options[:type] == :has_one
#         model_instance.send("#{name}=", parent) if options[:class_name] == parent.class.to_s
#       end
#     end
#
#     model_instance.save(data) do |response, model|
#       if response.success?
#         @models << model
#         block.call(response, model)
#       else
#         block.call(response)
#       end
#     end
#   end
#
#   def reload(&block)
#     all do |response, models|
#       @models = models
#       block.call(response, models)
#     end
#   end
#
#   def normalized_request_data
#     {
#       'data' => models.map do |model|
#         model.normalized_request_data['data']
#       end
#     }
#   end
# end

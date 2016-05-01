module Motion
  module Rest
    module Resource
      module ResponseParsing

        module ClassMethods
          def parse_response(json)
            # @initialized_models = nil # clear out old cache of initialized models
            primary_data = json['data']
            included_data = json.fetch('included', [])
            primary_resource_or_collection = initialize_models_from_data(primary_data)
            initialize_models_from_data(included_data)
            initialize_relationships_on_initialized_models(primary_data, included_data)
            @initialized_models = nil # clear out old cache of initialized models
            primary_resource_or_collection
          end

          # Instantiate models from an array of data.
          def initialize_models_from_data(data)
            if data.kind_of? Array
              data.map do |record|
                find_or_initialize_model_from_data(record)
              end
            else
              find_or_initialize_model_from_data(data)
            end
          end

          # Instantiate a single model from a hash of data, but don't initialize its relationships, and cache in a list.
          def find_or_initialize_model_from_data(data)
            type = data['type']
            id = data['id']
            @initialized_models ||= {}
            @initialized_models[type] ||= {}
            unless @initialized_models[type][id]
              class_const = MotionSupport::Inflector.singularize(type).camelize.constantize
              @initialized_models[type][id] = class_const.new(data)
            end
            @initialized_models[type][id]
          end

          def initialize_relationships_on_initialized_models(primary_data, included_data)
            unless primary_data.kind_of? Array
              primary_data = [primary_data]
            end
            all_data = primary_data + included_data
            all_data.each do |data|
              instance = find_or_initialize_model_from_data(data)
              relationships_data = data.fetch('relationships', [])
              initialize_relationships(instance, relationships_data)
            end
          end

          def initialize_relationships(instance, relationships_data)
            relationships_data.each do |name, data|
              relationship_data = data['data']
              if relationship_data.kind_of?(Array) # has_many relationship
                rel_instances = []
                relationship_data.each do |rel_data|
                  rel_instance = find_or_initialize_model_from_data(rel_data)
                  rel_instances << rel_instance if rel_instance
                end
                instance.send "#{name}=", Collection.new(rel_instances, collection_name: name, parent: instance)
              else  # belongs_to relationship
                rel_instance = find_or_initialize_model_from_data(relationship_data)
                instance.send("#{name}=", rel_instance) if rel_instance
              end
            end
          end
        end

      end
    end
  end
end

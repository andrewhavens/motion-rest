module Motion
  module Rest
    module Resource
      module Relationships

        module ClassMethods
          def relationships
            @relationships ||= {}
          end

          def belongs_to(name, options = {})
            define_relationship name, options.merge({type: :belongs_to})
            attr_accessor name
          end

          def has_one(name, options = {})
            define_relationship name, options.merge({type: :has_one})
            attr_accessor name
          end

          def has_many(name, options = {})
            define_relationship name, options.merge({type: :has_many})
            attr_writer name
            define_method name do
              collection = instance_variable_get("@#{name}")
              unless collection
                collection = Collection.new([], collection_name: name, parent: self)
                send("#{name}=", collection)
              end
              collection
            end
          end

          def define_relationship(name, options)
            name = name.to_sym
            default_options = { class_name: MotionSupport::Inflector.singularize(MotionSupport::Inflector.camelize(name)) }
            options = default_options.merge(options)
            attr_accessor name
            @relationships ||= {}
            @relationships[name] = options
          end
        end

        module InstanceMethods
          attr_accessor :parent_collection # used for request URIs

          # TODO: set this from outside or from within attributes
          # def set_parent_collection(options)
          #   @parent_collection = options.fetch(:parent_collection, nil)
          # end

          def initialize_relationships(data)
            data = data.fetch('relationships', {})
            self.class.relationships.each do |name, options|
              case options[:type]
              when :belongs_to, :has_one
                # NOTE: belongs_to and has_one relationships can be nil
                rel_data = data.fetch(name.to_s, nil)
                next unless rel_data
                initialize_has_one_relationship(name, options, rel_data)
              when :has_many
                # NOTE: has_many relationships should always instantiate an ApiCollection, even if there is no data.
                rel_data = data.fetch(name.to_s, {})
                initialize_has_many_relationship(name, options, rel_data)
              end
            end
          end

          def initialize_has_one_relationship(name, options, data)
            data = data.fetch('data', nil)
            return if data.nil?
            instance = instantiate_model_with_data(data)
            self.send("#{name}=", instance)
          end

          def initialize_has_many_relationship(name, options, data)
            data = data.fetch('data', [])
            records = data.map do |record_data|
              instantiate_model_with_data(record_data)
            end
            collection = Collection.new(records, collection_name: name, parent: self)
            self.send("#{name}=", collection)
          end
        end

      end
    end
  end
end

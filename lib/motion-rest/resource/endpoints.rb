module Motion
  module Rest
    module Resource
      module Endpoints

        module ClassMethods
          def base_uri(value = nil)
            @base_uri = value if value
            @base_uri ||= Motion::Rest.config.base_uri
          end

          def collection_uri
            collection_name
          end
        end

        module InstanceMethods
          def resource_uri
            "#{self.class.collection_uri}/#{id}"
          end

          def collection_uri
            return parent_collection.collection_uri if parent_collection
            self.class.collection_uri
          end
        end

      end
    end
  end
end

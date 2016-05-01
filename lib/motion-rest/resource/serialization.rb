module Motion
  module Rest
    module Resource
      module Serialization

        SERIALIZER_CLASSES = {
          flat: Motion::Rest::Serializers::Flat,
          json_api: Motion::Rest::Serializers::JsonApi
          # TODO: find a way to allow custom serializers
        }

        module ClassMethods
          def serializer(value = nil)
            if value
              @serializer = value
              @serializer_instance = SERIALIZER_CLASSES[@serializer].new
            else
              @serializer ||= Motion::Rest.config.serializer
              @serializer_instance ||= SERIALIZER_CLASSES[@serializer].new
            end
          end

        end

        module InstanceMethods
        end

      end
    end
  end
end

module Motion
  module Rest
    module Serializers
      class Flat
        def serialize(params)
          # TODO
        end

        def deserialize(json)
          # TODO
        end

        def http_client(base_uri)
          raise 'Missing base_uri' unless base_uri
          @client ||= begin
            AFMotion::Client.build(base_uri) do
              response_serializer :json
              # TODO: support custom headers, including Host, and Authorization
            end
          end
        end
      end
    end
  end
end

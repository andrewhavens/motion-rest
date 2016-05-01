module Motion
  module Rest
    module Resource
      module Requests

        module ClassMethods
          def http_client
            @http_client ||= serializer.http_client(base_uri)
          end

          def all(params = {}, &block)
            http_client.get collection_uri, params do |response|
              if response.success? and response.object
                models = parse_response(response.object)
                block.call(response, models)
              else
                block.call(response, nil)
              end
            end
          end

          def find(id, &callback)
            http_client.get "#{collection_uri}/#{id}" do |response|
              if response.success? and response.object
                model = parse_response(response.object)
                callback.call(response, model)
              else
                callback.call(response)
              end
            end
          end

          def create(data = {}, &block)
            new.save(data, &block)
          end
        end

        module InstanceMethods
          def http_client
            self.class.http_client
          end

          def reload(&block)
            self.class.find(id) do |response, model|
              block.call(response, model)
            end
          end

          def create(data = {}, &block)
            save(data, &block)
          end

          def update(data, &block)
            save(data, &block)
          end

          def save(data = {}, &block)
            request_method = id ? :patch : :post

            update_attribute_values(data)
            request_data = normalized_request_data
            uri = request_method == :post ? collection_uri : resource_uri
            http_client.send(request_method, uri, request_data) do |response|
              if response.success? and response.object
                model = self.class.parse_response(response.object)
                block.call(response, model)
              else
                block.call(response, nil)
              end
            end
          end
        end

      end
    end
  end
end

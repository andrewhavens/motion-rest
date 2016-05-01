module Motion
  module Rest
    class Client

      class JsonApiRequestSerializer < AFJSONRequestSerializer
        def requestBySerializingRequest(request, withParameters: parameters, error: error)
          mutableRequest = super
          mutableRequest.setValue("application/vnd.api+json", forHTTPHeaderField: "Content-Type")
          # TODO maybe?: header "Accept", "application/vnd.api+json"
          mutableRequest
        end
      end

      class << self
        attr_accessor :base_uri

        def base_uri=(uri)
          uri.chomp! '/' # remove trailing slash
          @base_uri = uri
        end

        def get(*args, &block)
          request(:get, *args, &block)
        end

        def post(*args, &block)
          request(:post, *args, &block)
        end

        def put(*args, &block)
          request(:put, *args, &block)
        end

        def patch(*args, &block)
          request(:patch, *args, &block)
        end

        def delete(*args, &block)
          request(:delete, *args, &block)
        end

        def request(method, *args, &callback)
          path = args[0]
          params = args[1]
          url_array = [base_uri]
          url_array << '/' unless path[0] == '/'
          url_array << path
          url = url_array.join
          url = path if path =~ /^http/
          # mp "Starting #{method.upcase} #{url}, params: #{params.inspect}"
          # mp params
          client.send(method, url, params) do |response|
            # mp "Response from #{method.upcase} #{url}"
            # mp "Status: #{response.status_code}"
            if response.success? || response.object
              # mp response.object
            else
              # mp response.error.localizedDescription
            end
            callback.call(response)
          end
        end

        def client
          @client ||= begin
            raise 'Missing Motion::Rest::Client.base_uri' unless base_uri
            AFMotion::Client.build(base_uri) do
              request_serializer JsonApiRequestSerializer
              response_serializer :json
              # TODO: header "Authorization", authorization_header
            end
          end
        end
      end

    end
  end
end

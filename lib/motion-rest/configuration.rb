module Motion
  module Rest
    def self.config
      @config ||= Configuration.new
    end

    def self.configure(&block)
      block.call(config)
    end

    class Configuration
      attr_accessor :base_uri, :serializer

      def initialize
        self.serializer = :flat
      end
    end
  end
end

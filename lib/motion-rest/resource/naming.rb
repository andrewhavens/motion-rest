module Motion
  module Rest
    module Resource
      module Naming

        module ClassMethods
          def collection_name
            self.to_s.pluralize.underscore
          end
        end

      end
    end
  end
end

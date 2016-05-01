module Motion
  module Rest
    module Resource
      module Attributes

        module ClassMethods
          def attributes(*attr_names)
            @attributes ||= {}
            attr_names.each do |name|
              attribute(name)
            end
            @attributes
          end

          def attribute(name, options = {})
            attr_accessor name
            @attributes ||= {}
            @attributes[name] = options
          end
        end

        module InstanceMethods
          attr_accessor :id

          def new_record?
            id.nil?
          end

          def initialize_attributes(data)
            initialize_default_attribute_values

            data.each do |attr_name, value|
              next unless respond_to? "#{attr_name}="
              type_requirement = self.class.attributes.fetch(attr_name, {}).fetch(:type, nil)
              case type_requirement
              when :date    then value = value.to_s.nsdate
              when :boolean then value = value.to_s =~ (/(true|t|yes|y|1)$/i) ? true : false
              end
              send("#{attr_name}=", value)
            end
          end

          private

          def initialize_default_attribute_values
            self.class.attributes.each do |name, options|
              default_value = options.fetch(:default, nil)
              next unless default_value
              if default_value.respond_to? :call
                default_value = default_value.call
              end
              send("#{name}=", default_value)
            end
          end
        end

      end
    end
  end
end

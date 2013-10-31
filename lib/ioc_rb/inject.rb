# Extend object with the dependency injection mechanism
# Example of usage:
# class Bar
# end
#
# class Foo
#   inject :bar
# end
#
# ioc_container[:foo].bar == ioc_container[:bar]
class Object

  class << self

    def inject(*args)
      options = args.last.is_a?(Hash) ? options = args.delete_at(-1) : {}
      dependency_names = args

      unless dependency_names.all?{|name| name.is_a?(Symbol) }
        raise ArgumentError, "inject accepts only symbols"
      end
      unless respond_to?(:injectable_attrs)
        class_attribute :injectable_attrs
        self.injectable_attrs = dependency_names.inject({}) do |result, name|
          result[name] = options.dup
          result
        end
      else
        new_attrs = dependency_names.inject({}) do |result, name|
          result[name] = options
          result
        end
        self.injectable_attrs = self.injectable_attrs.merge(new_attrs)
      end
      class_attribute *dependency_names
    end

    private

    def extract_options!(args)
      args
    end

  end

end

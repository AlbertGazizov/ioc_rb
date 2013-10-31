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

    def inject(*dependency_names)
      unless dependency_names.all?{|name| name.is_a?(Symbol) }
        raise ArgumentError, "inject accepts only symbols"
      end
      if class_variable_defined?(:@@injectable_attrs)
        injectable_attrs = class_variable_get(:@@injectable_attrs)
        injectable_attrs |= dependency_names
      else
        class_variable_set(:@@injectable_attrs, dependency_names)
      end
      attr_accessor *dependency_names
    end

  end

end

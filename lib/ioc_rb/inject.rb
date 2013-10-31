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
      if respond_to?(:injectable_attrs)
        self.injectable_attrs |= dependency_names
      else
        class_attribute :injectable_attrs
        self.injectable_attrs = dependency_names
      end
      class_attribute *dependency_names
    end

  end

end

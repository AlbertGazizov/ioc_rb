# Extend object with the bean injection mechanism
# Example of usage:
# class Bar
# end
#
# class Foo
#   inject :bar
#   or:
#   inject :some_bar, ref: bar
# end
#
# ioc_container[:foo].bar == ioc_container[:bar]
class Object

  class << self

    def inject(dependency_name, options = {})
      unless dependency_name.is_a?(Symbol)
        raise ArgumentError, "dependency name should be a symbol"
      end
      unless respond_to?(:injectable_attrs)
        class_attribute :injectable_attrs
        self.injectable_attrs = { dependency_name => options.dup }
      else
        self.injectable_attrs = self.injectable_attrs.merge(dependency_name => options.dup)
      end
      attr_accessor dependency_name
    end

  end

end

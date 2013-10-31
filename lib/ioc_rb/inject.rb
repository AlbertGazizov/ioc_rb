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

    def inject(dependency_name)
      ArgsValidator.is_symbol!(dependency_name, :dependency_name)
      if defined?(@@injectable_attrs)
        injectable_attrs = class_variable_get(:@@injectable_attrs)
        injectable_attrs << dependency_name
        class_variable_set(:@@injectable_attrs, injectable_attrs)
      else
        class_variable_set(:@@injectable_attrs, [dependency_name])
      end
      attr_accessor dependency_name
    end

  end

end

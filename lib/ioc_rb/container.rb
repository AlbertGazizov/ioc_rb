require 'ioc_rb/errors'
require 'ioc_rb/args_validator'
require 'ioc_rb/beans_storage'
require 'ioc_rb/bean_definition'
require 'ioc_rb/bean_definitions_storage'

module IocRb

  # IocRb::Container is the central data store for registering objects
  # used for dependency injection. Users register classes by
  # providing a name and a class to create the object(we call them beans). Beans
  # may be retrieved by asking for them by name (via the [] operator)
  class Container

    def initialize(resources = nil, &block)
      @beans_storage            = BeansStorage.new
      @bean_definitions_storage = BeanDefinitionsStorage.new

      if resources
        ArgsValidator.is_array!(resources, :resources)
        load_bean_definitions(resources)
      end
      if block_given?
        load_bean_definitions([block])
      end
    end

    def bean(bean_name, options, &block)
      ArgsValidator.is_symbol!(bean_name, :bean_name)
      ArgsValidator.is_hash!(options, :options)

      bean = BeanDefinition.new(bean_name, options, &block)
      @bean_definitions_storage.put(bean)
    end

    def [](name)
      if bean = @beans_storage.by_name(name)
        return bean
      end

      bean_definition = @bean_definitions_storage.by_name(name)
      unless bean_definition
        raise Errors::MissingBeanError, "Bean with name :#{name} not found"
      end
      bean = bean_definition.bean_class.new
      bean_definition.attrs.each do |attr|
        bean.send("#{attr.name}=", self[attr.ref])
      end
      @beans_storage.put(bean_definition.name, bean)
      bean
    end

    private

    def load_bean_definitions(resources)
      resources.each do |resource|
        resource.call(self)
      end
    end

  end
end

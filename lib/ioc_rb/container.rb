require 'ioc_rb/errors'
require 'ioc_rb/args_validator'
require 'ioc_rb/dependencies_storage'
require 'ioc_rb/dependency_definition'
require 'ioc_rb/dependency_definitions'

module IocRb

  # IocRb::Container is the central data store for registering services
  # used for dependency injection. Users register services by
  # providing a name and a block used to create the service. Services
  # may be retrieved by asking for them by name (via the [] operator)
  # or by selector (via the method_missing technique).
  #
  class Container
    def initialize(resources = nil)
      @dependencies_storage   = DependenciesStorage.new
      @dependency_definitions = DependencyDefinitions.new

      if resources
        ArgsValidator.is_array!(resources, :resources)
        #parse(resources)
      end
    end

    def register(dependency_name, options, &block)
      ArgsValidator.is_symbol!(dependency_name, :dependency_name)
      ArgsValidator.is_hash!(options, :options)

      dependency = DependencyDefinition.new(dependency_name, options, &block)
      @dependency_definitions.put(dependency)
    end

    def [](name)
      if dependency = @dependencies_storage.by_name(name)
        return dependency
      end

      dependency_definition = @dependency_definitions.by_name(name)
      dependency = dependency_definition.dependency_class.new
      dependency_definition.attrs.each do |attr|
        dependency.send("#{attr.name}=", self[attr.ref])
      end
      @dependencies_storage.put(dependency_definition.name, dependency)
      dependency
    end


  end
end

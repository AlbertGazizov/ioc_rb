module IocRb
  class DependencyDefinitions
    def initialize
      @dependency_definitions = {}
    end

    def by_name(name)
      @dependency_definitions[name]
    end

    def put(dependency_definition)
      @dependency_definitions[dependency_definition.name] = dependency_definition
    end

  end
end

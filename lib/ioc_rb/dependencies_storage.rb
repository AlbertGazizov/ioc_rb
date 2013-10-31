module IocRb
  class DependenciesStorage
    def initialize
      @dependencies = {}
    end

    def by_name(name)
      @dependencies[name]
    end

    def put(dependency_name, dependency)
      @dependencies[dependency_name] = dependency
    end

  end
end

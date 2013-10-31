module IocRb::Errors
  # Thrown when a service cannot be located by name.
  class MissingDependencyError < StandardError; end

  # Thrown when a duplicate service is registered.
  class DuplicateDependencyError < StandardError; end

  # Thrown by register_env when a suitable ENV variable can't be found
  class EnvironmentVariableNotFound < StandardError; end
end

module IocRb::Errors
  # Thrown when a service cannot be located by name.
  class MissingServiceError < StandardError; end

  # Thrown when a duplicate service is registered.
  class DuplicateServiceError < StandardError; end

  # Thrown by register_env when a suitable ENV variable can't be found
  class EnvironmentVariableNotFound < StandardError; end
end

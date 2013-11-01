module IocRb::Errors
  # Thrown when a service cannot be located by name.
  class MissingBeanError < StandardError; end

  # Thrown when a duplicate service is registered.
  class DuplicateBeanError < StandardError; end
end

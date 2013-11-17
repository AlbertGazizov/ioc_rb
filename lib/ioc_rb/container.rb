require 'ioc_rb/errors'
require 'ioc_rb/args_validator'
require 'ioc_rb/bean_metadata'
require 'ioc_rb/beans_metadata_storage'
require 'ioc_rb/bean_factory'

module IocRb

  # IocRb::Container is the central data store for registering objects
  # used for dependency injection. Users register classes by
  # providing a name and a class to create the object(we call them beans). Beans
  # may be retrieved by asking for them by name (via the [] operator)
  class Container

    # Constructor
    # @param resources [Array] array of procs with container's beans definitions
    # @param &block [Proc] optional proc with container's beans definitions
    def initialize(resources = nil, &block)
      @beans_metadata_storage = IocRb::BeansMetadataStorage.new
      @bean_factory = IocRb::BeanFactory.new(@beans_metadata_storage)

      if resources
        IocRb::ArgsValidator.is_array!(resources, :resources)
        load_bean_definitions(resources)
      end
      if block_given?
        load_bean_definitions([block])
      end
    end

    # Registers new bean in container
    # @param bean_name [Symbol] bean name
    # @param options [Hash] includes bean class and bean scope
    # @param &block [Proc] the block  which describes bean dependencies,
    #                      see more in the BeanMetadata
    def bean(bean_name, options, &block)
      IocRb::ArgsValidator.is_symbol!(bean_name, :bean_name)
      IocRb::ArgsValidator.is_hash!(options, :options)

      bean = IocRb::BeanMetadata.new(bean_name, options, &block)
      @beans_metadata_storage.put(bean)
    end

    # Returns bean instance from the container
    # by the specified bean name
    # @param name [Symbol] bean name
    # @return bean instance
    def [](name)
      @bean_factory.get_bean(name)
    end

    private

    # Evaluates the given array of blocks on the container instance
    # what adds new bean definitions to the container
    # @param resources [Array] array of procs with container's beans definitions
    def load_bean_definitions(resources)
      resources.each do |resource|
        resource.call(self)
      end
    end

  end
end

# Singleton scope returns the same bean instance
# on each call
class IocRb::Scopes::SingletonScope

  # Constructon
  # @param bean_factory bean factory
  def initialize(bean_factory)
    @beans = {}
    @bean_factory = bean_factory
  end

  # Returns the same bean instance
  # on each call
  # @param bean_metadata [BeanMetadata] bean metadata
  # @returns bean instance
  def get_bean(bean_metadata)
    @beans[bean_metadata.name] ||= @bean_factory.create_bean(bean_metadata)
  end
end

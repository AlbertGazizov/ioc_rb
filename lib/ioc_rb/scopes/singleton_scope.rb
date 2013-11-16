class IocRb::Scopes::SingletonScope

  def initialize(bean_factory)
    @beans = {}
    @bean_factory = bean_factory
  end

  def get_bean(bean_metadata)
    @beans[bean_metadata.name] ||= @bean_factory.create_bean(bean_metadata)
  end
end

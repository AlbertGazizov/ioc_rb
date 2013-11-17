# Prototype scope instantiates new bean instance
# on each +get_bean+ call
class IocRb::Scopes::PrototypeScope

  # Constructon
  # @param bean_factory bean factory
  def initialize(bean_factory)
    @bean_factory = bean_factory
  end

  # Get new bean instance
  # @param bean_metadata [BeanMetadata] bean metadata
  # @returns bean instance
  def get_bean(bean_metadata)
    @bean_factory.create_bean(bean_metadata)
  end
end

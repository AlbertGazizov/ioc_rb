require 'request_store'

# Request scope instantiates new bean instance
# on each new HTTP request
class IocRb::Scopes::RequestScope

  # Constructon
  # @param bean_factory bean factory
  def initialize(bean_factory)
    @bean_factory = bean_factory
  end

  # Returns a bean from the +RequestStore+
  # RequestStore is a wrapper for Thread.current
  # which clears it on each new HTTP request
  #
  # @param bean_metadata [BeanMetadata] bean metadata
  # @returns bean instance
  def get_bean(bean_metadata)
    RequestStore.store[:_iocrb_beans] ||= {}
    if bean = RequestStore.store[:_iocrb_beans][bean_metadata.name]
      bean
    else
     @bean_factory.create_bean_and_save(bean_metadata, RequestStore.store[:_iocrb_beans])
    end
  end

  # Delete bean from scope
  # @param bean_metadata [BeanMetadata] bean metadata
  def delete_bean(bean_metadata)
    RequestStore.store[:_iocrb_beans].delete(bean_metadata.name)
  end
end

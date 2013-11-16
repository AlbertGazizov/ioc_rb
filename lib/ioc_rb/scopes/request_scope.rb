require 'request_store'

class IocRb::Scopes::RequestScope
  def initialize(bean_factory)
    @bean_factory = bean_factory
  end

  def get_bean(bean_name)
    RequestStore.store[bean_name] ||= @bean_factory.create_bean(bean_name)
  end
end

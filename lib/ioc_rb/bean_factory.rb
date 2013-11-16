require 'ioc_rb/scopes'
require 'ioc_rb/scopes/singleton_scope'
require 'ioc_rb/scopes/prototype_scope'
require 'ioc_rb/scopes/request_scope'

class IocRb::BeanFactory

  def initialize(beans_metadata_storage)
    @beans_metadata_storage = beans_metadata_storage
    @singleton_scope        = IocRb::Scopes::SingletonScope.new(self)
    @prototype_scope        = IocRb::Scopes::PrototypeScope.new(self)
    @request_scope          = IocRb::Scopes::RequestScope.new(self)
  end

  # Get bean
  # according to the bean scope it will be newly created or returned already
  # instantiated bean
  # @param [Symbol] bean name
  # @return bean instance
  def get_bean(name)
    bean_metadata = @beans_metadata_storage.by_name(name)
    unless bean_metadata
      raise Errors::MissingBeanError, "Bean with name :#{name} is not defined"
    end
    get_bean_with_metadata(bean_metadata)
  end

  def get_bean_with_metadata(bean_metadata)
    case bean_metadata.scope
    when :singleton
      @singleton_scope.get_bean(bean_metadata)
    when :prototype
      @prototype_scope.get_bean(bean_metadata)
    when :request
      @request_scope.get_bean(bean_metadata)
    else
      raise Errors::UnsupportedScopeError, "Bean with name :#{bean_metadata.name} has unsupported scope :#{bean_metadata.scope}"
    end
  end

  def create_bean(bean_metadata)
    bean = bean_metadata.bean_class.new
    bean_metadata.attrs.each do |attr|
      bean_metadata = @beans_metadata_storage.by_name(attr.ref)
      unless bean_metadata
        raise Errors::MissingBeanError, "Bean with name :#{attr.ref} is not defined"
      end
      case bean_metadata.scope
      when :singleton
        bean.send("#{attr.name}=", get_bean(attr.ref))
      when :prototype
        bean.instance_variable_set(:@_ioc_rb_bean_factory, self)
        bean.define_singleton_method(attr.name) do
          @_ioc_rb_bean_factory.get_bean(attr.name)
        end
      when :request
        bean.instance_variable_set(:@_ioc_rb_bean_factory, self)
        bean.define_singleton_method(attr.name) do
          @_ioc_rb_bean_factory.get_bean(attr.name)
        end
      end
    end
    bean
  end

end

module IocRb
  class BeansStorage
    def initialize
      @beans = {}
    end

    def by_name(name)
      @beans[name]
    end

    def put(bean_name, bean)
      @beans[bean_name] = bean
    end

  end
end

# Storage of bean metadatas
class IocRb::BeansMetadataStorage
  def initialize
    @bean_definitions = {}
  end

  def by_name(name)
    @bean_definitions[name]
  end

  def put(bean_definition)
    @bean_definitions[bean_definition.name] = bean_definition
  end
end

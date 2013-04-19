
module Xeroxer

  def self.copy(source, destination, options = {} )
    source = Resource.create(source,options)
    destination = Resource.create(destination,options)
    destination.open("w")
    source.open("r")
    destination.write(source)
  end

  def self.permissions(target, entity, permissions, options={})
    target = Resource.create(target,options)
    target.permissions(entity,permissions)
  end
end
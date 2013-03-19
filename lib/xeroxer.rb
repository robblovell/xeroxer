require 'aws-sdk'
require 'uri'
require "multipart_post"


module Xeroxer
  class Resource
    class << self
    def create(uri)
      case uri.scheme.downcasae
        when "http"
          return new Xeroxer::HTTP.new uri
        when "file"
          return new Xeroxer::File.new uri
        when "s3"
          return new Xeroxer::S3.new uri
        else
          raise Exceptions::ProtocolNotSupported
      end
    end
  end
  
  ## all copies are done as streams, never read into memory entirely.
  def self.copy(source, destination, options = {} )
    # source or destination can be an AWS::S3 bucket, an S3 url, Net::HTTP resource, http url, https url, File, or file url.
    # convert urls into HTTP, File, or Bucket objects.
    if (source.instance_of? "String")
      source = Resource.create(URI(source))
    elsif (source.instance_of? "uri")
      source = Resource.create(source)  
    end # TODO:: validate as a Resource object.
      
    if (destination.instance_of? "String")
      destination = Resource.create(URI(destination))
    elsif (destination.instance_of? "uri")
      destination = Resource.create(destination)
    end # TODO:: validate as a Resource object.
    
    # stream the data from source to destination.
    source.open("r")
    destination.open("w") do |ptr|
      source.read do |chunk|
        ptr.write(chunk)
      end
    end
    source.close()
    
    destination.put(source)
    
  end

end
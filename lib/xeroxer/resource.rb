require 'aws-sdk'
require 'uri'

module Xeroxer

  class Resource
    class << self
      def create(uri)
        if uri.instance_of? URI
          uri = uri.scheme
        elsif !uri.instance_of? String # TODO:: validate as a Resource object.
          return uri
        end

        case uri[0..3].downcase
          when "http"  # http or https
            return Xeroxer::HTTP.new uri
          when "file"  # file
            return Xeroxer::File.new uri
          when "s3:/"  # s3
            return Xeroxer::S3.new uri
          else
            raise ProtocolNotSupported
        end
      end
    end
  end

end
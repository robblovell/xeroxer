module Xeroxer

  class Resource
    class << self
      def create(uri, options={})
        if uri.instance_of? URI
          uri = uri.scheme
        elsif !uri.instance_of? String # TODO:: validate as a Resource object.
          return uri
        end

        case uri[0..3].downcase
          when "http" # http or https
            return Xeroxer::HTTP.new uri, options
          when "file" # file
            return Xeroxer::File.new uri, options
          when "s3:/" # s3
            return Xeroxer::S3.new uri, options
          else
            raise ProtocolNotSupported
        end
      end
    end
  end

end
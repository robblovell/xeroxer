require 'xeroxer/xeroxer_config'


module Xeroxer

  class S3 < Resource
    def initialize(uri,options={})
      @type = Xeroxer::BLOCKREAD
      # if the s3 url has a 4 part domain name, then the bucket has been specified first.
      # in this case, URI can't handle it and we need to rearrage the bucket to be after
      # the domain name.
      if uri[0..4].downcase.start_with?("s3://")
        parts = uri.split('/')
        domain_parts = parts[2].split('.')
        if (domain_parts.length>3)
          # take out the bucket name because uri doesn't like it.
          uri = uri[0..4]+domain_parts[-3..-1].join('.')
          uri += "/"+domain_parts[0]+'/'+parts[3..-1].join('/')
        end
      end

      @uri = URI(uri) # amazon URI has the bucket as the first stop in the path.
      @bucket_name = @uri.path.split('/')[1]
      parts=@uri.path.split('/')
      @key="#{parts[2..-1].join('/')}"

      @s3host=@uri.host
      # if credentials are in the options use those, otherwise,
      # look up the bucket in the configuration, if it's there,
      # get it's credentials.
      if !options[:s3_credentials].nil?
        credentials=options[:s3_credentials]
      elsif !Xeroxer.config[@bucket_name].nil? &&
            !Xeroxer.config[@bucket_name][:s3_credentials].nil?
        Xeroxer.config[@bucket_name][:s3_credentials]
      elsif !Xeroxer.config[:s3_credentials].nil? &&
            !Xeroxer.config[:s3_credentials].empty?# fall back to this default.
        credentials=Xeroxer.config[:s3_credentials]
      else
        raise NoS3CredentialsGiven
      end
      @s3 = AWS::S3.new(:access_key_id => credentials[:access_key_id],
                        :secret_access_key => credentials[:secret_access_key])
      @bucket = @s3.buckets[@bucket_name]
    end

    #private
    attr_reader :type, :uri, :s3, :bucket_name, :path, :s3host, :bucket

    def get()
      return @object
    end

    def open(direction, &block)
      @bucket = @s3.buckets[@bucket_name]
      @object = @bucket.objects[@key]
    end

    def write(resource)
      resource.open("r")
      @object.write(resource.get())
    end

    def read(&block)
      @object.read(&block)
    end

    def close()
    end

    def permissions(target,permissions,entites=nil)
      if (entities.nil!) # just assign te value.
        @bucket[@key].acl = permissions
      else
        acl = AWS::S3::AccessControlList.new
        entities.each do |e|
          acl.grant(permissions).to(:canonical_user_id => e)
        end
        if acl.validate!
          @bucket[@key].acl = acl
        else
          raise InvalidAclException
        end
      end
    end

  end
end
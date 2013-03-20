require 'xeroxer'
require 'yaml'
require 'ap'

module Xeroxer

  class S3
    def initialize(uri)
      @type = Xeroxer::BLOCKREAD
      # if the s3 url has a 4 part domain name, then the bucket has been specified first.
      # in this case, URI can't handle it and we need to rearrage the bucket to be after
      # the domain name.
      if uri[0..4].downcase.start_with?("s3://")
        parts = uri.split('/')
        domain_parts = parts[2].split('.')
        if (domain_parts.length>3)
          # take out the bucket name because uri doesn't like it.
          uri = uri[0..4]+"#{domain_parts[-3]}#{domain_parts[-2..-1].map { |p| "."+p }}"
          uri += "/"+domain_parts[0]+"#{parts[3..-1].map { |p| "/"+p }}"
        end
      end

      @uri = URI(uri) # amazon URI has the bucket as the first stop in the path.
      @bucket_name = @uri.path.split('/')[1]
      parts=@uri.path.split('/')
      @key=parts[2]+"#{parts[3..-1].map { |p| "/#{p}" }}"

      @s3host=@uri.host
      @s3 = AWS::S3.new(:access_key_id => Xeroxer.config[:s3_credentials][:access_key_id],
                        :secret_access_key => Xeroxer.config[:s3_credentials][:secret_access_key])
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

    #def open2(direction, &block)
    #  @bucket = @s3.buckets[@bucket_name]
    #  @object = @bucket.objects[@key]
    #end
    #
    #def write2(chunk)
    #  @object.write(chunk)
    #end
    #
    #def read2(&block)
    #  @object.read(&block)
    #end
    #
    #def close2()
    #end
    #
    #def get2(source)
    #  open2("w")
    #  src = source.open2("r")
    #  write2(src)
    #
    #  close2()
    #  source.close2()
    #end
    #
    #def put2(destination)
    #  open2("r")
    #  destination.open2("w")
    #  #if false && @object.content_length < Xeroxer::BUF_SIZE
    #  #  buff = @object.read()
    #  #  destination.write(buff)
    #  #else
    #  read2() do |chunk|
    #    destination.write2(chunk)
    #  end
    #  #end
    #  close2
    #  destination.close2
    #end

  end
end
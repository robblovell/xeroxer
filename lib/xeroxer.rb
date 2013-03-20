require 'aws-sdk'
require 'uri'
require 'file'
require 'S3'
require 'http'
require 'xeroxer/exceptions'

module Xeroxer
  Xeroxer::BUF_SIZE = 4194304
  Xeroxer::GETPUT = 0
  Xeroxer::OPENCLOSE = 1
  Xeroxer::S3TYPE = 0
  Xeroxer::FILETYPE = 1
  Xeroxer::HTTPTYPE = 2
  Xeroxer::BLOCKREAD = 0
  Xeroxer::NOBLOCKREAD = 1

  # Configuration setup
  @config = {
      :buffer_size => Xeroxer::BUF_SIZE,
      :storage => :s3,
      :s3_domain => "s3.amazonaws.com",
      :s3_protocol => "http",
      :s3_credentials =>  { :access_key_id => "AKIAJAZSUF4AALALH3NA", # remove
                            :secret_access_key => "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"}
  }
  @config_keys = @config.keys

  # Configure through hash
  def self.configure(opts = {})
    opts.each {|k,v| @config[k.to_sym] = v if @config.include? k.to_sym}
  end

  # Configure through yaml file
  def self.configure_with(path_to_yaml_file)
    begin
      config = YAML::load(IO.read(path_to_yaml_file))
    rescue Errno::ENOENT
      log(:warning, "YAML configuration file couldn't be found. Using defaults."); return
    rescue Psych::SyntaxError
      log(:warning, "YAML configuration file contains invalid syntax. Using defaults."); return
    end

    configure(config)
  end

  def self.config
    @config
  end
  ## end configuration setup

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

  def self.copy(source, destination, options = {} )
    source = Resource.create(source)
    destination = Resource.create(destination)
    destination.open("w")
    source.open("r")
    destination.write(source)
  end
  ## all copies are done as streams, never read into memory entirely.
  ## destination must have block open and source must have block read.
  def self.copy2(source, destination, options = {} )
    # source or destination can be an AWS::S3 bucket, an S3 url, Net::HTTP resource, http url, https url, File, or file url.
    # convert urls into HTTP, File, or Bucket objects.
    source = Resource.create(source)
    destination = Resource.create(destination)
    ## stream the data from source to destination.
    source.open2("r")
    destination.open2("w")
    while buf = source.read2 do
      destination.write2(buf)
    end
    destination.close2()
    source.close2()
  end

  def self.getput2(source, destination, options = {} )
    # source or destination can be an AWS::S3 bucket,
    # an S3 url, Net::HTTP resource, http url, https url,
    # File, or file url. convert urls into HTTP, File,
    # or Bucket objects.
    source = Resource.create(source)
    destination = Resource.create(destination)
    source.put2(destination)
  end

  def self.putget2(source, destination, options = {} )
    # source or destination can be an AWS::S3 bucket,
    # an S3 url, Net::HTTP resource, http url, https url,
    # File, or file url. convert urls into HTTP, File,
    # or Bucket objects.
    source = Resource.create(source)
    destination = Resource.create(destination)
    destination.get2(source)
  end

end


module Xeroxer

  Xeroxer::BLOCKREAD = 0
  Xeroxer::NOBLOCKREAD = 1

  # Configuration setup
  @config = {
      :buffer_size => 4194304, # 4 MB
      :storage => :s3,
      :s3_domain => "s3.amazonaws.com",
      :s3_protocol => "http",
      :s3_credentials =>  {                          }
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

  def self.copy(source, destination, options = {} )
    source = Resource.create(source)
    destination = Resource.create(destination)
    destination.open("w")
    source.open("r")
    destination.write(source)
  end

end
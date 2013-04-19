require 'yaml'
module Xeroxer

  Xeroxer::BLOCKREAD = 0
  Xeroxer::NOBLOCKREAD = 1

  # Configuration setup
  @config = {
      :buffer_size => 4194304, # 4 MB
      :storage => :s3,
      :s3_domain => "s3.amazonaws.com",
      :s3_protocol => "http",
      :s3_credentials => {}
  }
  @config_keys = @config.keys

  # Configure through hash
  def self.configure(opts = {}, &block)
    if (block_given?)
      block.call(@config)
    else
      @config = convert_hash_to_symkeys(opts)
    end
  end

  def self.convert_hash_to_symkeys(hash)
    h = {}
    hash.each do |k, v|
      v = convert_hash_to_symkeys(v) if (v.class.name=='Hash')
      h[k.to_sym] = v
    end
    h
  end

# Configure through yaml file
  def self.configure_with(path_to_yaml_file, environment=nil)
    begin
      if (environment.nil?)
        config = YAML::load(IO.read(path_to_yaml_file))
      else
        config = YAML::load(IO.read(path_to_yaml_file))[environment]
      end
    rescue Errno::ENOENT
      log(:warning, "YAML configuration file couldn't be found. Using defaults."); return
    end
    configure(config)
  end

  def self.config
    @config
  end

  def self.log(level, message)
    puts level.to_s+" "+message
  end

## end configuration setup
end
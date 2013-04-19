# ways to intialize xeroxer:

XEROXER_CONFIG = YAML.load_file(File.expand_path('../example_xeroxer_config.yml', __FILE__))
XEROXER_CONFIG = YAML.load_file(File.expand_path('../example_rails_xeroxer_config.yml', __FILE__))[Rails.env]

# given a hash:
Xeroxer.configure(XEROXER_CONFIG)

# from a yaml file:
# without rails
Xeroxer.configure_with("#{Rails.root}/config/xeroxer_config.yml")
# with rails environments:
Xeroxer.configure_with("#{Rails.root}/config/xeroxer_config.yml",Rails.env)

# in a code block:
Xeroxer.configure do |config|
  config[:buffer_size] = 4194304 # 4 MB
  config[:storage] = :s3 # not currently used, but plans for other cloud storage abound!
  # s3 specific options can be given by bucket, globaly, and in each Xeroxer call.
  config[:s3_domain] = "s3.amazonaws.com"
  config[:s3_protocol] = "http"
  config[:buckets] = {'some_bucket' => {:access_key_id => 'some_s3_key', :secret_access_key => 'some_acces_key'}}
  config[:s3_credentials] = { :access_key_id => 'some_s3_key', :secret_access_key => 'some_acces_key' }
end

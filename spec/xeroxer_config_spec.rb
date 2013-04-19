require 'spec_helper'
require 'yaml'

describe Xeroxer do

  describe "configuration" do
  end

    it "should have default config" do
      Xeroxer.config[:buffer_size].should eq 4194304
    end

    it "should have yaml config" do
      Xeroxer.configure_with(File.expand_path('../../lib/xeroxer/example_xeroxer_config.yml', __FILE__))
      Xeroxer.config[:buffer_size].should eq 8388608
    end

    it "should have yaml config with rails" do
      Xeroxer.configure_with(File.expand_path('../../lib/xeroxer/example_rails_xeroxer_config.yml', __FILE__),'production')
      Xeroxer.config[:buffer_size].should eq 2048
    end

    it "should have hash config" do
      Xeroxer.configure do |config|
        config[:buffer_size] = 1024 # 4 MB
        config[:storage] = :s3 # not currently used, but plans for other cloud storage abound!
                                    # s3 specific options can be given by bucket, globaly, and in each Xeroxer call.
        config[:s3_domain] = "s3.amazonaws.com"
        config[:s3_protocol] = "http"
        config[:buckets] = {:some_bucket => {:access_key_id => 'some_s3_key', :secret_access_key => 'some_acces_key'}}
        config[:s3_credentials] = { :access_key_id => 'some_s3_key', :secret_access_key => 'some_acces_key' }
      end
      Xeroxer.config[:buffer_size].should eq 1024
      Xeroxer.config[:s3_credentials][:access_key_id].should eq 'some_s3_key'

      Xeroxer.config[:buckets][:some_bucket][:access_key_id].should eq 'some_s3_key'
    end
end

require 'spec_helper'
require 'aws-sdk'

describe Xeroxer do

  #before(:all) do
  #  @s3_cred = {:storage => :s3,
  #              :bucket => "vidigami_scratch",
  #              :dns_bucket => "vidigami_scratch.s3.amazonaws.com",
  #              :path => "xeroxer",
  #              :s3_domain => "s3.amazonaws.com",
  #              :s3_protocol => "http",
  #              :s3_credentials => { }}
  #  #source_file = "bigsrc.mp3"
  #  #dest_file = "bigdst.mp3"
  #  source_file = "src.txt"
  #  dest_file = "dst.txt"
  #  @source_file_uri="file://./spec/resources/#{source_file}"
  #  @source_file_path=@source_file_uri[9..-1] # URI.parse(@source_file_uri].path
  #  @destination_file_uri="file://./spec/resources/#{dest_file}"
  #  @destination_file_path=@destination_file_uri[9..-1]
  #
  #  @s3 = AWS::S3.new(:access_key_id => @s3_cred[:s3_credentials][:access_key_id],
  #                    :secret_access_key => @s3_cred[:s3_credentials][:secret_access_key])
  #  @bucket = @s3.buckets[@s3_cred[:bucket]]
  #  if (!@bucket.exists?)
  #    @bucket = @s3.buckets.create(@s3_cred[:dns_bucket])
  #  end
  #
  #  @source_s3_uri="s3://"+@s3_cred[:bucket]+"."+@s3_cred[:s3_domain]+"/"+@s3_cred[:path]+"/#{source_file}"
  #  @source_s3_bucket= @s3_cred[:bucket]
  #  @source_s3_path= @s3_cred[:path]+"/#{source_file}"
  #
  #  @destination_s3_uri="s3://"+@s3_cred[:bucket]+"."+@s3_cred[:s3_domain]+"/"+@s3_cred[:path]+"/#{dest_file}"
  #  @destination_s3_bucket= @s3_cred[:bucket]
  #  @destination_s3_path= @s3_cred[:path]+"/#{dest_file}"
  #end
  #
  #describe "Exceptions" do
  #  it "should rais exception Protocol Not Supported" do
  #    lambda { Xeroxer.copy2("blah", "blah") }.should raise_error Xeroxer::ProtocolNotSupported
  #  end
  #end
  #
  #describe "Xerox enumeration" do
  #  it "should return valid values" do
  #    Xeroxer::GETPUT.should == 0
  #    Xeroxer::OPENCLOSE.should == 1
  #    r = Xeroxer::S3.new("s3://amazon.s3.com/bucket/thing")
  #    r.type.should == Xeroxer::GETPUT
  #    r = Xeroxer::File.new("file:://path/path/thing")
  #    r.type.should == Xeroxer::OPENCLOSE
  #    r = Xeroxer::HTTP.new("http:://domain.address.com/path/thing")
  #    r.type.should == Xeroxer::GETPUT
  #  end
  #end
  #
  #describe "File url validation" do
  #  it "should remove the ./ and put in full path" do
  #    r = Xeroxer::File.new("file://./relativepath/thing")
  #    r.uri.scheme.should == "file"
  #    r.uri.path.start_with?('/').should == true
  #  end
  #end
  #
  #describe "File to File Copy" do
  #  it "Test source file 'src.txt' should exist" do
  #    File.exists?(@source_file_path).should be_true
  #  end
  #  it "Should copy a file from one place to another" do
  #    File.delete(@destination_file_path) if File.exists?(@destination_file_path)
  #    Xeroxer.copy2(@source_file_uri, @destination_file_uri)
  #    File.exists?(@destination_file_path).should be_true
  #    File.zero?(@destination_file_path).should be_false
  #  end
  #end
  #
  #describe "File to File Put" do
  #  it "Test source file 'src.txt' should exist" do
  #    File.exists?(@source_file_path).should be_true
  #  end
  #  it "Should put a file from one place to another" do
  #    File.delete(@destination_file_path) if File.exists?(@destination_file_path)
  #    Xeroxer.getput2(@source_file_uri, @destination_file_uri)
  #    File.exists?(@destination_file_path).should be_true
  #    File.zero?(@destination_file_path).should be_false
  #  end
  #end
  #
  #describe "File to S3 Copy" do
  #  it "Test source file 'src.txt' should exist" do
  #    File.exists?(@source_file_path).should be_true
  #  end
  #  it "Should copy a file to s3" do
  #    obj = @bucket.objects[@destination_s3_path]
  #    lambda { obj.delete if obj.exists? }
  #    Xeroxer.putget2(@source_file_uri, @destination_s3_uri)
  #    obj = @bucket.objects[@destination_s3_path]
  #
  #    obj.exists?.should be_true
  #    obj.content_length.should_not == 0
  #  end
  #end
  #
  #describe "S3 to File Copy" do
  #  it "Test source s3 object 'src.txt' should exist" do
  #    obj = @bucket.objects[@source_s3_path]
  #    obj.exists?.should be_true
  #  end
  #  it "Should copy an s3 object from s3 to a file" do
  #    File.delete(@destination_file_path) if File.exists?(@destination_file_path)
  #    Xeroxer.getput2(@source_s3_uri, @destination_file_uri)
  #    File.exists?(@destination_file_path).should be_true
  #    File.zero?(@destination_file_path).should be_false
  #  end
  #end

end

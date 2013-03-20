require 'spec_helper'
require 'aws-sdk'
require 'benchmark'

describe Xeroxer do

  before(:all) do
    access = ENV["s3access"]
    secret = ENV["s3secret"]
    @s3_cred = {:storage => :s3,
                :bucket => "xeroxer_test",
                :path => "xeroxer",
                :s3_domain => "s3.amazonaws.com",
                :s3_protocol => "http",
                :s3_credentials => {}}
               
    #source_file = "bigsrc.mp3"
    #dest_file = "bigdst.mp3"
    #@expected_size = 17587639
    source_file = "src.txt"
    dest_file = "dst.txt"
    @expected_size = 52
    @source_file_uri="file://./spec/resources/#{source_file}"
    @source_file_path=@source_file_uri[9..-1] # URI.parse(@source_file_uri].path
    @destination_file_uri="file://./spec/resources/#{dest_file}"
    @destination_file_path=@destination_file_uri[9..-1]

    @s3 = AWS::S3.new(:access_key_id => @s3_cred[:s3_credentials][:access_key_id],
                      :secret_access_key => @s3_cred[:s3_credentials][:secret_access_key])
    @bucket = @s3.buckets[@s3_cred[:bucket]]

    @source_s3_uri="s3://"+@s3_cred[:bucket]+"."+@s3_cred[:s3_domain]+"/"+@s3_cred[:path]+"/#{source_file}"
    @source_s3_bucket= @s3_cred[:bucket]
    @source_s3_path= @s3_cred[:path]+"/#{source_file}"

    @destination_s3_uri="s3://"+@s3_cred[:bucket]+"."+@s3_cred[:s3_domain]+"/"+@s3_cred[:path]+"/#{dest_file}"
    @destination_s3_bucket= @s3_cred[:bucket]
    @destination_s3_path= @s3_cred[:path]+"/#{dest_file}"


    Xeroxer.config[:s3_credentials] =
                                       {:access_key_id => access,
                                       :secret_access_key => secret }
  end

  describe "Exceptions" do
    it "should rais exception Protocol Not Supported" do
      lambda { Xeroxer.copy("blah", "blah") }.should raise_error Xeroxer::ProtocolNotSupported
    end
  end

  describe "Xerox enumeration" do
    it "should return valid values" do
      r = Xeroxer::S3.new("s3://amazon.s3.com/bucket/thing")
      r.type.should == Xeroxer::BLOCKREAD
      r = Xeroxer::File.new("file:://path/path/thing")
      r.type.should == Xeroxer::NOBLOCKREAD
      #r.type.should == Xeroxer::BLOCKREAD
      r = Xeroxer::HTTP.new("http:://domain.address.com/path/thing")
      r.type.should == Xeroxer::BLOCKREAD
    end
  end

  describe "File url validation" do
    it "should remove the ./ and put in full path" do
      r = Xeroxer::File.new("file://./relativepath/thing")
      r.uri.scheme.should == "file"
      r.uri.path.start_with?('/').should == true
    end
  end
  describe "http url validation" do
    it "should have scheme, domain, port and path" do
      r = Xeroxer::File.new("http://a.b.c:1/apath/thing")
      r.uri.scheme.should == "http"
      r.uri.path.start_with?('/apath').should == true
      r.uri.host.should == "a.b.c"
      r.uri.port.should == 1
      r.uri.to_s.should == "http://a.b.c:1/apath/thing"
    end
  end

  describe "File to File Copy" do
    it "Test source file 'src.txt' should exist" do
      File.exists?(@source_file_path).should be_true
    end
    it "Should copy a file from one place to another" do


      File.delete(@destination_file_path) if File.exists?(@destination_file_path)
      puts "\nCopy file to file"
      time = Benchmark.measure do
        Xeroxer.copy(@source_file_uri, @destination_file_uri)
      end
      puts "   Time:#{time}"

      File.exists?(@destination_file_path).should be_true
      File.zero?(@destination_file_path).should be_false
      uri = @destination_file_uri
      filename = Dir.pwd+uri[8..-1]
      File.stat(filename).size.should == @expected_size
    end
  end

  describe "File to S3 Copy" do
    it "Test source file 'src.txt' should exist" do
      File.exists?(@source_file_path).should be_true
    end
    it "Should copy a file to s3" do
      obj = @bucket.objects[@destination_s3_path]
      lambda { obj.delete if obj.exists? }
      puts "\nCopy file to S3"
      time = Benchmark.measure do
        Xeroxer.copy(@source_file_uri, @destination_s3_uri)
      end
      puts "   Time:#{time}"
      obj = @bucket.objects[@destination_s3_path]

      obj.exists?.should be_true
      obj.content_length.should_not == 0
      obj.content_length.should == @expected_size
    end
  end

  describe "S3 to File Copy" do
    it "Test source s3 object 'src.txt' should exist" do
      obj = @bucket.objects[@source_s3_path]
      obj.exists?.should be_true
    end
    it "Should copy an s3 object from s3 to a file" do
      File.delete(@destination_file_path) if File.exists?(@destination_file_path)
      puts "\nCopy file from S3"
      time = Benchmark.measure do
        Xeroxer.copy(@source_s3_uri, @destination_file_uri)
      end
      puts "   Time:#{time}"
      File.exists?(@destination_file_path).should be_true
      File.zero?(@destination_file_path).should be_false
      uri = @destination_file_uri
      filename = Dir.pwd+uri[8..-1]
      puts File.stat(filename).size
      File.stat(filename).size.should == @expected_size
    end
  end

end

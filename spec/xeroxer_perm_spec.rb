require 'spec_helper'
require 'benchmark'

describe Xeroxer do

  before(:all) do
    access = ENV["s3access"]
    secret = ENV["s3secret"]
    @s3_cred = {:storage => :s3,
                :bucket => "xeroxer-test",
                :path => "xeroxer",
                :s3_domain => "s3.amazonaws.com",
                :s3_protocol => "http",
                :s3_credentials =>  {:access_key_id => access,
                                       :secret_access_key => secret }
               }
               
    # test of larger files:  You will need to get your own.
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

    @s3.buckets.create(@s3_cred[:bucket], :acl => :public_read_write)
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
    @object = @bucket.objects[@source_s3_path]
    content = "you're a big cheese lovell, you're a big cheese you."
    @object.write(content)

    f = File.open(@source_file_path,"w")
    f.write(content)
    f.close

  end

  after(:all) do
    #puts "cleanup, delete #{@destination_file_path} and #{@destination_s3_path}"
    #puts "cleanup, delete #{@source_file_path} and #{@source_s3_path}"
    #puts "delete the test bucket"
    File.delete(@source_file_path) if File.exists?(@source_file_path)
    File.delete(@destination_file_path) if File.exists?(@destination_file_path)
    obj = @bucket.objects[@destination_s3_path]
    obj.delete if obj.exists?
    obj = @bucket.objects[@source_s3_path]
    obj.delete if obj.exists?
    @bucket.delete

    #@s3.buckets.delete(@s3_cred[:bucket])
  end


  describe "S3 Permissions" do
    it "Test source s3 object 'src.txt' should exist" do
      obj = @bucket.objects[@source_s3_path]
      obj.exists?.should be_true
    end
    it "Should change permissions of a file to public" do
      Xeroxer.copy(@source_file_uri, @destination_s3_uri)

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
      puts File.stat(filename).size-10
      File.stat(filename).size.should == @expected_size
    end
  end

end

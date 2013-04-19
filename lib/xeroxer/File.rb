require 'xeroxer/xeroxer_config'

module Xeroxer

  class File < Resource

    def initialize(uri,options={})
      @type = Xeroxer::NOBLOCKREAD
      if uri.instance_of? String
        # if it's a file, we want to suppor trealtive uri's,
        # something that is not standard.
        if uri[0..8].downcase.start_with?("file://./")
          # look for the "./" right after the uri, if it's there,
          # then replace it with the current directory option key
          uri = uri[0..6]+Dir.pwd+uri[8..-1]
        end
        if uri[0..4].downcase.start_with?("file::")
          raise MalformedUrl
        end
      end
      @uri = URI(uri)
    end

    #private
    attr_reader :uri, :file, :type

    def get()
      return file
    end

    def open(direction, &block)
      if (block_given?)
        ::File.open(@uri.path, direction, &block)
      else
        @file = ::File.open(@uri.path, direction)
      end
    end

    def write(resource)
      case resource.type
        when Xeroxer::BLOCKREAD # S3, file doesn't have block read.
          resource.read() do |buff|
            @file.write(buff)
          end
        when Xeroxer::NOBLOCKREAD # file. (non streaming with s3: hangs.)
          while (buff = resource.read())
            @file.write(buff)
          end
      end
      close()
    end

    def read(&block)
      raise Exceptions::BlockReadNotSupported if (block_given?)
      # this is too slow: return @file.each_byte &block if (block_given?)
      return @file.read(Xeroxer.config[:buffer_size])
    end

    def close()
      @file.close()
    end

  end
end


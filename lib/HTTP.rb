module Xeroxer
  class HTTP
    def initialize(uri)
      @type=Xeroxer::GETPUT
      @uri=uri
    end

    #private
    attr_reader :uri, :file, :type

    def open(direction, &block)
      if (block_given?)
        ::File.open(@uri.path, direction, &block)
      else
        @file = ::File.open(@uri.path, direction)
      end
    end

    def read(&block)
      if (block_given?)
        return @file.each_byte &block
      else
        return @file.read
      end

    end

    def write(chunk)
      @file.write(chunk)
    end

    def close()
      @file.close()
    end

    def put(data)
      return true
    end
  end
end
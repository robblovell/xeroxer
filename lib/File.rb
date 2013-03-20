require 'xeroxer'
require 'fileutils'
module Xeroxer
  class File
    def initialize(uri)
      @type = Xeroxer::OPENCLOSE
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
    attr_reader :uri,:file,:type

    def open(direction, &block)
      if (block_given?)
        ::File.open(@uri.path,direction, &block)
      else
        @file = ::File.open(@uri.path,direction)
      end
    end
    
    def read()
      raise Exceptions::BlockReadNotSupported if (block_given?)
      return @file.read(Xeroxer::BUF_SIZE)
    end

    def each_byte(&block)
      if (block_given?)
        return @file.each_byte &block
      else
        return @file.each_byte
      end
    end

    def write(chunk)
      @file.write(chunk)
    end
    def close()
      @file.close()
    end


    ## for files only.
    #def put(source)
    #  ## all tries work below:
    #  ## Open first file, read it, store it, then close it
    #  #input = ::File.open(source.uri.path) {|f| f.read() }
    #  #
    #  ## Open second file, write to it, then close it
    #  #::File.open(@uri.path, 'w') {|f| f.write(input) }
    #
    #  # try 2, 3, and 4 open
    #
    #  src = ::File.open(source.uri.path,'r')
    #  dst = ::File.open(@uri.path,'w')
    #
    #  #try 2
    #  while  (src.read(4096) {|c| dst.write(c) })  do
    #  end
    #
    #  #try 3
    #  #::FileUtils.copy_stream(src, dst)
    #
    #  #try 4
    #  #while buff = src.read(4096)
    #  #  dst.write(buff)
    #  #end
    #
    #  # try 2, 3, 4, and 5 close
    #  src.close
    #  dst.close
    #end
    ## for files only right now.
    #def put(source)
    #  # try 5
    #  ::File.open(source.uri.path,'r') do |src|
    #    ::File.open(@uri.path,'w') do |dst|
    #      src.each_byte do |byte|
    #        dst.write(byte)
    #      end
    #    end
    #  end
    #end

    def get(source)
      src = source.open("r")
      open('w') do |dst|
        while (buff = src.read())
          dst.write(buff)
        end
      end
      src.close
    end

    def put(destination)
      open("r")
      destination.open('w')
      while (buff = read())
        destination.write(buff)
      end
      close
      destination.close
    end
  end
end


module Xeroxer
  class HTTP < Resource
    def initialize(uri,options={})
      @type=Xeroxer::BLOCKREAD
      @uri=uri
    end

    #private
    attr_reader :uri, :type

    def get()
    end

    def open(direction, &block)
    end

    def write(resource)
    end

    def read(&block)
    end

    def close()
    end

  end
end
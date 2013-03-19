module Xeroxer
  class File < Resource
    #private
    attr_reader :uri
    attr_reader :file
      
    initialize(uri)
      @uri = uri
    end

    def open(direction) 
      if (block_given?)
        File.open(@uri.path,direction) { yield }
      else
        @file = File.opwn(@uri.path,direction)
      end
    end
    
    def read()
      
    end 
    def write()
  
    end
    def close()
  
    end   
  end
end
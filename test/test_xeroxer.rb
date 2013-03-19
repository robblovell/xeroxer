require 'helper'

class TestXeroxer < Test::Unit::TestCase
  should "copy a file from one place to another" 
    File.delete("./dst.txt")
    Xerox.Copy("./src.file", "./dst.txt")
    File.zero?("./dst.txt").should be_false
    File.exists?(".dst.txt").should be_true
  end
end

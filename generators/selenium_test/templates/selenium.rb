require File.dirname(__FILE__) + '/selenium_test_helper'   

class <%= class_name %>Test < Test::Unit::TestCase 
  
  def test_go_home
     open '/'  
     assert get_text("//h1") =~ /Heading/
  end


end

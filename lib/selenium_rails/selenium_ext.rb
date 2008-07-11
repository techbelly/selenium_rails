module Selenium
  
  class SeleniumAssertionFailedError < Test::Unit::AssertionFailedError
  end
  
  module PageObjectSupport
    def visits(page_class)
      extend(page_class)      
      open(page_class.location)
    end

    def sees(page_class)
      extend(page_class)
      assert_location
    end
  end

  module BackwardsCompatability
    def type_into(location,text)
      type(location,text)
    end
  
    def click_and_wait(location)
      click(location)
      wait_for_page_to_load(30000)
    end
  end

  module Assertions
    
    def fail_with(text)
      raise SeleniumAssertionFailedError.new(text)
    end
    
    def assert_text_present(text)
      fail_with("#{text} not found in page") unless is_text_present(text)
    end

    def assert_text(location, text)
      fail_with("#{text} not found at #{location}") unless get_text(location) == text
    end

    def assert_location(location)
      relative_path = get_location.gsub(/http:\/\/[^:]*:[^\/]*\//,'/')
      if location[-1,1]=='*'
        location_root = location.gsub('*','')
        fail_with("#{relative_path} does not match not #{location}") unless relative_path.include?(location_root)
      else
        fail_with("#{relative_path} is not #{location}") unless relative_path == location
      end
    end

    def assert_element_not_present(location)
      fail_with("#{location} found in page") if is_element_present(location)
    end

    def assert_element_present(location)
      fail_with("#{location} not found in page") unless is_element_present(location)
    end
  
    def assert_attribute(location,attribute)
      attribute_on_page = get_attribute(location)
      fail_with("#{attribute} not on #{location}") unless attribute_on_page && attribute_on_page == attribute.to_s
    end
  end
  
  
  class SeleneseInterpreter
    def self.new_from_hash(hash)
      new(hash[:server_url],hash[:server_port],hash[:launcher],hash[:aut_url],10000)
    end
    include BackwardsCompatability
    include Assertions
    include SeleniumRails::XPathSugar          
    include PageObjectSupport
  end  
end
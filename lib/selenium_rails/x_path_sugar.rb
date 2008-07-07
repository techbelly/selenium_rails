module SeleniumRails
	module XPathSugar   
	  
	  # human-kind way of generating xpath element locators. Some examples:
	  
	  # link("resource") => //a[text()="resource"]
	  
	  # link_with_class("nav") => //a[@class='nav']
	  # link_with_class_and_title("nav","next") => //a[@class='nav' and @title='next']
	  # input_with_type("select") => //input[@type='select']
	  
	  # in_section("nav",link("Find a tutor")) 
	  #         => div[contains(@class,"nav") or @id="nav"]/descendant::a[text()="Find a tutor"]
	  # (locates anchors with text "Find a tutor" that are descendants of a div with class or id "nav")
	  
	  # element_with_class("hello") => //.[@class='hello']
    
    HTML_ELEMENTS = %w[ textarea label input select h1 h2 h3 h4 h5 h6 a link p div ul ol li element]
    
    def element(id)
      return element_with_id(id)
    end
	  
	  def link(text)
	    return link_with_text(text)
	  end
	  
	  def in_section(class_or_id,xpath)
	    rootless_xpath = xpath.gsub(/^\/\//,'')
	    return "div[contains(@class,\"#{class_or_id}\") or @id=\"#{class_or_id}\"]/descendant::#{rootless_xpath}"
	  end
	  
	  def build_xpath(method_name,*values)                  
	    match, element, att_str = */([a-z0-9]*)_with_([_a-z0-9]*)/.match(method_name.to_s)    
	    if match && HTML_ELEMENTS.include?(element)  
	      
	      element = 'a' if element == 'link'
	      element = '.' if element == 'element'
	      
    	  attributes = att_str.split('_and_')
    	  attributes = attributes.map {|a| 
    	    if a == 'text'
    	      "text()=\"#{values.shift}\""
    	    else
    	      "@#{a}=\"#{values.shift}\""
  	      end
    	  }
    	  xpath = "//#{element}[#{attributes.join(' and ')}]"
	    else
	      non_xpath_method_missing(method_name,*values)
	    end  
 	  end
		
		def self.included(base)
        base.class_eval do
          alias_method :non_xpath_method_missing, :method_missing unless method_defined?(:non_xpath_method_missing)
          alias_method :method_missing, :build_xpath
        end
    end
	end
end
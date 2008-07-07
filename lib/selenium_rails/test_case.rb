module SeleniumRails
module TestCase
  
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  def selenium_session(session= nil)
    self.class.selenium_session(session)
  end
  
   # Overrides standard "open" method with @selenium.open
    def open(addr)
      selenium_session.open(addr)
    end

    # Overrides standard "type" method with @selenium.type
    def type(inputLocator, value)
      selenium_session.type(inputLocator, value)
    end

    # Overrides standard "select" method with @selenium.select
    def select(inputLocator, optionLocator)
      selenium_session.select(inputLocator, optionLocator)
    end
  
  def method_missing(method_name, *args)
    if args.empty?
        selenium_session.send(method_name)
    else
        selenium_session.send(method_name, *args)
    end
  end
  
  module ClassMethods         
    @@sessions = []  
      
    def acceptance_test(name,&block)
       class_eval do
    	   define_method("test_"+name.underscore) do
   	       instance_eval &block
         end
       end
    end
    
    def new_selenium_session(session=nil)  
      session ||= Selenium::SeleneseInterpreter.new("localhost", 4444, "*firefox", "http://localhost:4001", 10000);   
      yield session if block_given?
      session.start
   	  @@sessions << session
   	  return session
    end
  
    def selenium_session(session = nil)     
      @@sessions.last || new_selenium_session(session)
    end
  
    def close_selenium_sessions 
      while (s = @@sessions.pop) do
        s.stop
      end       
    end
  end
end
end
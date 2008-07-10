module SeleniumRails
module TestCase
  
  def selenium_session
    SeleniumRails::Runner.selenium_session
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
end
end
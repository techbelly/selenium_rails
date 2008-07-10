module SeleniumRails
  module Session
   
   class LocalFirefox
      def initialize
        @session = Selenium::SeleniumDriver.new("localhost", 4444, "*firefox", "http://localhost:4001", 10000)
        @infrastructure = RailsApplication.default, SeleniumRC.new, @session
      end
      
      def start
        @infrastructure.each { |i| i.start }
      end
      
      def stop
        @infrastructure.reverse.each { |i| i.stop }
      end
      
      def method_missing(method_name,*args)
        if args.empty?
           @session.send(method_name)
        else
           @session.send(method_name, *args)
        end
      end
   end
   
   def default
     LocalFirefox
   end
    
   extend(self)
    
  end
end
module SeleniumRails
  module Session
   
   class Base
     def initialize(hash)
       @session = Selenium::SeleniumDriver.new_from_hash(hash)
     end
     
     def start
       @required_services.each { |i| i.start }
     end
     
     def stop
       @required_services.reverse.each { |i| i.stop }
     end
     
     def method_missing(method_name,*args)
       if args.empty?
          @session.send(method_name)
       else
          @session.send(method_name, *args)
       end
     end
     
     def local_ip
       Socket::getaddrinfo(Socket.gethostname,"echo",Socket::AF_INET)[0][3] 
     end
   end
   
   class LocalFirefox < Base
      def initialize
        @session = Selenium::SeleniumDriver.new("localhost", 4444, "*firefox", "http://localhost:4001", 10000)
        @required_services = RailsApplication.default, LocalSeleniumRC.new, @session
      end
   end
   
   class GridIE7 < Base
      def initialize
        @session = Selenium::SeleniumDriver.new("localhost", 4445, "*custom C:\\Program Files\\Internet Explorer\\iexplore.exe", "http://#{local_ip}:4001", 10000)
        @required_services = RailsApplication.default, VirtualBoxRC.new("'Windows XP'",4445), @session
      end
   end
   
   class GridIE6 < Base
      def initialize
        @session = Selenium::SeleniumDriver.new("localhost", 4445, "*custom C:\\Program Files\\MultipleIEs\\IE6\\iexplore.exe", "http://#{local_ip}:4001", 10000)
        @required_services = RailsApplication.default, VirtualBoxRC.new("'Windows XP'",4445), @session
      end
   end
   
   class GridFirefox2 < Base
      def initialize
        @session = Selenium::SeleniumDriver.new("localhost", 4445, "*custom C:\\Program Files\\Firefox\\v2\\firefox.exe", "http://#{local_ip}:4001", 10000)
        @required_services = RailsApplication.default, VirtualBoxRC.new("'Windows XP'",4445), @session
      end
   end

   class GridFirefox3 < Base
      def initialize
        @session = Selenium::SeleniumDriver.new("localhost", 4445, "*custom C:\\Program Files\\Firefox\\v3\\firefox.exe", "http://#{local_ip}:4001", 10000)
        @required_services = RailsApplication.default, VirtualBoxRC.new("'Windows XP'",4445), @session
      end
   end   
   
   def default
     LocalFirefox
     #GridIE6
     #GridFirefox3
   end
    
   extend(self)
    
  end
end

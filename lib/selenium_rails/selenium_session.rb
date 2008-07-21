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
   end
   
   class LocalFirefox
      include Infrastructure
      def initialize
        @session = Selenium::SeleniumDriver.new("localhost", 4444, "*firefox", "http://localhost:4001", 10000)
        @infrastructure = RailsApplication.default, SeleniumRC.new, @session
      end
   end
   
   class GridIE7
      include Infrastructure
      def initialize
        local_ip = IPSocket.getaddress(Socket.gethostname)
        @session = Selenium::SeleniumDriver.new("localhost", 4445, "*custom C:\\Program Files\\Internet Explorer\\iexplore.exe", "http://#{local_ip}:4001", 10000)
        @infrastructure = RailsApplication.default, VirtualBoxRC.new("'Windows XP'",4445), @session
      end
   end
   
   class GridIE6
      include Infrastructure
      def initialize
        local_ip = IPSocket.getaddress(Socket.gethostname)
        @session = Selenium::SeleniumDriver.new("localhost", 4445, "*custom C:\\Program Files\\MultipleIEs\\IE6\\iexplore.exe", "http://#{local_ip}:4001", 10000)
        @infrastructure = RailsApplication.default, VirtualBoxRC.new("'Windows XP'",4445), @session
      end
   end
   
   class GridFirefox2
      include Infrastructure
      def initialize
        local_ip = IPSocket.getaddress(Socket.gethostname)
        @session = Selenium::SeleniumDriver.new("localhost", 4445, "*custom C:\\Program Files\\Firefox\\v2\\firefox.exe", "http://#{local_ip}:4001", 10000)
        @infrastructure = RailsApplication.default, VirtualBoxRC.new("'Windows XP'",4445), @session
      end
   end

   class GridFirefox3
      include Infrastructure
      def initialize
        local_ip = IPSocket.getaddress(Socket.gethostname)
        @session = Selenium::SeleniumDriver.new("localhost", 4445, "*custom C:\\Program Files\\Firefox\\v3\\firefox.exe", "http://#{local_ip}:4001", 10000)
        @infrastructure = RailsApplication.default, VirtualBoxRC.new("'Windows XP'",4445), @session
      end
   end   
   
   def default
     #LocalFirefox
     GridIE6
     #GridFirefox3
   end
    
   extend(self)
    
  end
end
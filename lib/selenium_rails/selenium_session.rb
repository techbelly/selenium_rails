module SeleniumRails
  module Session
   
   module Infrastructure
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
   
   class LocalFirefox
      include Infrastructure
      def initialize
        @session = Selenium::SeleniumDriver.new("localhost", 4444, "*firefox", "http://localhost:4001", 10000)
        @infrastructure = RailsApplication.default, SeleniumRC.new, @session
      end
   end
   
   class GridIE6
      include Infrastructure
      def initialize
        local_ip = IPSocket.getaddress(Socket.gethostname)
        @session = Selenium::SeleniumDriver.new("localhost", 8444, "*custom /home/theo/bin/ie6", "http://#{local_ip}:4001", 10000)
        @infrastructure = RailsApplication.default, VirtualBox.new, @session
      end
   end
   
   def default
     GridIE6
   end
    
   extend(self)
    
  end
end
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
   
   class LocalFirefox < Base
      def initialize
        super :server_url => "localhost", 
              :server_port => 4444, 
              :launcher => "*firefox", 
              :aut_url => "http://localhost:4001"
        @required_services = RailsApplication.default, LocalSeleniumRC.new, @session
      end
   end
   
   class GridIE6 < Base
      def initialize
        local_ip = IPSocket.getaddress(Socket.gethostname)
        super :server_url => "localhost", 
              :server_port => 8444, 
              :launcher => "*custom /home/theo/bin/ie6", 
              :aut_url => "http://#{local_ip}:4001"
        @required_services = RailsApplication.default, VirtualBoxRC.new, @session
      end
   end
   
   def default
     LocalFirefox
   end
    
   extend(self)
    
  end
end
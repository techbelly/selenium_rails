require 'net/http'

module SeleniumRails
  class SeleniumRC
      def initialize(host = "localhost", port = 4444)
        @port,@host = port,host
      end
      
      def wait_on(max_tries = 20)
        count = 0
        while ( (not yield) && count < max_tries)
          sleep 1
          count += 1
        end
      end
    
      def up_and_running?
        tell_selenium('testComplete','fake_session_id')
      end

      def tell_selenium(command, session = nil)
        command = "http://#{@host}:#{@port}/selenium-server/driver/?cmd=#{command}"
        command += "&session=#{session}" if session
        uri = URI.parse(command)
        begin
          request = Net::HTTP::Get.new(uri.path+"?"+uri.query)
          res = Net::HTTP.start(uri.host,uri.port) { |http|
            http.read_timeout = 30
            http.request(request)
          }
          return true
        rescue 
          return false
        end
      end
  end
  
  class LocalSeleniumRC < SeleniumRC
      
    def start()
      unless up_and_running?
        @already_running = false
        ['INT','TERM'].each { |signal| trap(signal) { stop_local } }
        Thread.new do
          start_local
        end
        wait_on { up_and_running? }
      else
        @already_running = true
      end
    end
    
    def stop
      unless @already_running
        stop_local
        wait_on { not up_and_running? }
      end
    end
    
    private
    
    def start_local
      selenium_jar_file = File.join(File.dirname(__FILE__), "../../bin/selenium-server.jar")
      command = "java -jar #{selenium_jar_file} -port #{@port}"
      system(command)
    end
    
    def stop_local
      tell_selenium('shutDown')
    end
    
  end
end
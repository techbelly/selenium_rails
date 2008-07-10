require 'net/http'

module SeleniumRails
  class SeleniumRC
  
    def start()
      unless java_started?
        puts "Attempting to start selenium server."
        @already_running = false
        ['INT','TERM'].each { |signal| 
          trap(signal) { java_stop() }
        }
        Thread.new do
          java_start()
        end
        wait_on { java_started? }
      else
        @already_running = true
      end
    end
    
    def stop
      unless @already_running
        java_stop
        wait_on { not java_started? }
      end
    end
    
    private
    
    def wait_on(max_tries = 20)
      count = 0
      while ( (not yield) && count < max_tries)
        sleep 1
        count += 1
      end
    end
    
    def java_start
      selenium_jar_file = File.join(File.dirname(__FILE__), "../../bin/selenium-server.jar")
      command = "java -jar #{selenium_jar_file}"
      system(command)
    end
    
    def java_stop
      tell_selenium('shutDown')
    end
    
    def java_started?
      tell_selenium('testComplete','fake_session_id')
    end
    
    def tell_selenium(command, session = nil)
      command = "http://127.0.0.1:4444/selenium-server/driver/?cmd=#{command}"
      command += "&session=#{session}" if session
      uri = URI.parse(command)
      begin
        request = Net::HTTP::Get.new(uri.path+"?"+uri.query)
        res = Net::HTTP.start(uri.host,uri.port) { |http|
          http.read_timeout = 5
          http.request(request)
        }
        return true
      rescue 
        return false
      end
    end
   
  end
end
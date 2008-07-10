module SeleniumRails
  class VirtualBox
  
    def initialize(vm = "Ubuntu")
      @vm = vm
    end
  
    def start
      system("VBoxManage startvm #{@vm}")
      wait_on { vbox_started? }
    end
    
    def stop
      system("VBoxManage controlvm #{@vm} poweroff && sleep 5 && VBoxManage snapshot #{@vm} discardcurrent -state")
    end
  
      def wait_on(max_tries = 20)
        count = 0
        while ( (not yield) && count < max_tries)
          puts "Trying again: #{count}"
          sleep 1
          count += 1
        end
      end
  
      def vbox_started?
        tell_selenium('testComplete','fake_session_id')
      end

      def tell_selenium(command, session = nil)
        command = "http://localhost:8444/selenium-server/driver/?cmd=#{command}"
        command += "&session=#{session}" if session
        uri = URI.parse(command)
        begin
          request = Net::HTTP::Get.new(uri.path+"?"+uri.query)
          res = Net::HTTP.start(uri.host,uri.port) { |http|
            http.read_timeout = 1000
            http.request(request)
          }
          return true
        rescue 
          return false
        end
      end
  
  end
end
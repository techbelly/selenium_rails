module SeleniumRails
  class VirtualBox
  
    def initialize(vm = "Ubuntu", port = 8444)
      @vm = vm
      # TODO: The port should be captured from the session, not repeated like it is currently
      @port = port
      output = `VBoxManage showvminfo #{@vm}`
      @state = /State: +([a-z]+)/.match(output).to_a[1]
    end
  
    def start
      unless vbox_started?
        system("VBoxManage snapshot #{@vm} discardcurrent -state") unless vbox_saved?
        system("VBoxManage startvm #{@vm}") 
      end
      wait_on { selenium_rc_started? }
    end
    
    def stop
      #system("VBoxManage controlvm #{@vm} poweroff && sleep 5 && VBoxManage snapshot #{@vm} discardcurrent -state")
    end
    
    def vbox_saved?
      @state == "saved"
    end
    
    def vbox_started?
      @state == "running"
    end
  
      def wait_on(max_tries = 20)
        count = 0
        while ( !(yield) && count < max_tries)
          puts "Trying again: #{count}"
          sleep 1
          count += 1
        end
      end
  
      def selenium_rc_started?
        tell_selenium('testComplete','fake_session_id')
      end

      def tell_selenium(command, session = nil)
        command = "http://localhost:#{@port}/selenium-server/driver/?cmd=#{command}"
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
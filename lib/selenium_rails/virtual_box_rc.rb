require 'selenium_rc'

module SeleniumRails
  class VirtualBoxRC < SeleniumRC
  
    # Expects a pre-prepared VirtualBox snapshot image that starts with a running
    # selenium_server.jar. Expects that image to be accessible from
    # localhost, and mapped to a particular port
  
    def initialize(vm = "Ubuntu", host = "localhost", port = 8444)
      super(host,port)
      @vm = vm
    end
  
    def start
      system("VBoxManage startvm #{@vm}")
      wait_on { up_and_running? }
    end
    
    def stop
      # we sleep between the two commands because otherwise they trip over each other. 
      # probably should work out a better way to do this.
      system("VBoxManage controlvm #{@vm} poweroff && sleep 5 && VBoxManage snapshot #{@vm} discardcurrent -state")
    end
  
  end
end
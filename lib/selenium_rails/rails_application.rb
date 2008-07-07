require 'webrick_server'

module SeleniumRails
  class RailsApplication
  	include WEBrick::HTMLUtils
  	
  	def self.standard
  	 aut_options = {
		    :port        => 4001,
		    :ip          => "127.0.0.1",
		    :server_root => File.expand_path(RAILS_ROOT + "/public/"),
		    :working_directory => File.expand_path(RAILS_ROOT)
		  }
		  return new(aut_options)
	  end

    def initialize(options={})
      Socket.do_not_reverse_lookup = true # patch for OS X
      @timeout = 1000    
      @aut_server = WEBrick::HTTPServer.new(
        :ServerType => Thread,
        :Port => options[:port],
        :Logger => WEBrick::BasicLog.new(nil, WEBrick::BasicLog::WARN), #comment out to enable server logging
        :AccessLog => {} #comment out to enable access logging
      )
      @aut_server.mount('/', DispatchServlet, options)
    end
  	
  	def start
  		@aut_server.start
  	end

    def stop
  		@aut_server.shutdown
  	end
  end
end
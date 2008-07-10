require 'test/unit/ui/console/testrunner'

module SeleniumRails

	class Runner < Test::Unit::UI::Console::TestRunner

    def self.selenium_session
      # yuk, yuk, yuk
      @@session
    end

		def started(result)
			super(result)   
			@@session ||= SeleniumRails::Session.default.new
			@@session.start
		end
	
		def finished(elapsed_time)
		  @@session.stop
			super(elapsed_time)
		end
	end

end
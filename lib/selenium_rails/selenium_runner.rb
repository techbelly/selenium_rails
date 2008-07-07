require 'test/unit/ui/console/testrunner'

module SeleniumRails

	class Runner < Test::Unit::UI::Console::TestRunner

		def started(result)
			super(result)   
			@seleniumRC = SeleniumRC.new
			@application = RailsApplication.standard
			@seleniumRC.start
			@application.start
		end
	
		def finished(elapsed_time)
			super(elapsed_time)
			@application.stop
			Test::Unit::TestCase.close_selenium_sessions
			@seleniumRC.stop      
		end
	end

end
require 'selenium'
require 'test/unit'

Dir[File.join(File.dirname(__FILE__), "selenium_rails/*.rb")].sort.each { |lib| require lib }

class Test::Unit::TestCase
  include SeleniumRails::TestCase unless ancestors.include?(SeleniumRails::TestCase)
 	include SeleniumRails::XPathSugar
 	include SeleniumRails::WithMethod
end

at_exit do
  unless $! || Test::Unit.run? then
    r = Test::Unit::AutoRunner.new(false)
    r.process_args
    r.runner = proc do |r|
      require 'selenium_rails/selenium_runner'
      SeleniumRails::Runner
    end
    exit r.run
  end
end
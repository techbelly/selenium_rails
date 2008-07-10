require 'rake/testtask'                          

namespace :test do
  desc "Starts the java selenium proxy."
  task(:selenium_proxy) do  
    # Must be a better way...
    `java -jar vendor/plugins/selenium_rails/bin/selenium-server.jar`
  end

  desc "Run the acceptance tests in test/selenium"
  Rake::TestTask.new(:selenium => 'db:test:prepare') do |t|
    t.libs << "test"
    t.pattern = 'test/selenium/*_test.rb'
    t.verbose = true
  end

end
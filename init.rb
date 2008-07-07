# Make sure that plugin only loaded in testing environments
envs = ['test','acceptance']

if envs.include? RAILS_ENV
  $LOAD_PATH << lib_path
  $LOAD_PATH << lib_path + "/selenium_rails"
else
  $LOAD_PATH.delete lib_path
  $LOAD_PATH.delete lib_path + "/selenium_rails"
end

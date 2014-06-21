def append_load_path(*paths)
  full_path = File.join([File.dirname(__FILE__), ".."] << paths)
  $: << File.expand_path(full_path)
end

append_load_path('')
append_load_path('lib')

require 'daedal-sl'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
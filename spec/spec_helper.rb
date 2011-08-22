require "rubygems"
require "bundler/setup"

require "simplecov"
SimpleCov.start do
  add_filter "/spec/"
end

require "rspec"
require "rr"
require "support/display_message_matcher"

RSpec.configure do |config|
  config.color_enabled = true
  config.include DisplayMessageMatcher
  config.after { RR.reset }
end


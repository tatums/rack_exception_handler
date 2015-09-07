$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rack_exception_handler'
require "rspec-html-matchers"
require "pry"

RSpec.configure do |config|
  config.include RSpecHtmlMatchers
end

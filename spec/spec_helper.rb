require 'rack/test'
require 'rspec'

require "securerandom"


ENV['RACK_ENV'] = 'test'

require File.expand_path '../../main.rb', __FILE__

Nap.auto_migrate!
User.auto_migrate!

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

# For RSpec 2.x
RSpec.configure { |c| c.include RSpecMixin }

def redirects_to_index?
  expect(last_response).to be_redirect
  follow_redirect!
  expect(last_response).to be_ok
end
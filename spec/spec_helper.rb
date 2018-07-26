$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "wealthforge-ruby"
require "factory_girl"
require "vcr"

VCR.configure do |config|
  # config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock # or :fakeweb
  config.ignore_hosts '127.0.0.1', 'localhost', 'ci.wealthforge.org', 'api.wealthforge.org'
end

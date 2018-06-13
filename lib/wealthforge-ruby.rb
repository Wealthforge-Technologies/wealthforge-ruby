require "wealthforge/configuration"
require "wealthforge/api_exception"
require "wealthforge/connection"
require "wealthforge/investment"
require "wealthforge/issuer"
require "wealthforge/offering"
require "wealthforge/stash"

module WealthForge

  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end

end

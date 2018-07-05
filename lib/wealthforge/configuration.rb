
module WealthForge
  class Configuration

    attr_accessor :environment
    attr_accessor :version
    attr_accessor :test


    def initialize
      @test = nil
      @environment = 'local'
      @version = 'v1'
    end

  end
end

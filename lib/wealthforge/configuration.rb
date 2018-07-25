
module WealthForge
  
  class Configuration

    attr_accessor :environment
    attr_accessor :version

    def initialize
      @environment = 'local'
      @version = 'v1'
    end

  end
end


module WealthForge
  class Configuration

    attr_accessor :wf_crt
    attr_accessor :wf_key
    attr_accessor :wf_crt_file
    attr_accessor :wf_key_file
    attr_accessor :environment
    attr_accessor :version


    def initialize
      @wf_crt      = nil
      @wf_key      = nil
      @wf_crt_file = nil
      @wf_crt_key  = nil
      @environment = ''
      @version = 'v1'
    end

  end
end

require 'openssl'
require 'faraday'
require 'json'
require 'csv'
require 'timeout'
require 'resolv-replace'


class WealthForge::Connection

  def self.post(endpoint, params)
    begin
      response = connection.post do |req|
        req.url endpoint
        req.headers['Content-Type'] = 'application/json'
        req.body = prep_params(params)
      end
      JSON.parse(response.body, symbolize_names: true)
    rescue => e
      raise WealthForge::ApiException.new(e)
    end
  end


  def self.put(endpoint, params)
    begin
      response = connection.put do |req|
        req.url endpoint
        req.headers['Content-Type'] = 'application/json'
        req.body = prep_params(params)
      end
      JSON.parse(response.body, symbolize_names: true)
    rescue => e
      raise WealthForge::ApiException.new(e)
    end
  end


  def self.get(endpoint, params, raw=false)
    begin
      response = connection.get do |req|
        req.url endpoint
        req.headers['Content-Type'] = 'application/json'
        req.body = prep_params(params)
      end
      raw == false ? JSON.parse(response.body, symbolize_names: true) : response.body
    rescue => e
      raise WealthForge::ApiException.new(e)
    end
  end





  def self.prep_params(params)
    return if params.nil?
    wf_params = {}
    params.each do |key, value|
      wf_params[key.to_s.camelize(:lower)] = value
    end
    wf_params.to_json
  end

  def self.api_endpoint
    api_endpoint = ''
    unless WealthForge.configuration.environment.nil?
      case WealthForge.configuration.environment
        when 'local'
          api_endpoint = "http://localhost:4000/#{WealthForge.configuration.version}/"
        when 'ci'
          api_endpoint = "https://ci.wealthforge.org/wfh-api/#{WealthForge.configuration.version}/"
        when 'qa1'
          api_endpoint = "https://api.wealthforge.org/#{WealthForge.configuration.version}/"
        when 'stage'
          api_endpoint = '__TODO__' #TODO
        when 'prod'
          api_endpoint = '__TODO__' #TODO
        else
          puts '__ERROR__: Invalid environment in Configuration'
      end
    end
    return api_endpoint

  end


  def self.connection
    # api_endpoint = (!WealthForge.configuration.environment.nil? and WealthForge.configuration.environment.eql? 'production') ?
    #   'https://www.capitalforge.com/capitalforge-transaction/api/' :
    #   'https://sandbox.capitalforge.com/capitalforge-transaction/api/'

    return Faraday.new(:url => api_endpoint) do |faraday|
      faraday.request :url_encoded
      faraday.headers['token'] = self.token
      faraday.adapter Faraday.default_adapter
    end
  end

  def self.retrieve_authorization
    file = File.read('configs/config.json')
    config_data = JSON.parse(file)

    # when does the token expire????
    # save in the config.json????


  end

  def self.token
    # TODO: un-hardcode these!!!!!!!


    # wf_cert = 'TN58k1nteFQn3e4cmliVSOdJZXIKGC0g'
    # wf_key = 'LNyY-L3H4XuotbKQdzWFV2BT9AzIxhjvygMTZrgKTCD4uw9efN73IBBU9h94WtdX'
    # wf_cert = !WealthForge.configuration.wf_crt.nil? ? WealthForge.configuration.wf_crt : File.read(WealthForge.configuration.wf_crt_file)
    # wf_key  = !WealthForge.configuration.wf_key.nil? ? WealthForge.configuration.wf_key : File.read(WealthForge.configuration.wf_key_file)
    self.retrieve_authorization #TODO:____________############
    # no creds on local
    if WealthForge.configuration.environment == 'local'
      return ''
    end

      bod = "{\"data\":{\"attributes\":{\"clientId\":\"#{wf_cert}\",\"clientSecret\":\"#{wf_key}\"},\"type\":\"tokens\"}}"
    cert = Faraday.new.post(api_endpoint + 'auth/tokens') do |faraday|
      faraday.body = bod
    end.body
    # TODO: this probably shouldnt be requested every time

    return 'Bearer ' + JSON.parse(cert)['data']['attributes']['accessToken']

  end

end

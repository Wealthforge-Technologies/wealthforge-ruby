require 'openssl'
require 'faraday'
require 'json'
require 'csv'
require 'timeout'
require 'resolv-replace'


class WealthForge::Connection

  def initialize()
    @wf_key
    @wf_cert
    @wf_token
  end


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

    # check if token has expired, if so then get the token again and try again
    if response.status == 401
      retrieve_authorization

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

  return response

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

    # check if token has expired, if so then get the token again and try again
    if response.status == 401
      retrieve_authorization

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

  return response

  end


  def self.get(endpoint, params, raw = false)

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

    # check if token has expired, if so then get the token again and try again
    if response.status == 401

      retrieve_authorization

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

  return response

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
          puts '__ERROR__: Invalid environment in configuration'
      end
    end
    return api_endpoint

  end


  def self.connection
    if @wf_token.nil?
    @wf_token = 'dummy token'
    end

    return Faraday.new(:url => api_endpoint) do |faraday|
      faraday.request :url_encoded
      faraday.headers['authorization'] = @wf_token
      faraday.adapter Faraday.default_adapter
      faraday.use Faraday::Response::RaiseError
      faraday.use CustomErrors

    end

  end


  def self.retrieve_token

    # no creds on local
    if WealthForge.configuration.environment == 'local'
      return ''
    end

    # get the cert and key if not retrieved from configs yet
    if @wf_cert.nil? && @wf_key.nil?
      self.retrieve_authorization
    end

    bod = "{\"data\":{\"attributes\":{\"clientId\":\"#{@wf_cert}\",\"clientSecret\":\"#{@wf_key}\"},\"type\":\"tokens\"}}"
    cert = Faraday.new.post(api_endpoint + 'auth/tokens') do |faraday|
      faraday.body = bod
    end.body

    @wf_token = 'Bearer ' + JSON.parse(cert)['data']['attributes']['accessToken']

  end


  def self.retrieve_authorization

    begin
      file = File.read('configs/config.json')
      config_data = JSON.parse(file)
      file.close
    rescue => err
      p '__ERROR__ Please make a config file in configs/'
      puts "Exception: #{err}"
      err
    end

    if config_data['wf_cert'].nil? || config_data['wf_key'].nil?
      p '__ERROR__ Please config the key and cert in configs/config.json'
    else
      @wf_cert = config_data['wf_cert']
      @wf_key = config_data['wf_key']
    end
    @wf_token = retrieve_token

  end

end


class CustomErrors < Faraday::Response::RaiseError

  def on_complete(env)
    case env[:status]
    when 400
      raise "400 (Bad Request) Response: \n #{JSON.parse(env['body'])}"
    when 422
      raise "422 (Unprocessable Entity) Response: \n #{JSON.parse(env['body'])}"
    when 500
      raise "500 (Internal Server Error) Response: \n #{JSON.parse(env['body'])}"
    when 400...600
      p "Response Body: \n#{JSON.parse(env['body'])}"
      super
    else
      super
    end
  end

end

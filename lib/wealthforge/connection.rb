require 'openssl'
require 'faraday'
require 'json'
require 'csv'
require 'timeout'
require 'resolv-replace'
require 'pp'

class WealthForge::Connection

  def initialize()
    # @wf_client_id
    # @wf_client_secret
    # @wf_token
    # @environment
  end

  def self.post(endpoint, params)

    # try to make the call
    begin
      response = connection.post do |req|
        req.url endpoint
        req.headers['Content-Type'] = 'application/json'
        req.body = prep_params(params)
      end
    rescue => e
      # if failed then probably a 401 error so go get auth but dont raise error
      retrieve_authorization
    end

    # try again with auth
    begin
      response = connection.post do |req|
        req.url endpoint
        req.headers['Content-Type'] = 'application/json'
        req.body = prep_params(params)
      end
    rescue => e
      raise WealthForge::ApiException.new(e)
    end

    return response

  end


  def self.get(endpoint, params)
    begin
      response = connection.get do |req|
        req.url endpoint
        req.headers['Content-Type'] = 'application/json'
        req.body = prep_params(params)
      end
    rescue => e
      # if failed then probably a 401 error so go get auth but dont raise error
      retrieve_authorization
    end

    begin
      response = connection.get do |req|
        req.url endpoint
        req.headers['Content-Type'] = 'application/json'
        req.body = prep_params(params)
      end
    rescue => e
      raise WealthForge::ApiException.new(e)
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
    case @environment
      when 'prod'
        api_endpoint = '__TODO__' #TODO
      else
        api_endpoint = "http://localhost:4000/#{WealthForge.configuration.version}/"

    end
    return api_endpoint
  end

  def self.tokens_endpoint
    case @environment
      when 'prod'
        tokens_endpoint = '__TODO__' #TODO
      else
        tokens_endpoint = "https://ci.wealthforge.org/wfh-api/v1/auth/tokens"
    end
    return tokens_endpoint

  end


  def self.connection
    if @wf_token.nil?
    @wf_token = 'Bearer dummy token'
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

    auth_url = tokens_endpoint
    # pp tokens_endpoint
    # pp @wf_client_secret
    # pp @wf_client_id
    # pp @environment + '  ENV '

    bod = "{\"data\":{\"attributes\":{\"clientId\":\"#{@wf_client_id}\",\"clientSecret\":\"#{@wf_client_secret}\"},\"type\":\"tokens\"}}"
    cert = Faraday.new.post(tokens_endpoint) do |faraday|
      faraday.body = bod
    end.body
   
    @wf_token = 'Bearer ' + JSON.parse(cert)['data']['attributes']['accessToken']
  end


  def self.retrieve_authorization
    begin
      file = File.read('configs/config.json')
      config_data = JSON.parse(file)
    rescue Errno::ENOENT => err
      raise "__ERROR__ Please make a config file in configs/config.json    Exception: #{err.__id__}"
    end

    if config_data['wf_client_secret'].nil? || config_data['wf_client_id'].nil?
      p '__ERROR__ Please verify the key and cert are in configs/config.json'
    else
      @wf_client_secret = config_data['wf_client_secret']
      @wf_client_id = config_data['wf_client_id']
      @environment = config_data['environment']
    end
    @wf_token = retrieve_token
  end
end


class CustomErrors < Faraday::Response::RaiseError

  def on_complete(env)
    case env[:status]
    when 400
      raise "400 (Bad Request) Response: \n #{JSON.parse(env['body'])}"
    when 401
      # dont fail because it probably means the auth failed
      # p "401 (Bad Request) (Probably need to renew token)"
    when 422
      raise "422 (Unprocessable Entity) Response: \n #{JSON.parse(env['body'])}"
    when 500
      raise "500 (Internal Server Error) Response: \n #{JSON.parse(env['body'])}"
    when 400...600
      p "Response Body: #{env['body']}"
      super
    else
      super
    end
  end

end

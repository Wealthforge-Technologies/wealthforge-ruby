require 'openssl'
require 'faraday'
require 'json'
require 'csv'
require 'timeout'
require 'resolv-replace'
require 'pp'

class WealthForge::Connection

  def self.post(endpoint, params)
    begin
      retrieve_authorization
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


  def self.connection

    return Faraday.new(:url => @api_endpoint) do |faraday|
      faraday.request :url_encoded
      faraday.headers['Authorization'] = @wf_token
      faraday.adapter Faraday.default_adapter
      faraday.use Faraday::Response::RaiseError
      faraday.use CustomErrors
    end

  end

  def self.retrieve_authorization
    begin
      file = File.read('configs/config.json')
      config_data = JSON.parse(file)
    rescue Errno::ENOENT => err
      raise "__ERROR__ Please make a config file in configs/config.json    Exception: #{err.__id__}"
    end

    if config_data['wf_client_id'].nil? || config_data['wf_client_secret'].nil?
      p '__ERROR__ Please verify the key and cert are in configs/config.json'
    else
      # set variables 
      @wf_client_id = config_data['wf_client_id']
      @wf_client_secret = config_data['wf_client_secret']
      @token_url = config_data['token_url']
      @api_endpoint = config_data['api_url']
      @environment = config_data['environment']

      # makes a call to get a fresh token
      @wf_token = retrieve_token
    end
  end

  # requests a fresh token after authenticating client using client secret and client id
  def self.retrieve_token
    bod = "{\"data\":{\"attributes\":{\"clientId\":\"#{@wf_client_id}\",\"clientSecret\":\"#{@wf_client_secret}\"},\"type\":\"token\"}}"
    auth = Faraday.new.post(@token_url) do |faraday|
      faraday.body = bod
    end.body

    @wf_token = 'Bearer ' + JSON.parse(auth)['data']['attributes']['accessToken']
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


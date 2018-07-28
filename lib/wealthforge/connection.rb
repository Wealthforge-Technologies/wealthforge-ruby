require 'openssl'
require 'faraday'
require 'json'
require 'csv'
require 'timeout'
require 'resolv-replace'
require 'pp'
require 'jwt'


class WealthForge::Connection

  def self.post(endpoint, params)
    begin
      response = connection.post do |req|
        req.url endpoint
        req.headers['Content-Type'] = 'application/json'
        req.body = prep_params(params)
    end
    rescue => e
      raise WealthForge::ApiException.new(e)
    end
    json_body = JSON.parse(response.body)
    return json_body
  end


  def self.get(endpoint, params)
    begin
      response = connection.get do |req|
        req.url endpoint
        req.headers['Content-Type'] = 'application/json'
        req.body = prep_params(params)
      end
    rescue => e
      raise WealthForge::ApiException.new(e)
    end
    json_body = JSON.parse(response.body)
    return json_body
  end

  def self.file_upload (endpoint, file_path)
    mime_type = MIME::Types.type_for(file_path).first.to_s
    payload = { :file => Faraday::UploadIO.new(file_path, mime_type) }
    begin
    response = connection_multipart.post do |req|
       req.url endpoint
       req.body = payload
    end
    rescue => e
    raise WealthForge::ApiException.new(e)
    end
 
    json_body = JSON.parse(response.body)
    return json_body
  end


  def self.prep_params(params)
    return if params.nil?
    wf_params = {}
    params.each do |key, value|
      wf_params[key.to_s.downcase] = value
    end
    wf_params.to_json
  end


  def self.connection
    set_token
    return Faraday.new(:url => @api_url) do |faraday|
      faraday.request :url_encoded
      faraday.headers['Authorization'] = @wf_token
      faraday.adapter Faraday.default_adapter
      faraday.use CustomErrors
    end
  end

  def self.connection_multipart
    set_token
    return Faraday.new(:url => @api_url) do |faraday|
      faraday.request :multipart
      faraday.headers['Authorization'] = @wf_token
      faraday.adapter Faraday.default_adapter
      faraday.use CustomErrors
    end
  end

  def self.set_token 
    if @wf_token == nil 
      @wf_client_id = ENV["CLIENT_ID"]
      @wf_client_secret = ENV["CLIENT_SECRET"]
      @api_url = ENV["API_URL"]
      @token_url = ENV["TOKEN_URL"]
      @wf_token = retrieve_token
    end

    # test to see if token has expired
    t = @wf_token.reverse.chomp("Bearer ".reverse).reverse
    decoded_token = JWT.decode t, nil, false
    token_exp = decoded_token[0]['exp']
    leeway = 60
    now = Time.now.to_i 
    token_window = token_exp - leeway 
    refresh_token = !(token_window > now)
   
    if refresh_token == true
       # makes a call to get a new token
      @wf_token = retrieve_token
    end 
  end 

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
    # when 400
    #   return JSON.parse(env['body'])
    #   # raise "400 (Bad Request) Response: \n #{JSON.parse(env['body'])}"
    # when 401
    #   # dont fail because it probably means the auth failed
    #   # p "401 (Bad Request) (Probably need to renew token)"
    # when 422
    #   raise "422 (Unprocessable Entity) Response: \n #{JSON.parse(env['body'])}"
    # when 500
    #   raise "500 (Internal Server Error) Response: \n #{JSON.parse(env['body'])}"
    when 400...600
      json_body = JSON.parse(env[:body])
      return json_body
    else
      super
    end
  end

end


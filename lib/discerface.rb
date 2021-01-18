require "net/https"
require "uri"
require 'json'
require 'openssl'
require 'base64'
require_relative 'disconstants'

class Discerface
  attr_accessor :cover_letter, :cv_url, :disco_score, :github_profile,
                :linked_in_profile, :phone_number, :role_id, :api_client_id,
                :secret

  def payload
    {
      "data": {
        "type": "application",
        "attributes": {
          "cover_letter": @cover_letter,
          "cv_url": @cv_url,
          "disco_score": @disco_score,
          "github_profile": @github_profile,
          "linked_in_profile": @linked_in_profile,
          "phone_number": @phone_number,
          "role_id": @role_id
        }
      }
    }
  end

  def header
    { 'Content-Type': 'text/json',
      'Accept': 'application/json',
      'Authorization': authorisation }
  end

  def authorisation
    "hmac #{@api_client_id}:#{signature}"
  end

  def signature
    hmac = OpenSSL::HMAC.hexdigest("SHA256", @secret, payload.to_s)
    base = Base64.strict_encode64(hmac)
    puts "\nBase...\n\n"
    puts base
    base
  end

  def send
    uri = URI.parse(Disconstants::DISCO_API)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    puts "Headers... \n#{header}"
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = payload.to_json
    puts "Body...\n"
    puts request.body
    # response = http.request(request)
    # puts "RESPONSE::\n#{response} ---- \n\n"
    # response
  end

end


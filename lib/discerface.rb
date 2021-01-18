require 'net/https'
require 'uri'
require 'json'
require 'openssl'
require 'base64'
require_relative 'disconstants'

class Discerface
  attr_accessor :cover_letter, :cv_url, :disco_score, :github_profile,
                :linked_in_profile, :phone_number, :role_id, :api_client_id,
                :secret

  def send_data
    uri = URI.parse(Disconstants::DISCO_API)
    http = Net::HTTP.new(uri.host, uri.port)
    http.set_debug_output($stdout)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    puts "REQUEST HEADERS::\n#{header.to_json}  \n\n"
    request = Net::HTTP::Post.new(uri.request_uri, header)

    puts payload.to_json
    request.body = payload.to_json

    puts "REQUEST BODY::\n#{request.body} \n\n"

    response = http.request(request)
    puts "RESPONSE::\n#{JSON.pretty_generate(response.body)} \n\n"
    response
  end

  private

  def payload
    {
      "data": {
        "type": 'application',
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
    base = Base64.strict_encode64(OpenSSL::HMAC.digest('SHA256', @secret, payload.to_json))
    puts "\nBase...\n\n"
    puts base
    base
  end



end


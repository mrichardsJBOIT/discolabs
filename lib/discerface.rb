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

  def payload_dc
    {
      "data": {
        "type": "application",
        "attributes": {
          "first_name": "David",
          "last_name": "Bird",
          "role": "mid-level-developer",
          "cover_letter": "Disco is cool.",
          "cv_url": "https://example.com/cv.pdf",
          "github_profile": "https://github.com/me",
          "linked_in_profile": "https://www.linkedin.com/in/me",
          "disco_score": 82
        }
      }
    }
  end
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
    hmac = OpenSSL::HMAC.digest("SHA256", @secret, payload_dc.to_s)
    puts hmac
    digest = OpenSSL::Digest.new('sha256')
    hmac1 = OpenSSL::HMAC.digest(digest, @secret, payload_dc.to_s)
    puts hmac1
    base = Base64.strict_encode64(hmac1)
    puts "\nBase...\n\n"
    puts base
    base
  end

  def send
    uri = URI.parse(Disconstants::DISCO_API)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    puts "REQUEST HEADERS::\n#{JSON.pretty_generate(header)} ---- \n\n"
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = payload.to_json
    puts "REQUEST BODY::\n#{JSON.pretty_generate(request.body)} ---- \n\n"
    response = http.request(request)
    puts "RESPONSE::\n#{JSON.pretty_generate(response.body)} ---- \n\n"
    response
  end

end


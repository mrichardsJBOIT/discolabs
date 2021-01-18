require 'net/http'
require 'httparty'
require 'pp'
require 'rest-client'
require 'uri'
require 'json'
require 'openssl'
require 'base64'
require_relative 'disconstants'

class Discerface
  include HTTParty
  attr_accessor :cover_letter, :cv_url, :disco_score, :github_profile,
                :linked_in_profile, :phone_number, :role_id, :api_client_id,
                :secret

  def send_data

    uri = URI.parse(Disconstants::DISCO_API)
    http = Net::HTTP.new(uri.host, uri.port)
    http.set_debug_output($stdout)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.path, headers)
    puts payload.to_json
    request.body = payload.to_json
    puts "\nREQUEST BODY::\n#{request.body} \n\n"

    response = http.request(request)
    puts "RESPONSE::\n#{JSON.pretty_generate(response.body)} \n\n"
    case response
    when Net::HTTPSuccess, Net::HTTPRedirection
      'OK'
    else
      response.value
    end
    response
  end

  def lets_party
    #This is a spike method with trial and error code...none of which work on the real site...
    # OMG...shoot me now...I had the wrong content type....

    data = {"data":{"type":'application',"attributes":{"cover_letter":"# Cover Letter For Disco Labs\n\n---\n## Hello\nDear Disco Labs,  \nMark here,  I hope you're well?  I also hope my copy writing skills are not as important as my technical and business skills?\n### Quick Brown Fox\nThis challenge seems quite fun and an interesting and reminds me of a challenge to get all letters of the alphabet into a paragraph, which can be done using the sentence  \n\n> the quick brown fix jumps over the lazy dog\n### About Me\nWell, I enjoy technical challenges, I have worked a lot for retail, wholesale and FMCG type organisations.  Outside of work I play golf and am focusing on general fitness so I can get back into surfing.\n### Why Disco Labs?\nGiven that I like working in IT and I'd like to use my existing experience and learn new skills, Disco Labs seems to be the organisation to do that.  A quality technology company that provides services and products to business.  \n### Technical Artefacts\nI will create a non production script to calculate my **DISCO SCORE**.  Which you can find at\n[my GitHub Disco Labs Repo](https://github.com/mrichardsJBOIT/discolabs.git)\n### Thank You\nWhile this cover letter is brief, I hope it is enough for you to invite me to a formal interview.  Thank you for the opportunity to attempt this.  \n  \nMark","cv_url":'https://github.com/mrichardsJBOIT/discolabs/blob/main/docs/MarkRichards_CV_2021.pdf',"disco_score":3801,"github_profile":'https://github.com/mrichardsJBOIT/',"linked_in_profile":'https://www.linkedin.com/in/mark-richards-03180999/',"phone_number":'0404557261',"role_id":'e0198f51-88d4-4484-99f8-f2435608dc95'}}}
    options = {
      headers: {
        "Content-Type" => 'application/json',
        "Accept" => 'application/json',
        "Authorization" => 'hmac mrichards@outlook.com.au:j1kKF5TjDTE5PWuB9tcVNdfdAZ2rMsjTyRUjsGm97Kc='
      },
      body: data,
      debug_output: $stdout
    }
    resp = HTTParty.post(Disconstants::DISCO_API, options)


    begin
      RestClient.post(Disconstants::DISCO_API, payload.to_json, headers)
    rescue RestClient::ExceptionWithResponse => err
      case err.http_code
      when 301, 302, 307
        err.response.follow_redirection
      else
        raise
      end
    end

    response = RestClient::Request.new({
                                         method: :post,
                                         url: Disconstants::DISCO_API,
                                         payload: payload.to_json,
                                         headers: headers
                                       }).execute do |response, request, result|
      case response.code
      when 400
        [ :error, JSON.parse(response.to_str) ]
      when 200
        [ :success, JSON.parse(response.to_str) ]
      else
        fail "Invalid response #{response.to_str} received."
      end
      end
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

  def headers
    { 'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': authorisation }
  end

  def authorisation
    "hmac #{@api_client_id}:#{signature}"
  end

  def signature(data = nil)
    base = Base64.strict_encode64(OpenSSL::HMAC.digest('SHA256', @secret, data || payload.to_json))
    puts "\nBase...\n\n"
    puts base
    base
  end
end

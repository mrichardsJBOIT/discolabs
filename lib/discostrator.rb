#!/usr/bin/env ruby

require_relative 'disolator'
require_relative 'discerface'
require_relative 'disconstants'

class Discostrator

  def initialize(args)
    @phone_number = args[0]
    @role_id = args[1]
    @secret = args[2]
    puts @secret
  end

  def perform
    cover_letter = File.read(Disconstants::LETTER_LOCATION)
    calculator = Discolator.new(cover_letter)
    puts "Disco Score = #{calculator.disco_score}"
    api = set_api(cover_letter, calculator.disco_score)
    puts "About send...hold tight #{Time.now}"
    response = api.send_data
    # response = api.lets_party
    puts "\n\n..and the survey says....\n"
    puts response
    puts "\n *** All done at...#{Time.now}"
  end

  private

  def set_api(cover_letter, disco_score)
    api = Discerface.new
    api.cover_letter = cover_letter
    api.cv_url = Disconstants::CV_URL
    api.disco_score = disco_score
    api.github_profile = Disconstants::GITHUB_PROFILE
    api.linked_in_profile = Disconstants::LINKED_IN_PROFILE
    api.phone_number = @phone_number
    api.role_id = @role_id
    api.api_client_id = Disconstants::CLIENT_ID
    api.secret = @secret
    api
  end


end

Discostrator.new(ARGV).perform

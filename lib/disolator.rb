#!/usr/bin/env ruby

require_relative 'disconstants'

# LETTER_LOCATION = '../docs/cover_letter.md'
# cv_url = 'https://github.com/mrichardsJBOIT/discolabs/blob/main/docs/MarkRichards_CV_2021.pdf'
# github_profile = 'https://github.com/mrichardsJBOIT/'
# linked_in_profile = 'https://www.linkedin.com/in/mark-richards-03180999/'
# phone_number = ARGV[0]
# role_id = ARGV[1]
#
# points = { 'a' => 0, 'b' => 1, 'c' => 7, 'd' => 8, 'e' => 4,
#            'f' => 0, 'g' => 1, 'h' => 2, 'i' => 8, 'j' => 4,
#            'k' => 0, 'l' => 1, 'm' => 2, 'n' => 3, 'o' => 9,
#            'p' => 0, 'q' => 1, 'r' => 2, 's' => 8, 't' => 4,
#            'u' => 0, 'v' => 1, 'w' => 2, 'x' => 3, 'y' => 4,
#            'z' => 0 }


class Discolator
  attr_accessor :cover_letter

  def initialize(cover_letter = nil)
    @cover_letter = cover_letter.dup if cover_letter
  end

  def disco_score
    if @cover_letter
      @cover_letter.gsub!(/[^0-9a-z]/i, '')
      @cover_letter.split('').reduce(0) { |total, current| total + Disconstants::POINTS[current.downcase] }
    else
      0
    end
  end
end

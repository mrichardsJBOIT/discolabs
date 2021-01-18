#!/usr/bin/env ruby

require_relative 'disconstants'

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

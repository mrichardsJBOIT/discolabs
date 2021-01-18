#!/usr/bin/env ruby

LETTER_LOCATION = '../docs/cover_letter.md'
cv_url = ''
github_profile = ''
linked_in_profile = ''
phone_number = ARGV[0]
role_id = ARGV[1]

points = { 'a' => 0, 'b' => 1, 'c' => 7, 'd' => 8, 'e' => 4,
           'f' => 0, 'g' => 1, 'h' => 2, 'i' => 8, 'j' => 4,
           'k' => 0, 'l' => 1, 'm' => 2, 'n' => 3, 'o' => 9,
           'p' => 0, 'q' => 1, 'r' => 2, 's' => 8, 't' => 4,
           'u' => 0, 'v' => 1, 'w' => 2, 'x' => 3, 'y' => 4,
           'z' => 0 }


disco_score = 0
cover_letter = File.read(LETTER_LOCATION)
puts 'Raw Cover Letter'
puts cover_letter
puts 'Reduced Cover Letter'
cover_letter.gsub!(/[^0-9a-z]/i, '')
puts cover_letter
disco_score = cover_letter.split('').reduce(0) { |total, current| total + points[current.downcase] }
puts "Disco Score = #{disco_score}"

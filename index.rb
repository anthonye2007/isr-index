#!/usr/bin/ruby
file = File.read('file.txt')
array = file.split(' ')
#puts array

uniqueWords = []
array.each do |word|
	if not uniqueWords.include?(word.downcase)
		uniqueWords.push(word.downcase)
	end
end

puts uniqueWords

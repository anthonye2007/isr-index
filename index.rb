#!/usr/bin/ruby
file = File.read('file.txt')
words = file.split(' ')

# normalize capitalization and remove punctuation
# put each word on its own line
normalized = []
words.each do |word|
	normalizedWord = word.downcase.gsub(/[^a-z]/, "\n")
	normalized.push(normalizedWord)
end

sorted = normalized.sort

# Increase count if current word is same as previous word
# This is true because of sorting alphabetically
counts = []
count = 1
sorted.each_with_index do |word, i|
	if (i > 0) and (word == sorted[i - 1])
		count += 1
	elsif (i > 0) and word != sorted[i - 1] 
		counts.push([sorted[i - 1], count])
		count = 1
	end
end

puts "\nHere is the final list"
puts counts

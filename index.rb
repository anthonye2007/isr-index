#!/usr/bin/ruby

def getTokens(file)
	words = file.split(' ')

	# normalize capitalization and remove punctuation
	# put each word on its own line
	normalized = []
	words.each do |word|
		normalizedWord = word.downcase.gsub(/[^a-z]/, "\n")

		# could contain a newline inside the word
		multiples = normalizedWord.split("\n")
		multiples.each do |m|
			normalized.push(m)
		end
	end
	return normalized
end

def getCount(tokenList)
	# Increase count if current word is same as previous word
	# This is true because of sorting alphabetically
	counts = []
	count = 1
	tokenList.each_with_index do |word, i|
		if (i > 0) and (word == tokenList[i - 1])
			count += 1
		elsif (i > 0) and word != tokenList[i - 1] 
			counts.push([tokenList[i - 1], count])
			count = 1
		end
	end
	return counts
end

files = ['file.txt', 'file2.txt']
files.each do |filename|
	file = File.read(filename)
	tokens = getTokens(file).sort
	withCount = getCount(tokens)
	puts "#{filename}: "
	puts withCount
	puts "\n\n"
end

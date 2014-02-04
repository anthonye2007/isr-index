#!/usr/bin/ruby
#
# Anthony Elliott
# Information Storage and Retrieval
# CS 3150
# Programming Assignment 1
# 2/3/2014

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

def removeDuplicates(tokens)
	uniqueTokens = []
	tokens.each do |token|
		if not uniqueTokens.include?(token)
			uniqueTokens.push(token)
		end
	end
	return uniqueTokens
end

def addTokensToIndex(index, document, tokens)
	tokens.each do |token|
		if not index.has_key?(token)
			# create listing in index
			index[token] = [document]
		else
			# append document to current token listing
			prevValue = index[token]
			appendedValue = prevValue.push(document)
			index[token] = appendedValue
		end
	end

	return index
end

if ARGV.length < 1
	puts "Enter the files you want to index separated by spaces."
else
	files = ARGV
	invertedIndex = {}
	files.each_with_index do |filename, i|
		file = File.read(filename)
		tokens = getTokens(file).sort
		uniqueTokens = removeDuplicates(tokens)
		invertedIndex = addTokensToIndex(invertedIndex, i+1, uniqueTokens)
	end

	puts invertedIndex
end

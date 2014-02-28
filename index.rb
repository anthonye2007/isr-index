#!/usr/bin/ruby
#
# Anthony Elliott
# Information Storage and Retrieval
# CS 3150
# Programming Assignment 2
# 2/28/2014

def driver()
	if ARGV.length < 1
		printUsage
	else
		invertedIndex = generateInvertedIndex
		positionalIndex = generatePositionalIndex(invertedIndex)
		outputInvertedIndex(invertedIndex)
	end
end

def generatePositionalIndex(index)

end

def outputInvertedIndex(invertedIndex)
	files = ARGV
	output = File.open("document.idx", "w")

	# output list of files indexed
	output << "# INPUT DOCUMENT REFERENCE LEGEND\n"
	files.each_with_index do |file, i|
		output << (i+1).to_s + "\t" + file + "\n"
	end

	# output contents of inverted index
	output << "# INVERTED INDEX RESULTS\n"
	keys = invertedIndex.keys.sort
	keys.each do |key|
		documents = invertedIndex[key]
		str = key + "\t" + documents.length.to_s

		documents.each do |doc|
			str += "\t" + doc.to_s
		end

		output << str + "\n"
	end

	output.close	
end

def generateInvertedIndex
	files = ARGV
	invertedIndex = {}
	begin
		# Read in words from each file
		files.each_with_index do |filename, i|
			file = File.read(filename)
			tokens = getTokens(file).sort
			uniqueTokens = removeDuplicates(tokens)
			invertedIndex = addTokensToIndex(invertedIndex, i+1, uniqueTokens)
		end
	rescue
		printUsage
	end

	return invertedIndex
end

def printUsage
	puts "Enter the files you want to index separated by spaces."
	puts "Wildcards are acceptable."
	puts "Example:  ./index.rb /first/path /second/file"
end	

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
			index[token].push document
		end
	end

	return index
end

driver()

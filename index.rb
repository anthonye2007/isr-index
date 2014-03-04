#!/usr/bin/ruby
#
# Anthony Elliott
# Information Storage and Retrieval
# CS 3150
# Programming Assignment 2
# 2/28/2014

def driver
	if ARGV.length < 1
		printUsage
	else
		invertedIndex = generateInvertedIndex
		positionalIndex = generatePositionalIndex(invertedIndex, ARGV)
		#puts positionalIndex.to_s
		outputPositionalIndex(positionalIndex)
	end
end

def generatePositionalIndex(invertedIndex, files)
	# have token -> [docNum]
	# need token -> docNum -> postings
	# use token -> Document
	index = PositionalIndex.new

	#puts "Files: " + files.to_s + "\n"

	invertedIndex.keys.each do |token|
		# get token and document
		# normalize document (getTokens)
		# search document for all occurrences of token
		# add postings list
		documents = invertedIndex[token]
		documents.each do |docNum|
			file = File.read(files[docNum-1])
			normalizedDocument = getTokens(file)
			postings = getPostings(normalizedDocument, token)
			index.addListing(token, docNum, postings)
		end
	end

	return index
end

def getPostings(words, token)
	postings = []

	words.each_with_index do |word, i|
		postings.push i if token.eql? word
	end

	return postings
end	

def outputPositionalIndex(index)
	output = File.open("document.pidx", "w")

	output << index.to_s

	output.close
end


def outputInvertedIndex(invertedIndex)
	files = ARGV
	output = File.open("document.pidx", "w")

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

class PositionalIndex
	def initialize
		@index = {}
	end
	def addDocument(token, doc)
		if @index.has_key? token
			@index[token].push doc
		else
			@index[token] = [doc]
		end
	end
	def addListing(token, docNum, postings)
		doc = Document.new(docNum, postings)
		addDocument(token, doc)
	end
	def to_s
		tokens = @index.keys.sort

		str = ""
		tokens.each do |token|
			documents = @index[token]
			str += token + "," + documents.length.to_s + ":"
			documents.each do |document|
				str += "\n" + document.to_s
			end
			str += "\n\n"
		end

		return str
	end
end

class Document
	def initialize(docNum, postings)
		@num = docNum
		@postings = postings
	end
	def printPostings
		str = ""
		@postings.each_with_index do |posting, i|
			str += "," if i > 0
			str += posting.to_s
		end
		return str
	end
	def to_s
		return "    " + @num.to_s + "," + @postings.length.to_s + ": " + printPostings
	end
end

driver()

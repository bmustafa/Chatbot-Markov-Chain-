#Project: Text Generation with Markov Chains
#Name: Bilal Mustafa
#Ruby Version: ruby 2.4.3p205 (2017-12-14 revision 61247) [x64-mingw32]
#Exhibit Excellent Programming: Check
#Have Appropriate Documentation: I hope so. I tried.
#Sources:
#https://www.tutorialspoint.com/ruby/index.htm
#http://ruby-doc.org/


class Parser
  
  #'''A class to parse a string into an array of strings'''

  
  def initialize
    
    #'''Initialize the Parse Class'''
    @outputList = []
  end

  
  def parse(input_string)
    
    #'''Parse an input string into an array of strings'''
     @outputList = input_string.split
     @outputList
  end
end


class MarkovChainTextGenerator
  
  #'''A class that utilizes a markov chain for generate text'''
  include Enumerable
  
  
  def initialize(input_file)
    
    #'''initialize the markov chain and relevant attributes'''
    @input_file_name = input_file
    input_file_text = File.open(input_file)
    @input_lines = input_file_text.read()
    input_file_text.close
    #Convert an .txt file into a string
    
    string_parser = Parser.new
    @arrayOfWords = string_parser.parse(@input_lines)
    #Parse the string
    
    @sizeOfText = @arrayOfWords.size 
    if @sizeOfText == 1
      return
    end
    #Save the size of the text in words. If it is only 1, then return
    
    @beginning_of_sentence = [@arrayOfWords[0] + ' ' + @arrayOfWords[1]]
    for i in 0..(@arrayOfWords.size-2)
        if @arrayOfWords[i][-1] == '.' and @arrayOfWords[i+1][-1] != '.'
         @beginning_of_sentence.push(@arrayOfWords[i+1] + ' ' + @arrayOfWords[i+2])
      end
    end
    #Save the first two words of the all the sentences in the string. Will be used
    #for the generate_sentence method.
    
    @markov_Chain = {}
    @reverse_Chain = {}
    #initialize a hash to be used to create a markov chain to predict next words
    #an one to trace back to previous words
    
    for i in 0..(@arrayOfWords.size - 3)
      trigram = @arrayOfWords[i] + @arrayOfWords[i + 1]
      #loop through the input file (now in array form) and create trigrams to use as keys
      
      if (!@markov_Chain[trigram.downcase.to_sym].is_a?(Array))
        @markov_Chain[trigram.downcase.to_sym] = []
      end
      #if it is the first time a trigram is entered into the hash, insert and empty array
      
      @markov_Chain[trigram.downcase.to_sym].push(@arrayOfWords[i+2])
      #Put the next word of the file into array
      
      if (!@reverse_Chain[@arrayOfWords[i+2].downcase.to_sym].is_a?(Array))
        @reverse_Chain[@arrayOfWords[i+2].downcase.to_sym] = []
      end
      #Now for the hash table that points to the words before any given word
      #if it is the first time this trigram is entered into the hash, insert and empty array
      
      @reverse_Chain[@arrayOfWords[i+2].downcase.to_sym].push([@arrayOfWords[i], @arrayOfWords[i + 1]]) 
    end
      #Put the previous words in a tuple into the array to which this hash table points
      
 end
  
  
  
  def add_to_chain(first_word, second_word, next_word)
    
    #'''A method to amend the Markov chain and reverse chain hashtables and create new links'''
    trigram = first_word + second_word
    if (!@markov_Chain[trigram.downcase.to_sym].is_a?(Array))
      @markov_Chain[trigram.downcase.to_sym] = []
    end
    #If the trigram of passed parameters does not point to anything, have it point to a new array 
    
    @markov_Chain[trigram.downcase.to_sym].push(next_word)
    #Push the next word into that array
    #This keeps track of the user's use of language in homework 4 and adds it to the Markov chain
    
    if (!@reverse_Chain[next_word.downcase.to_sym].is_a?(Array))
        @reverse_Chain[next_word.downcase.to_sym] = []
    end
    #Does the same for the reverse chain hash table and has it point to an empty array if the key
    #points to nothing

    @reverse_Chain[next_word.downcase.to_sym].push([first_word, second_word]) 
    # Then pushes two word into that array. To keep track of the words used before a given word
    #keeps track of my use of language form hw 4
    
  end  
  
    
  def to_s
    
    #'''Provides a human friendly description of the MCTG class'''
    @description = "Markov Chain Text Generator of the File: #{@input_file_name}"
    puts @description
  end
  
  
  def inspect
    
    #'''Provides a computer friendly description of the MCTG class'''
    @computer_friendly_description = "Markov Chain Text Generator(file name: #{@input_file_name}, object_id: #{"0x00%x" % (object_id << 1)})"
    puts @computer_friendly_description
  end
  
  
  def generate_text(text_length)
    
    #'''Generates a random paragraph of length text_length using the Markov chain'''
    output_string = ''
    if @sizeOfText == 1
      for i in 0..text_length
        output_string += @arrayOfWords[0] + ' '
      end 
      return output_string
      # If the input file has only one word, repeat that word until the you have a sentence of the appropriate
      #length
      
    elsif @sizeOfText == 2
      for i in 0..text_length
        if i%2 == 0
          output_string +=  @arrayOfWords[0] + ' '
        elsif i%2 != 0
          output_string += @arrayOfWords[1] + ' '
        end
      end
      #else if input file two words long, alternate those words in the generated text until it is the
      #appropriate length
      
      return output_string[0..-2]
    end  
    #Remove the ' ' character and return the generated text
    
    first_word = @arrayOfWords[0]
    second_word = @arrayOfWords[1] 
    output_string = first_word + ' ' + second_word + ' '
    new_word = first_word + second_word
    #Establishes the first two words of the output text
    
    for i in 1..(text_length-2) do
      #loop so that the required number of words are added to the paragraph
      
      if @markov_Chain[new_word.downcase.to_sym] == nil or @markov_Chain[new_word.downcase.to_sym][0] == nil
        first_word = @arrayOfWords[0]
        second_word = @arrayOfWords[1]
        new_word = first_word + second_word
        output_string += first_word + ' ' + second_word + ' '
        #if there is no word that could follow after our current trigram, restart from the beggining
        #of the passage and add first two words to our generated text.
        
      else
        first_word = second_word
        second_word = @markov_Chain[new_word.downcase.to_sym].sample
        while second_word == nil
          second_word = @markov_Chain[new_word.downcase.to_sym].sample
        end
        #else randomly choose between the appropriate words that would follow the current trigram
        #There is a possibility of the Hash value being ["random_words", nil], the while loop corrects for
        #that
      
      
        new_word = first_word + second_word
        output_string += second_word + ' '
        #Add the new word to the output string
        
      end
    end
    output_string
  end
  
  
  def generate_sentence(function = 0, sentence_starter = '')
    
    #'''Generates a random sentence through the use of the Markov Chain'''
    if function == 0
      #to enable or disable the setting necessary for homework 4
      #it will allow my sentence to be started by words passed as paramaters.
      
      if @sizeOfText == 1
        return @arrayOfWords[0]
        #if the input file only has one word, return that word
    
      elsif @sizeOfText == 2
        return @arrayOfWords[0] + ' ' + @arrayOfWords[1]
      end
      #Or if it has two words, return a sentence of those two
    
      first_two_words = @beginning_of_sentence.sample
      output_string = first_two_words
      #Randomly choose from the words that have been used to start sentences in sample text
      #and start constructing the output string
      
      two_words_seperated = first_two_words.split
      first_word = two_words_seperated[1]
      first_two_words = two_words_seperated[0] + two_words_seperated[1]
      #construct the trigram and find the declare the first and second word variables
      #so that future trigrams can be constructed
    
      second_word =  @markov_Chain[first_two_words.downcase.to_sym].sample
      #randomly choose the next word via the Markov chain
    
      output_string += ' ' + second_word
      new_word = first_word + second_word
      #add it to the output and construct the new trigram
    
    else
      #to be called for hw4. The start of the sentence is not random 
      
      second_word = sentence_starter
      if @reverse_Chain[sentence_starter.downcase.to_sym] == nil
        return nil
      end
      #If there is no record of a word before this one, return nil as we cannot construct
      #a trigram to use
      
      first_word = @reverse_Chain[sentence_starter.downcase.to_sym].sample[1]
      new_word = first_word + second_word
      output_string = second_word
      #start sentence with the word given exogenously
      
    end
    while(true)
      if (second_word[-1] == '.') or (second_word[-1] == '?') or (second_word[-1] == '!')
        return output_string
      end
      #Keep running until you come across a '.' or '?' to mark the end of a sentence, then return sentence
      
      if @markov_Chain[new_word.downcase.to_sym] != nil and @markov_Chain[new_word.downcase.to_sym][0] != nil 
        first_word = second_word
        second_word = @markov_Chain[new_word.downcase.to_sym].sample
        new_word = first_word + second_word
        output_string += ' ' + second_word
        #Continue to generate new words via Markov Chain and add to our sentence
        
      else
        return output_string
        #in case we have arrived at the last word of our sample text, return the sentence constructed
        #so far
      
      end  
    end
  end
  
  
  def each
    
    #'''Implements the each method to yield each word in a sentence generated from the Markov Chain'''
    random_sentence = generate_sentence
    array_of_random_sentence = random_sentence.split
    #Generate a random sentece and parse words into an array
    
    array_of_random_sentence.each { |x| yield x}
    #Apply each method to the array of the words in our random sentence and yield them
    
    return random_sentence
    #return our random sentence
    
  end
end



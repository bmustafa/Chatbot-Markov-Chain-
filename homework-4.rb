#Project: Chatbot via Markov Chain Text Generator Class
#Name: Bilal Mustafa
#Ruby Version: ruby 2.4.3p205 (2017-12-14 revision 61247) [x64-mingw32]
#Exhibit Excellent Programming: Check
#Have Appropriate Documentation: I hope so. I tried.
#Sources:
#https://www.tutorialspoint.com/ruby/index.htm
#http://ruby-doc.org/


require_relative "homework-3.rb"


def chatbot_assistant(generator, name, initial_sentence)
  
  #'''A method to assist in our execution of a chatbot through the use of MarkovChains'''
  reply = gets
  reply = reply[0...-1]
  reply = reply.split
  #Get the response from the user and split into an array to parse
  
  if reply[0] == 'end' and reply.size == 1 
    return nil
  end
  #if the only word in the sentence is end, shut down the program
  
  reply_lower_case = reply.map { |x| x.downcase }
  match = false
  #create a copy of reply with lower case for the purposes of the next loop
    
  for i in reply_lower_case
    if name.downcase == i or name.downcase == i[0...-1]
      match = true
      break
    end
  end
  #Check to see if the response from user refers to the chatbot by name
  #program will only respond if its name is used
      
  if match == false
    puts "Are you talking to me?"
    initial_sentence = "Are you talking to me?"
    return initial_sentence
  end
  #If the user does not refer to the chatbot by name, it returns a sassy remark
      
  if reply.size == 1 and match
    puts "Yeah what?"
    initial_sentence = "Yeah what?"
    return initial_sentence
  end
  #if its name is the only word entered by the user then reply  'Yeah?'
        
  chosen_word = reply.sample
  while chosen_word.downcase == name.downcase
    chosen_word = reply.sample
  end
  #choose a word that isnt the name
  #The chatbot will formulate a response based on this word
  
  for i in 0..100
    potential_reply = generator.generate_sentence(1, chosen_word)
    if potential_reply == nil
      chosen_word = reply.sample
      #Exhaust the possible words to find a word to which the chatbot can reply
      #meaning that it lives in the Markov chain
        
      while chosen_word.downcase == name.downcase
        chosen_word = reply.sample
      end
      #this word once again cannot be the name  
    
    else
      break
      #if we have a valid chatbot reply then break
      
    end
  end
  if potential_reply == nil
    puts "I don't understand."
    initial_sentence = "I don't understand."
  #if after a hundred loops, no word in the sentence results in a
  #useful link, a.k.a. does not live in the Markov Chain, reply "I don't Understand"      
  
  end   
  first_word = initial_sentence.split[-2]
  second_word = initial_sentence.split[-1]
  #re-initialize the two words leading upto the first word from the user input
  
  for word in reply
    if word.downcase != name.downcase
      generator.add_to_chain(first_word, second_word, word)
      first_word = second_word
      second_word = word
    end
  end
    #Using the add_to_chain function, run through the the sentence entered by the user and
    #use it to update our Markov Chain and Reverse Chain Hash Tables except if the word in the
    #name of the chatbot
      
  if potential_reply != nil    
    puts potential_reply
    intial_sentence = potential_reply
  end
  #this is to prevent initial_sentence = nil and puts nil in the case of the "i don't understand" response
  
  return initial_sentence
end
      

def irc_chatbot(input_file = 0, name = 'Chatbot')
  
  #'''Main executable method that handles the simulation of a chatbot'''
  
  if input_file == 0
    puts "Which file would you like to train #{name} on? (i.e. 'P and P.txt')"
    input_file = gets
    input_file = input_file[0...-1]
  end
  #If name of file hasn't already been given, ask the user for it
  
  generator = MarkovChainTextGenerator.new(input_file)
  #Choose the file you would like to use to train your Markov Chain
  
  program_ouput = 1
  initial_sentence = "Hi, I am #{name} What's up?"
  puts initial_sentence
  #Initialize variable and greet the user
  
  while initial_sentence != nil
    initial_sentence = chatbot_assistant(generator, name, initial_sentence)
  end
  #Run the irc_chatbot program until nil is returned (if the us replied "end")
  
end
  
  
irc_chatbot(input_file = 0, name = 'ChatBot')
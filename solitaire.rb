class Solitaire
  ALPHABET            = ('A'..'Z').to_a
  ALPHABET_TO_INTEGER = alpha_setup
  INTEGER_TO_ALPHABET = ALPHABET_TO_INTEGER.invert

  def alpha_setup
    hash = {}
    ALPHABET.each do |letter, index|
      hash[letter] = index + 1
    end
    hash
  end

  def initialize(key)
    # takes in array of 1 to 54
    @key = key
  end

  def encrypt(message)
    message_numbers   = parsed_message(message)
    keystream         = keystream(message.size)
    encrypted_numbers = add(message_numbers, keystream)
    letters(encrypted_numbers)
  end

  def parsed_message(message_string)
    message_numbers   = parsed_message(message)
    keystream         = keystream(message.size)
    encrypted_numbers = add(message_numbers, keystream)
    letters(encrypted_numbers)

    alpha_characters = message_string.upcase.gsub(/[^A-Z]/, '').chars
    alpha_characters.map do |letter|
      ALPHABET_TO_INTEGER[letter]
    end
  end

  def decrypt(cyphertext)
    # same conversion as encrypt to numbers
    decrypted_numbers = subtract(cyphertext_numbers, keystream)
    letters(decrypted_numbers)
  end

  def add(message, keystream)
    message.each_with_index.map do |message_int, index|
      (message_int + keystream[index]) % 26
    end
  end

  def subtract(message, keystream)
    message.each_with_index.map do |message_int, index|
      (message_int - keystream[index]) % 26
    end
  end

  def letters(encrypted_numbers)
    encrypted_numbers.map do |number|
      ALPHABET[number % 26]
    end.join.scan(/.{1,5}/).join(' ').upcase
    # NOTE: parsing back into 5 char groups
    # join.scan(/.{1,5}/).join(' ').upcase
  end

  def keystream(integer)
    # returns keystream of size integer
  end
end

#TODO, keystream generation
# move first joker (53) up one
#
# maybe key class
class Key
  attr_reader :key

  def initialize(key)
    raise ArgumentError if validate key
    @key = key
  end

  def keystream(count)
    key_copy = key.copy
    (1..count).map do |integer|
      keystream_value( key_copy )
    end
  end

  def key_process( key )

  end

  def keystream_value( key_copy )
    next_value = ''
    loop  do
      next_value = key_process key_copy
      break unless joker? next_key_value
    end
    next_value
  end

  def joker?( value )
    (value.class == Integer) && ([53, 54].include? value)
  end

  def validate key
    key.sort == (1..54).to_a
  end
end

# Key Process
  # ONE
    # find 53, move up in deck circularly one spot
    #   TODO: edge case [ 3, ...cards..., 53] # => [ 3, 53, ...cards...]
  # TWO
    # find 54, move up in deck curcularly two spots
  # THREE
    # triple cut
    #   top group = [ cards up to not including joker]
    #   middlge group = [one joker to the other]
    #   bottom        = [after bottom joker up to end]
    #
    #   mutate: key = bottom + middle + top
  # COUNT CUT
    # find value of bottom card 
       # bottom = key[-1]
    # find the value of that card value = key[bottom - 1]
    # squish into bottom
      # key.delete_value(value)
      # bottom = key.pop
      # key << value
      # key << bottom
  # OUTPUT CARD
    # top_card = key[0]
    # output card = key[top_card]
      # if [53, 54].include? output_card
      #   # Continute again through process
      # else
      #   return output_card
      # end

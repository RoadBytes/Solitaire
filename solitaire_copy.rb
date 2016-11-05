# implementation of solitaire cipher
class Solitaire
  def self.alpha_setup
    hash = {}
    ALPHABET.each_with_index do |letter, index|
      hash[letter] = index + 1
    end
    hash
  end

  ALPHABET            = ('A'..'Z').to_a
  ALPHABET_TO_INTEGER = self.alpha_setup
  INTEGER_TO_ALPHABET = ALPHABET_TO_INTEGER.invert

  def initialize(key)
    # takes in array of 1 to 54
    @key = key
  end

  def encrypt(message)
    message_numbers   = parsed_message(message)
    keystream         = keystream(message_numbers.size)
    encrypted_numbers = add(message_numbers, keystream)
    int_to_letters(encrypted_numbers)
  end

  def parsed_message(message_string)
    message_numbers   = parsed_message(message)
    keystream         = keystream(message.size)
    encrypted_numbers = add(message_numbers, keystream)
    int_to_letters(encrypted_numbers)

    alpha_characters = message_string.upcase.gsub(/[^A-Z]/, '').chars
    alpha_characters.map do |letter|
      ALPHABET_TO_INTEGER[letter]
    end
  end

  def decrypt(cyphertext)
    # same conversion as encrypt to numbers
    decrypted_numbers = subtract(cyphertext_numbers, keystream)
    int_to_letters(decrypted_numbers)
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

  def int_to_letters(encrypted_numbers)
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

def keystream(count)
  (1..count).map do |integer|
    next_keystream_value
  end
end

  def split_at(cards, card)
    card_index = cards.index card
    [cards[0..card_index], cards[(card_index + 1)..-1]]
  end

  def shift_next( card )
    if last_card_in_deck? card
      shift_last_card_over
    else
      shift_middle_card( card )
    end
  end

  def cut_deck( index )
    [deck[0..index], deck[(index + 1)..-1]]
  end

  def joker?( value )
    (value.class == Integer) && ([53, 54].include? value)
  end

  def validate key
    key.sort == (1..54).to_a
  end
end

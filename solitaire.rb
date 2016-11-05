class Solitaire
  ALPHABET            = ('A'..'Z').to_a

  def self.alpha_setup
    hash = {}
    ALPHABET.each_with_index do |letter, index|
      hash[letter] = index + 1
    end
    hash
  end

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

#TODO, keystream generation
# move first joker (53) up one
#
# maybe key class
class Key
  attr_accessor :deck

  def initialize(key)
    raise ArgumentError unless validate key
    @deck = key
  end

  def keystream(count)
    (1..count).map do |integer|
      next_keystream_value
    end
  end

  def key_process( key )
    joker_one_move
    joker_two_move
    triple_cut
    key = count_cut(key)
    key_character = top_card_count(key)

    [key_character, key]
  end

  def triple_cut
    if joker_one_before_joker_two?
      top, middle_bottom = split_at(deck, 53)
      joker_one          = top.pop
      middle_bottom.unshift joker_one
      middle, bottom     = split_at(middle_bottom, 54)

      self.deck = bottom + middle + top
    else
      top, middle_bottom = split_at(deck, 54)
      joker_two          = top.pop
      middle_bottom.unshift joker_two
      middle, bottom     = split_at(middle_bottom, 53)

      self.deck = bottom + middle + top
    end
  end

  def count_cut
    bottom_card     = deck[-1]
    cut_card_index  = bottom_card - 1
    cut_card        = deck.delete_at(cut_card_index)

    bottom_card = deck.pop
    deck.push cut_card
    deck.push bottom_card
  end

  def output_card
    top_card   = deck[0]
    card_index = top_card - 1
    deck[card_index]
  end

  def joker_one_before_joker_two?
    joker_one_location = deck.index 53
    joker_two_location = deck.index 54
    joker_one_location < joker_two_location
  end

  def split_at(cards, card)
    card_index = cards.index card
    [cards[0..card_index], cards[(card_index + 1)..-1]]
  end

  def next_keystream_value
    joker_one_move
    joker_two_move
    triple_cut
    count_cut
    output_card
  end

  def shift_next( card )
    if last_card_in_deck? card
      shift_last_card_over
    else
      shift_middle_card( card )
    end
  end

  def joker_one_move
    shift_next( 53 )
  end

  def joker_two_move
    shift_next( 54 )
    shift_next( 54 )
  end

  def shift_middle_card( card )
    top_half, bottom_half = split_at(deck, card)

    card  = top_half.pop
    next_item = bottom_half.shift

    bottom_half.unshift(card)
    top_half.push(next_item)

    self.deck = top_half + bottom_half
  end

  def last_card_in_deck? card
    card_location = deck.index card
    card_location == (deck.size - 1)
  end

  def shift_last_card_over
    last_card  = deck.pop
    first_card = deck.shift

    deck.unshift last_card
    deck.unshift first_card
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

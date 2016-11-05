# Key features for Solitaire
class Key
  attr_accessor :deck

  def initialize(key)
    raise ArgumentError, 'Key is array 1 - 54' unless validate key
    @deck = key
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

  def count_cut
    bottom_card     = deck[-1]
    cut_card_index  = bottom_card - 1
    cut_card        = deck.delete_at(cut_card_index)

    bottom_card = deck.pop
    deck.push cut_card
    deck.push bottom_card
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

  def output_card
    top_card   = deck[0]
    card_index = top_card - 1
    deck[card_index]
  end

  def next_keystream_value
    joker_one_move
    joker_two_move
    triple_cut
    count_cut
    output_card
  end

  private

  def joker_one_before_joker_two?
    joker_one_location = deck.index 53
    joker_two_location = deck.index 54
    joker_one_location < joker_two_location
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

  def shift_middle_card( card )
    top_half, bottom_half = split_at(deck, card)

    card      = top_half.pop
    next_item = bottom_half.shift

    bottom_half.unshift(card)
    top_half.push(next_item)

    self.deck = top_half + bottom_half
  end

  def split_at(cards, card)
    card_index = cards.index card
    [cards[0..card_index], cards[(card_index + 1)..-1]]
  end

  def validate key
    key.sort == (1..54).to_a
  end
end

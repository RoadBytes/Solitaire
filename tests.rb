require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use!

require_relative 'solitaire'

class KeyTest < MiniTest::Test
  def setup
    new_deck = (1..54).to_a
    @key = Key.new(new_deck)
  end

  def test_next
    shifted_deck = (1..52).to_a
    shifted_deck << 54
    shifted_deck << 53

    @key.shift_next( 53 )

    assert_equal(shifted_deck, @key.deck)
  end

  def test_next_at_end
    shifted_deck = (2..53).to_a
    shifted_deck.unshift 54
    shifted_deck.unshift 1

    @key.shift_next( 54 )

    assert_equal(shifted_deck, @key.deck)
  end

  def test_joker_one_move
    shifted_deck = (1..52).to_a
    shifted_deck << 54
    shifted_deck << 53

    @key.joker_one_move

    assert_equal(shifted_deck, @key.deck)
  end

  def test_joker_two_move
    shifted_deck = (3..53).to_a
    shifted_deck.unshift 54
    shifted_deck.unshift 2
    shifted_deck.unshift 1

    @key.joker_two_move

    assert_equal(shifted_deck, @key.deck)
  end

  def test_triple_cut_jokers_in_order
    cut_deck = (1..52).to_a
    cut_deck = [53, 54] + cut_deck

    @key.triple_cut

    assert_equal(cut_deck, @key.deck)
  end

  def test_triple_cut_jokers_out_of_order
    full_deck    = (1..52).to_a
    initial_deck = full_deck + [54] + [53]
    key = Key.new(initial_deck)
    cut_deck = [54, 53] + full_deck

    key.triple_cut

    assert_equal(cut_deck, key.deck)
  end

  def test_count_cut
    initial_deck = [ 48, 17, 28, 53, 10, 20,  6, 12, 39,  4,  8, 42, 27,
                     41, 31, 35, 37, 14,  9, 52, 29, 30, 11,  1, 26, 40,
                     44, 16, 50, 21, 43, 33, 36, 49, 34, 32, 22, 23, 15,
                     13, 25, 54, 47, 18, 45,  2, 38, 51, 19,  7, 24,  5,
                      3, 46]
    key          = Key.new(initial_deck)

    final_deck   = [ 48, 17, 28, 53, 10, 20,  6, 12, 39,  4,  8, 42, 27,
                     41, 31, 35, 37, 14,  9, 52, 29, 30, 11,  1, 26, 40,
                     44, 16, 50, 21, 43, 33, 36, 49, 34, 32, 22, 23, 15,
                     13, 25, 54, 47, 18, 45, 38, 51, 19,  7, 24,  5,  3,
                      2, 46]

    key.count_cut

    assert_equal(final_deck, key.deck)
  end

  def test_output_card
    initial_deck = [ 48, 17, 28, 53, 10, 20,  6, 12, 39,  4,  8, 42, 27,
                     41, 31, 35, 37, 14,  9, 52, 29, 30, 11,  1, 26, 40,
                     44, 16, 50, 21, 43, 33, 36, 49, 34, 32, 22, 23, 15,
                     13, 25, 54, 47, 18, 45,  2, 38, 51, 19,  7, 24,  5,
                      3, 46]
    key          = Key.new(initial_deck)

    card = key.output_card

    assert_equal(51, card)
  end

  def test_next_key_stream_value

    next_value = @key.next_keystream_value
    require 'byebug'; byebug

    assert_equal(3, next_value)
  end
end

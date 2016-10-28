# Solitaire Cipher Pseudo Code

Key Generator
Key Stream of numbers 1 to 26

Cipher Text

a: 1, b: 2, ... z: 26
decrypt

Example: "DO NOT USE PC"

# Encrypting

1. split into 5 char groups
  DONOT USEPC
2. !!! Generate Key Stream Letters
  * Assume KDWUP ONOWT
3. convert letters to numbers
  message: 4 15 14 15 20  21 19 5 16 3
4. same for key stream
  11 4 23 21 16  15 14 15 23 20
5. add message and key stream
  * use MOD % to get number back between 1 and 26
  * 15 19 11 10 10   10 7 20 13 23
6. convert back to letters
  OSKJJ  JGTMW


# Decrypting

1. Start with encrypted message
  OSKJJ  JGTMW
2. Same Key Stream Letters
3. Cypher text to numbers
  15 19 11 10 10   10 7 20 13 23
4. same with key stream
  11 4 23 21 16  15 14 15 23 20
5. Subtract Cypher - KeyStream with modulo
  * easy since 1 - 22 = -21 % 26 is 5
  * 4 15 14 15 20  21 19 5 16 3 
6. Convert letters back to numbers
  DONOT USEPC

# Generating Keystream Letters

* Start with deck of cards, 52 + 2 unique jokers 53, 54
  * one arrangement of cards is a key...
    (1..54).to_a.shuffle
  * maybe have method that converts deck into key

* !!! Generate output character
  1. Find first joker 53, move one card down
    * NOTE: circular array in moving
  2. Find second joker 54, move two cards down

> If you have any doubt, remember to move the A joker before the B joker. And be
> careful when the jokers are at the bottom of the deck. If the joker is the
> last card, think of it as the first card before you start counting.
  (moving joker from bottom to top is not a move?)

  3. Triple cut
    2 4 6 B 5 8 7 1 A 3 9 becomes
    3 9 B 5 8 7 1 A 2 4 6

  4. Count cut
    * clubs, diamond + 13 , hearts + 26, spades + 39,
      both jokers are 53
    * count value of bottom card off the top
    * and 'squish' into bottom of deck
    * ex: if 4 was the 9th card,
      7 ... cards .. 4 5 ... cards ... 8 9 becomes
      5 ... cards ... 8 7 ... cards .. 4 9
   5. Find output card
     * see top card
     * count down that many cards
     * that card's value becomes the output
       unless it's a joker, then you have to repeat
   6. convert card to number

# Keying the Deck
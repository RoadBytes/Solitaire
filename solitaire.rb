class Solitaire
  ALPHABET = ('a'..'z').to_a
  def initialize(key)
    # takes in array of 1 to 54
    @key = key
  end

  def encrypt(message)
    # message_numbers = parse into integers array
      # chars
      # downcase
      # select char ~= [a-z]
      # convert letters to numbers
    # split into 5 chars (maybe not)
      # {1, 5}
    keystream = keystream(message.size)
    encrypted_numbers = add(message_numbers, keystream)
    letters(encrypted_numbers)
  end

  def decrypt(cyphertext)
    # same conversion as encrypt to numbers
    decrypted_numbers = subtract(cyphertext_numbers, keystream)
    letters(decrypted_numbers)
  end

  def add(message, keystream)
    message.each_with_index.map... |message_int, index|
      (message_int + keystream[index]) % 26
    end
  end

  def subtract(message, keystream)
    message.each_with_index.map... |message_int, index|
      (message_int - keystream[index]) % 26
    end
  end

  def letters(encrypted_numbers)
    encrypted_numbers.map do |number|
      ALPHABET[number % 26]
    end.join((.){1,5})
  end

  def keystream(integer)
   returns keystream of size integer
  end
end

#TODO, keystream generation

# Adapter
# ファイルを暗号化するクラス

class Encrypter
  def initialize(key)
    @key = key
  end

  def encrypt(reader, writer)
    key_index = 0
    while not reader.eof?
      clear_char = reader.getc
      encrypted_char = clear_char ^ @key[key_index]
      writer.putc(encrypted_char)
      key_index = (key_index + 1) % @key.size
    end
  end
end

reader = File.open('message.txt')
writer = File.open('message.encrypted', 'w')

encrypter = Encrypter.new('my secret key')
encrypter.encrypt(reader, writer)


class StringIOAdapter
  def initialize
    @string = string
    @position = 0
  end

  def getc
    if @position >= @string.length
      raise EOFError
    end
    ch = @string[@position]
    @position += 1
    return ch
  end

  def eof?
    return @position >= @string.length
  end
end





class Render #表示するクラス
  def render(text_object) # ここにはTextObjectが入る
    text = text_object.text
    size = text_object.size_inches
    color = text_object.color
  end

  def printHoge(text, size, color)
    # 表示するメソッド
  end
end

class TextObject # テキストオブジェクト
  attr_reader :text, :size_inches, :color

  def initialize(text, size_inches, color)
    @text = text
    @size_inches = size_inches
    @color = color
  end
end



class BritishTextObject
  attr_reader :string, :size_mm, :colour

  # ....
end

class BritishTextObjectAdapter < TextObject
  def initialize(bto)
    @bto = bto
  end

  def text
    return @bto.string
  end

  def size_inches
    return @bto.size_mm / 25.4
  end

  def color
    return @bto.colour
  end
end



class BritishTextObject
  attr_reader :string, :size_mm, :colour

  def initialize(string, size_mm, colour)
    @string = string
    @size_mm = size_mm
    @colour = colour
  end
end

class BritishTextObject
  def text
    return string
  end

  def size_inches
    return size_mm / 25.4
  end

  def color
    return colour
  end
end

british_text_object = BritishTextObject.new("momozonno", 12, "red")

p british_text_object.text # => "momozono"
p british_text_object.size_inches# => 0.4724409448818898
p british_text_object.color# => "red"


p british_text_object.colour# => "red"



bto = BritishTextObject.new('hello', 50.8, :blue)

class << bto
  def color
    colour
  end

  def text
    string
  end

  def size_inches
    size_mm / 25.4
  end
end

p bto.color

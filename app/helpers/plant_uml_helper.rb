require "zlib"

module PlantUmlHelper


  def self.encode6bit(bit)
    return ('0'.ord + bit).chr if bit < 10

    bit -= 10
    return ('A'.ord + bit).chr if bit < 26

    bit -= 26
    return ('a'.ord + bit).chr if bit < 26

    bit -= 26
    return '-' if bit.zero?

    return '_' if bit == 1

    '?'
  end

  def self.append3bytes(bit1, bit2, bit3)
    c1 = bit1 >> 2
    c2 = ((bit1 & 0x3) << 4) | (bit2 >> 4)
    c3 = ((bit2 & 0xF) << 2) | (bit3 >> 6)
    c4 = bit3 & 0x3F
    self.encode6bit(c1 & 0x3F).chr +
        self.encode6bit(c2 & 0x3F).chr +
        self.encode6bit(c3 & 0x3F).chr +
        self.encode6bit(c4 & 0x3F).chr
  end

  def self.plantuml(text)
    result = ''
    compressed_data = Zlib::Deflate.deflate(text)
    compressed_data.chars.each_slice(3) do |bytes|
      # print bytes[0], ' ' , bytes[1] , ' ' , bytes[2]
      b1 = bytes[0].nil? ? 0 : (bytes[0].ord & 0xFF)
      b2 = bytes[1].nil? ? 0 : (bytes[1].ord & 0xFF)
      b3 = bytes[2].nil? ? 0 : (bytes[2].ord & 0xFF)
      result += self.append3bytes(b1, b2, b3)
    end
    result
  end
end
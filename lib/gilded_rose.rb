class GildedRose

  attr_accessor :items

  def initialize(items)
    @items = items
    @unique = {
      brie: "Aged Brie",
      sulfuras: "Sulfuras, Hand of Ragnaros",
      pass: "Backstage passes to a TAFKAL80ETC concert"
    }
  end

  def update_quality()
    @items.each do |item|
      if (!@unique.key(item.name))
        item.sell_in -= 1
        item.quality -= 1 if item.quality > 0
        item.quality -= 1 if item.sell_in < 0
      end
    end
  end


end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end

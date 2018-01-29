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
      reduce_sell_in(item)
      update_generic(item)
      update_brie(item)
      update_pass(item)
    end
  end

  private
  def update_brie(item)
    if item.name == @unique[:brie]
      increase_quality(item) if item.quality < 50
    end
  end

  def update_pass(item)
    if item.name == @unique[:pass]
      increase_quality(item)
      increase_quality(item) if item.sell_in <= 10 && item.quality < 50
      increase_quality(item) if item.sell_in <= 5 && item.quality < 50
    end
  end

  def update_generic(item)
    if !@unique.key(item.name)
      decrease_quality(item) if item.quality > 0
      decrease_quality(item) if item.sell_in < 0
    end
  end

  def reduce_sell_in(item)
    item.sell_in -= 1 unless item.name == @unique[:sulfuras]
  end

  def increase_quality(item)
    item.quality += 1
  end

  def decrease_quality(item)
    item.quality -= 1
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

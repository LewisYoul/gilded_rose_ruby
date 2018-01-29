require 'gilded_rose'

describe GildedRose do

  before(:each) do
    @items = [
      Item.new(name="+5 Dexterity Vest", sell_in=10, quality=20),
      Item.new(name="+5 Dexterity Vest", sell_in=10, quality=0),
      Item.new(name="+5 Dexterity Vest", sell_in=-1, quality=10),
      Item.new(name="Aged Brie", sell_in=2, quality=0),
      Item.new(name="Aged Brie", sell_in=2, quality=50),
      Item.new(name="Elixir of the Mongoose", sell_in=5, quality=7),
      Item.new(name="Sulfuras, Hand of Ragnaros", sell_in=0, quality=80),
      Item.new(name="Sulfuras, Hand of Ragnaros", sell_in=-1, quality=80),
      Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=15, quality=20),
      Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=10, quality=49),
      Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=5, quality=49),
      # This Conjured item does not work properly yet
      Item.new(name="Conjured Mana Cake", sell_in=3, quality=6), # <-- :O
    ]

    @shop = GildedRose.new(@items)
  end

  describe "#update_quality" do

    describe "+5 dexterity vest (generic item)" do
      it "reduces the sellIn by 1 when a day passes" do
        @shop.update_quality()
        expect(@shop.items[0].sell_in).to eq(9)
      end
      it "reduces the quality by 1 when a day passes" do
        @shop.update_quality()
        expect(@shop.items[0].quality).to eq(19)
      end
      it "doesn't reduce quality by 1 if already at 0" do
        @shop.update_quality()
        expect(@shop.items[1].quality).to eq(0)
      end
      it "reduces the quality by 2 if the sell_in is negative" do
        @shop.update_quality()
        expect(@shop.items[2].quality).to eq(8)
      end
    end

    describe "Aged Brie" do
      it "reduces sell_in by 1 when a day passes" do
        @shop.update_quality()
        expect(@shop.items[3].sell_in).to eq(1)
      end
      it "increases the quality by 1 when a day passes" do
        @shop.update_quality()
        expect(@shop.items[3].quality).to eq(1)
      end
      it "doesn't increase the quality by 1 if already at 50" do
        @shop.update_quality()
        expect(@shop.items[4].quality).to eq(50)
      end
    end

    describe "Sulfuras" do
      it "doesn't decrease the sell_in by 1" do
        @shop.update_quality()
        expect(@shop.items[6].sell_in).to eq(0)
      end
      it "doesn't increase the quality by 1" do
        @shop.update_quality()
        expect(@shop.items[6].quality).to eq(80)
      end
    end
  end

end

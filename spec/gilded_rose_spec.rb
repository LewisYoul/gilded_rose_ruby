require 'gilded_rose'

describe GildedRose do

  before(:each) do
    @items = [
      Item.new(name="+5 Dexterity Vest", sell_in=10, quality=20), #0
      Item.new(name="+5 Dexterity Vest", sell_in=10, quality=0), #1
      Item.new(name="+5 Dexterity Vest", sell_in=-1, quality=10), #2
      Item.new(name="Aged Brie", sell_in=2, quality=0), #3
      Item.new(name="Aged Brie", sell_in=2, quality=50), #4
      Item.new(name="Elixir of the Mongoose", sell_in=5, quality=7), #5
      Item.new(name="Sulfuras, Hand of Ragnaros", sell_in=0, quality=80), #6
      Item.new(name="Sulfuras, Hand of Ragnaros", sell_in=-1, quality=80), #7
      Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=15, quality=20), #8
      Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=10, quality=40), #9
      Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=5, quality=40), #10
      # This Conjured item does not work properly yet
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

    describe "Backstage Passes" do
      it "decreases sell_in by 1" do
        @shop.update_quality()
        expect(@shop.items[8].sell_in).to eq(14)
      end
      it "increases quality by 1" do
        @shop.update_quality()
        expect(@shop.items[8].quality).to eq(21)
      end
      it "increases quality by 2 if there are 10 days or less to expiry" do
        @shop.update_quality()
        expect(@shop.items[9].quality).to eq(42)
      end
      it "increases quality by 3 if there are 5 days or less to expiry" do
        @shop.update_quality()
        expect(@shop.items[10].quality).to eq(43)
      end
      it "doesn't increase quality above 50 when" do
        shop = GildedRose.new([Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=20, quality=50)])
        shop.update_quality()
        expect(shop.items[0].quality).to eq(50)
      end
      it "doesn't increase quality above 50 when sell_in <= 10" do
        shop = GildedRose.new([Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=10, quality=49)])
        shop.update_quality()
        expect(shop.items[0].quality).to eq(50)
      end
      it "doesn't increase quality above 50 when sell_in <= 5" do
        shop = GildedRose.new([Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=5, quality=49)])
        shop.update_quality()
        expect(shop.items[0].quality).to eq(50)
      end
      it "resets quality to 0 when sell_in is passed" do
        shop = GildedRose.new([Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=0, quality=50)])
        shop.update_quality()
        expect(shop.items[0].quality).to eq(0)
      end
    end

    describe "Conjured Items" do
      it "decreases sell_in by 1" do
        shop = GildedRose.new([Item.new(name="Conjured Mana Cake", sell_in=3, quality=6)])
        shop.update_quality()
        expect(shop.items[0].sell_in).to eq(2)
      end
      it "decreases quality by 2" do
        shop = GildedRose.new([Item.new(name="Conjured Mana Cake", sell_in=3, quality=6)])
        shop.update_quality()
        expect(shop.items[0].quality).to eq(4)
      end
    end
  end

end

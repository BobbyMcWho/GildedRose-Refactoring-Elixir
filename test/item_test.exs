defmodule ItemTest do
  use ExUnit.Case

  describe "Generic" do
    test "an item's quality degrades" do
      item = %Item{name: "Generic", sell_in: 8, quality: 10}

      assert Item.update(item) == %Item{name: "Generic", sell_in: 7, quality: 9}
    end

    test "an item's quality degrades by two when past expiration" do
      item = %Item{name: "Generic", sell_in: 0, quality: 10}

      assert Item.update(item) == %Item{name: "Generic", sell_in: -1, quality: 8}
    end

    test "an items quality does not decrease less than 0" do
      item = %Item{name: "Generic", sell_in: 0, quality: 0}

      assert Item.update(item) == %Item{name: "Generic", sell_in: -1, quality: 0}
    end
  end

  describe "Brie" do
    test "it increases in quality over time" do
      item = %Item{name: "Aged Brie", sell_in: 100, quality: 5}

      assert Item.update(item) == %Item{name: "Aged Brie", sell_in: 99, quality: 6}
    end

    test "it increases only to 50" do
      item = %Item{name: "Aged Brie", sell_in: 100, quality: 50}

      assert Item.update(item) == %Item{name: "Aged Brie", sell_in: 99, quality: 50}
    end
  end

  describe "Sulfurus" do
    test "it sets values to fixed amounts" do
      item = %Item{name: "Sulfuras, Hand of Ragnaros", sell_in: 100, quality: 50}

      assert Item.update(item) == %Item{name: "Sulfuras, Hand of Ragnaros", sell_in: nil, quality: 80}
    end
  end

  describe "BackStage" do
    test "quality increases by 3 when sell_in is <= 5" do
      item = %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 5, quality: 40}

      assert Item.update(item) == %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 4, quality: 43}
    end

    test "quality increases by 2 when 5 < sell_in <= 10" do
      item = %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 8, quality: 40}

      assert Item.update(item) == %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 7, quality: 42}
    end

    test "quality does not increase past 50" do
      item = %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 5, quality: 50}

      assert Item.update(item) == %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 4, quality: 50}
    end

    test "quality drops to 0 when the event has passed" do
      item = %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 0, quality: 50}

      assert Item.update(item) == %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: -1, quality: 0}
    end
  end

  describe "Conjured" do
    test "an item's quality degrades by 2 while sell_by > 0 " do
      item = %Item{name: "Conjured Item", sell_in: 8, quality: 10}

      assert Item.update(item) == %Item{name: "Conjured Item", sell_in: 7, quality: 8}
    end

    test "an item's quality degrades by 4 when past expiration" do
      item = %Item{name: "Conjured Item", sell_in: 0, quality: 10}

      assert Item.update(item) == %Item{name: "Conjured Item", sell_in: -1, quality: 6}
    end

    test "an items quality does not decrease less than 0" do
      item = %Item{name: "Conjured Item", sell_in: 0, quality: 0}

      assert Item.update(item) == %Item{name: "Conjured Item", sell_in: -1, quality: 0}
    end
  end
end

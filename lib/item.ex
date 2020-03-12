defmodule Item do
  @moduledoc """
  Struct and base behaviour for items.
  """
  defstruct [:name, :sell_in, :quality]
  @callback update(Item.t()) :: Item.t()
  @callback update_sell_in(Item.t()) :: Item.t()
  @callback update_quality(Item.t()) :: Item.t()

  defmacro __using__(_) do
    quote do
      @behaviour Item

      def update(item) do
        item
        |> update_sell_in()
        |> update_quality()
      end
      defoverridable update: 1

      def update_sell_in(item) do
        %{item | sell_in: item.sell_in - 1}
      end
      defoverridable update_sell_in: 1

      def update_quality(%{quality: 0} = item), do: item

      def update_quality(%{sell_in: sell_in} = item) when sell_in < 0 do
        %{item | quality: item.quality - 2}
      end

      def update_quality(item) do
        %{item | quality: item.quality - 1}
      end

      defoverridable update_quality: 1
    end
  end

  def update(item) do
    imp = implementation(item)
    imp.update(item)
  end

  defp implementation(%{name: name}) do
    case name do
      "Sulfuras, Hand of Ragnaros" -> Sulfuras
      "Aged Brie" -> Brie
      "Backstage passes to a TAFKAL80ETC concert" -> BackStage
      "Conjured" <> _item_name -> Conjured
      _ -> Generic
    end
  end
end

defmodule Generic do
  @moduledoc """
  Item behaviour for generic items
  """
  use Item
end

defmodule Brie do
  @moduledoc """
  Item behaviour for "Aged Brie"
  """
  use Item

  def update_quality(%{quality: quality} = item) when quality >= 50 do
    %{item | quality: 50}
  end

  def update_quality(item) do
    %{item | quality: item.quality + 1}
  end
end

defmodule Sulfuras do
  @moduledoc """
  Item behaviour for "Sulfuras, Hand of Ragnaros"
  """
  use Item
  def update(item), do: %{item | quality: 80, sell_in: nil}
end

defmodule BackStage do
  @moduledoc """
  Item behaviour for "Backstage passes to a TAFKAL80ETC concert"
  """
  use Item

  def update_quality(%{sell_in: sell_in} = item) when sell_in < 0 do
    %{item | quality: 0}
  end

  def update_quality(%{quality: 0} = item), do: item

  def update_quality(%{quality: 50} = item), do: item

  def update_quality(%{sell_in: sell_in} = item) when sell_in <= 5 do
    %{item | quality: item.quality + 3}
  end

  def update_quality(%{sell_in: sell_in} = item) when sell_in <= 10 do
    %{item | quality: item.quality + 2}
  end
end

defmodule Conjured do
  @moduledoc """
  Item behaviour for conjured items.
  """
  use Item

  def update_quality(%{quality: 0} = item), do: item

  def update_quality(%{sell_in: sell_in} = item) when sell_in < 0 do
    %{item | quality: item.quality - 4}
  end

  def update_quality(item) do
    %{item | quality: item.quality - 2}
  end
end

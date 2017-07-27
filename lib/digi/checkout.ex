defmodule Digi.Checkout do
  defstruct [items: [], total: 0, promotions: [], applied_promotions: []]

  alias Digi.Promotion

  def new do
    struct(__MODULE__)
  end

  def add_item(checkout, product) do
    %{checkout | items: checkout.items ++ [product]}
  end

  def add_promotion(checkout, promotion) do
    %{checkout | promotions: checkout.promotions ++ [promotion]}
  end

  def total(checkout) do
    checkout = calculate_total(checkout)
    checkout.total
  end

  defp calculate_total(checkout) do
    checkout
    |> calculate_sub_total()
    |> apply_promotions()
  end

  defp calculate_sub_total(checkout) do
    checkout
    |> Map.fetch!(:items)
    |> Enum.reduce(checkout, &(%{&2 | total: &2.total + &1.price}))
  end

  defp apply_promotions(checkout) do
    checkout
    |> Map.fetch!(:promotions)
    |> Enum.reduce(checkout, &Promotion.apply/2)
  end
end

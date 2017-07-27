defmodule Digi.Promotion do
  defstruct [:name, :value, :usage_limit, :allocation_method, :entitled_skus,
             :prerequisite_skus, :prerequisite_qty_range]

  def new(attrs) do
    struct(__MODULE__, attrs)
  end

  def apply(promotion, checkout) do
    if apply?(promotion, checkout) do
      do_apply(promotion, checkout)
    else
      checkout
    end
  end

  def apply?(promotion, checkout) do
    not exceed_usage_limit?(promotion, checkout)
    and fulfilled_prerequisite_qty_range?(promotion, checkout)
    and fulfilled_prerequisite_skus?(promotion, checkout)
  end

  defp exceed_usage_limit?(promotion, checkout) do
    checkout
    |> Map.fetch!(:applied_promotions)
    |> Enum.filter(&(&1 == promotion))
    |> Enum.count()
    |> Kernel.>=(promotion.usage_limit)
  end

  defp fulfilled_prerequisite_qty_range?(promotion, checkout) do
    count =
      checkout.items
      |> Enum.filter(&(&1.sku in promotion.entitled_skus))
      |> Enum.count()

    case promotion.prerequisite_qty_range do
      {:gt, value} -> count > value
      {:eq, value} -> count == value
      {:lt, value} -> count < value
      nil          -> true
      _            -> false
    end
  end

  defp fulfilled_prerequisite_skus?(promotion, checkout) do
    if is_nil(promotion.prerequisite_skus) do
      true
    else
      checkout.items
      |> Enum.filter(&(&1.sku in promotion.prerequisite_skus))
      |> Enum.any?()
    end
  end

  defp do_apply(promotion, checkout) do
    case promotion.allocation_method do
      :across ->
        %{checkout | total: checkout.total + promotion.value,
                     applied_promotions: checkout.applied_promotions ++ [promotion]}
      :each ->
        checkout.items
        |> Enum.filter(&(&1.sku in promotion.entitled_skus))
        |> Enum.reduce(checkout, fn _item, checkout ->
          %{checkout | total: checkout.total + promotion.value,
                       applied_promotions: checkout.applied_promotions ++ [promotion]}
        end)
    end
  end
end

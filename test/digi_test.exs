defmodule DigiTest do
  use ExUnit.Case
  doctest Digi

  alias Digi.{Promotion, Checkout, Cashier, Product}

  @ipd_discounted_price 499_99

  setup_all do
    atv = Product.find("ATV")
    ipd = Product.find("IPD")
    vga = Product.find("VGA")

    promo_atv = Promotion.new(name: "Apple TV 3 for 2 Deal",
                              value: -atv.price,
                              prerequisite_qty_range: {:eq, 3},
                              entitled_skus: ["ATV"],
                              usage_limit: 1,
                              allocation_method: :across)

    promo_ipad = Promotion.new(name: "Super iPad Discount",
                               value: -(ipd.price - @ipd_discounted_price),
                               prerequisite_qty_range: {:gt, 4},
                               entitled_skus: ["IPD"],
                               allocation_method: :each)

    promo_mbp = Promotion.new(name: "Free VGA with MBP",
                              value: -vga.price,
                              prerequisite_skus: ["VGA"],
                              entitled_skus: ["MBP"],
                              allocation_method: :each)

    checkout =
      Checkout.new()
      |> Checkout.add_promotion(promo_atv)
      |> Checkout.add_promotion(promo_ipad)
      |> Checkout.add_promotion(promo_mbp)

    {:ok, checkout: checkout}
  end

  test "Cashier Scans [ATV, ATV, ATV, VGA]", state do
    checkout =
      state[:checkout]
      |> Cashier.scan("ATV")
      |> Cashier.scan("ATV")
      |> Cashier.scan("ATV")
      |> Cashier.scan("VGA")

    assert Checkout.total(checkout) == 249_00
  end

  test "Cashier Scans [ATV, IPD, IPD, ATV, IPD, IPD, IPD]", state do
    checkout =
      state[:checkout]
      |> Cashier.scan("ATV")
      |> Cashier.scan("IPD")
      |> Cashier.scan("IPD")
      |> Cashier.scan("ATV")
      |> Cashier.scan("IPD")
      |> Cashier.scan("IPD")
      |> Cashier.scan("IPD")

    assert Checkout.total(checkout) == 2718_95
  end

  test "Cashier Scans [MBP, VGA, IPD]", state do
    checkout =
      state[:checkout]
      |> Cashier.scan("MBP")
      |> Cashier.scan("VGA")
      |> Cashier.scan("IPD")

    assert Checkout.total(checkout) == 1949_98
  end

  test "Cashier Scans [MBP, VGA, IPD, MBP, VGA, IPD]", state do
    checkout =
      state[:checkout]
      |> Cashier.scan("MBP")
      |> Cashier.scan("VGA")
      |> Cashier.scan("IPD")
      |> Cashier.scan("MBP")
      |> Cashier.scan("VGA")
      |> Cashier.scan("IPD")

    assert Checkout.total(checkout) == 1949_98 * 2
  end
end

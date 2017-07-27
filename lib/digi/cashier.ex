defmodule Digi.Cashier do
  alias Digi.{Checkout, Product}

  def scan(checkout, sku) do
    Checkout.add_item(checkout, Product.find!(sku))
  end
end

defmodule Digi.Product do
  defstruct [:sku, :name, :price]

  def new(attrs) do
    struct(__MODULE__, attrs)
  end

  def find(sku) do
    Enum.find(all(), &(&1.sku == sku))
  end

  def find!(sku) do
    with nil <- find(sku) do
      raise RuntimeError, message: "No product with SKU of #{sku} found"
    end
  end

  def all do
    [
      new(sku: "IPD", name: "Super iPad", price: 549_99),
      new(sku: "MBP", name: "MacBook Pro", price: 1399_99),
      new(sku: "ATV", name: "Apple TV", price: 109_50),
      new(sku: "VGA", name: "VGA Adapter", price: 30_00),
    ]
  end
end

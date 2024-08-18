defmodule Oschild.CatalogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Oschild.Catalog` context.
  """

  @doc """
  Generate a unique product sku.
  """
  def unique_product_sku, do: System.unique_integer([:positive])

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        name: "some name",
        sku: unique_product_sku()
      })
      |> Oschild.Catalog.create_product()

    product
  end
end

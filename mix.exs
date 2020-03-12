defmodule GildedRose.Mixfile do
  use Mix.Project

  def project do
    [
      app: :gilded_rose,
     version: "0.0.1",
     elixir: "~> 1.0",
     deps: deps()
    ]
  end

  def deps do
    [
      {:credo, "~> 1.2", only: [:dev, :test], runtime: false}
    ]
  end
end

defmodule Materials.Ingredient do
  use Ecto.Schema
  import Ecto.Changeset

  alias Materials.{Ingredient}

  @derive {Poison.Encoder, except: [:__meta__]}

  schema "ingredients" do
    field(:name)
    field(:frequency, :string, default: "often")
    field(:location, :string)

    timestamps()
  end

  def changeset(%Ingredient{} = ingredient, attrs) do
    ingredient
    |> cast(attrs, [:name, :frequency, :location])
    |> validate_required([:name])
    |> validate_inclusion(:frequency, ["barely", "sometimes", "often"])
    |> unique_constraint(:name)
  end

  def parse_components(components) do
    String.split(components, "@")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
    |> List.to_tuple()
    |> apply_defaults()
  end

  def apply_defaults({name, location}), do: {name, location}
  def apply_defaults({name}), do: {name, "Kroger"}
end

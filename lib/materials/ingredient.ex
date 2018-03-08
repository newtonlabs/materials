defmodule Materials.Ingredient do
  use Ecto.Schema
  import Ecto.Changeset

  alias Materials.{Ingredient}

  schema "ingredients" do
    field(:name)
    field(:frequency, :string, default: "often")
    field(:location)

    timestamps()
  end

  def changeset(%Ingredient{} = ingredient, attrs) do
    ingredient
    |> cast(attrs, [:name, :frequency, :location])
    |> validate_required([:name])
    |> validate_inclusion(:frequency, ["barely", "sometimes", "often"])
    |> unique_constraint(:name)
  end
end

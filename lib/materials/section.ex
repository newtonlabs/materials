defmodule Materials.Section do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias Materials.{Repo, RecipeCard}

  @derive {Poison.Encoder, except: [:__meta__]}

  schema "sections" do
    field(:name)

    has_many(:recipe_cards, RecipeCard)

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
  end
end

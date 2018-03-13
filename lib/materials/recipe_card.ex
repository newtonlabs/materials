defmodule Materials.RecipeCard do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias Materials.{Repo, Ingredient}

  @derive {Poison.Encoder, except: [:__meta__]}

  schema "recipe_cards" do
    field(:name)
    field(:body)

    many_to_many(
      :ingredients,
      Ingredient,
      join_through: "recipe_cards_dishes",
      on_replace: :delete
    )

    belongs_to(:section, Section)

    timestamps()
  end

  def changeset(struct, %{section: section} = params \\ %{}) do
    struct
    |> cast(params, [:name, :body])
    |> unique_constraint(:name)
    |> put_assoc(:ingredients, parse_ingredients(params))
    |> put_assoc(:section, section)
  end

  def parse_ingredients(params) do
    (params[:ingredients] || "")
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
    |> insert_and_get_all()
  end

  def insert_and_get_all([]) do
    []
  end

  def insert_and_get_all(names) do
    maps =
      Enum.map(names, fn name ->
        %{
          name: name,
          inserted_at: DateTime.utc_now(),
          updated_at: DateTime.utc_now(),
          location: "Kroger"
        }
      end)

    Repo.insert_all(Ingredient, maps, on_conflict: :nothing)
    Repo.all(from(t in Ingredient, where: t.name in ^names))
  end
end

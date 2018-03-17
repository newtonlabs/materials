require IEx

defmodule Materials.Card do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias Materials.{Repo, Ingredient, Section}

  @derive {Poison.Encoder, except: [:__meta__, :section]}

  schema "cards" do
    field(:name)
    field(:body)

    many_to_many(
      :ingredients,
      Ingredient,
      join_through: "cards_ingredients",
      on_replace: :delete
    )

    belongs_to(:section, Section)

    timestamps()
  end

  def changeset(struct, %{section_id: _section_id, name: _name} = params) do
    struct
    |> cast(params, [:name, :body, :section_id])
    |> unique_constraint(:name)
    |> put_assoc(:ingredients, parse_ingredients(params))
    |> cast_assoc(:section)
  end

  def changeset(struct, %{body: _body, name: _name} = params) do
    struct
    |> cast(params, [:name, :body])
  end

  def changeset(struct, %{ingredients: _ingredients} = params) do
    struct
    |> change()
    |> put_assoc(:ingredients, parse_ingredients(params))
  end

  def changeset(struct, %{section_id: _section_id} = params) do
    struct
    |> cast(params, [:section_id])
    |> cast_assoc(:section)
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
        {ingredient_name, location} = Ingredient.parse_location(name)

        %{
          name: ingredient_name,
          inserted_at: DateTime.utc_now(),
          updated_at: DateTime.utc_now(),
          location: location
        }
      end)

    names = Enum.map(maps, & &1.name)

    Repo.insert_all(Ingredient, maps, on_conflict: :nothing)
    Repo.all(from(t in Ingredient, where: t.name in ^names))
  end
end

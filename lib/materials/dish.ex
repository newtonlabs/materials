defmodule Materials.Dish do
  use Ecto.Schema
  use Timex

  import Ecto.Changeset
  import Ecto.Query

  alias Materials.{Repo, Ingredient}

  schema "dishes" do
    field(:name)
    field(:body)

    many_to_many(
      :ingredients,
      Ingredient,
      join_through: "dishes_ingredients",
      on_replace: :delete,
      on_delete: :delete_all
    )

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :body])
    |> unique_constraint(:name)
    |> put_assoc(:ingredients, parse_ingredients(params))
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
        %{name: name, inserted_at: Timex.now(), updated_at: Timex.now()}
      end)

    Repo.insert_all(Ingredient, maps, on_conflict: :nothing)
    Repo.all(from(t in Ingredient, where: t.name in ^names))
  end
end

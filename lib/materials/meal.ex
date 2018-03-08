defmodule Materials.Meal do
  use Ecto.Schema

  import Ecto.Query

  alias Materials.{Repo, Dish}

  schema "meals" do
    field(:name)

    many_to_many(
      :dishes,
      Dish,
      join_through: "meals_dishes",
      on_replace: :delete
    )

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params, [:name])
    |> Ecto.Changeset.put_assoc(:dishes, parse_dishes(params))
  end

  def parse_dishes(params) do
    (params[:dishes] || "")
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
        %{name: name, inserted_at: DateTime.utc_now(), updated_at: DateTime.utc_now()}
      end)

    Repo.insert_all(Dish, maps, on_conflict: :nothing)
    Repo.all(from(t in Dish, where: t.name in ^names))
  end
end

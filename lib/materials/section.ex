defmodule Materials.Section do
  use Ecto.Schema

  import Ecto.Changeset

  alias Materials.{Card, Box}

  @derive {Poison.Encoder, except: [:__meta__, :box]}

  schema "sections" do
    field(:name)

    has_many(:cards, Card)
    belongs_to(:box, Box)

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :box_id])
    |> cast_assoc(:box)
  end
end

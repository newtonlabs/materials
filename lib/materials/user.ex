require IEx

defmodule Materials.User do
  use Ecto.Schema

  import Ecto.Query

  alias Materials.{Box, Section}
  alias Ecto.Changeset

  @derive {Poison.Encoder, except: [:__meta__]}

  schema "users" do
    field(:email)

    has_many(:boxes, Box)

    timestamps()
  end

  def changeset(struct, %{boxes: boxes} = params) do
    struct
    |> Ecto.Changeset.change()
    |> Changeset.put_assoc(:boxes, boxes)
  end

  def changeset(struct, %{name: name} = params) do
    struct
    |> Changeset.cast(params, [:name])
  end
end

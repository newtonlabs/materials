require IEx

defmodule Materials.Box do
  use Ecto.Schema

  alias Materials.{Section, User}
  alias Ecto.Changeset

  @derive {Poison.Encoder, except: [:__meta__, :user]}

  schema "boxes" do
    field(:name)

    has_many(:sections, Section)
    belongs_to(:user, User)

    timestamps()
  end

  def changeset(struct, params) do
    struct
    |> Changeset.cast(params, [:name, :user_id])
    |> Changeset.cast_assoc(:user)
  end
end

require IEx

defmodule Materials.Boxes do
  import Ecto.Query, warn: false
  alias Materials.{Repo, Box}

  def create_box(attrs \\ %{}) do
    %Box{}
    |> Box.changeset(attrs)
    |> Repo.insert()
  end
end

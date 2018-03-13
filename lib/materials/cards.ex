defmodule Materials.Cards do
  import Ecto.Query, warn: false
  alias Materials.{Repo, Card}

  def create_card(attrs \\ %{}) do
    %Card{}
    |> Card.changeset(attrs)
    |> Repo.insert()
  end

  def update_card(%Card{} = card, attrs) do
    card
    |> Card.changeset(attrs)
    |> Repo.update()
  end

  def get_card!(id), do: Repo.get!(Card, id)

  def list_card() do
    Repo.all(Card) |> Repo.preload(:ingredients)
  end

  def get_card!(id), do: Repo.get!(Card, id) |> Repo.preload([:ingredients])
end

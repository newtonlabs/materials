defmodule Materials.Users do
  import Ecto.Query, warn: false
  alias Materials.{Repo, Box, User}

  # TODO Temporary while hacking
  def get_first_user_first_box() do
    user = List.first(Repo.all(User) |> Repo.preload(:boxes))
    List.first(user.boxes)
  end

  def data_dump do
    get_first_user_first_box
    |> Repo.preload(sections: [cards: :ingredients])
    |> Repo.preload(:user)
  end
end

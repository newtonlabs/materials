defmodule MaterialsWeb.PageController do
  use MaterialsWeb, :controller

  alias Materials.{Boxes, Users}

  def index(conn, _params) do
    # TODO making filler assumptions for 1 user
    users_box = Users.data_dump()
    planned = Enum.find(users_box.sections, &(&1.name == "This Week"))
    recipe_box = Enum.find(users_box.sections, &(&1.name == "Recipe Box"))

    # Today this is only one section of planned, future could be everything minus recipe_box
    shopping_list = Boxes.shopping_list([planned])

    render(
      conn,
      "index.html",
      dishes: recipe_box.cards,
      shopping_list: shopping_list,
      meals: planned.cards
    )
  end
end

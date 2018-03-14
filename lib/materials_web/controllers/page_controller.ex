defmodule MaterialsWeb.PageController do
  use MaterialsWeb, :controller

  alias Materials.{Boxes, Users}

  def index(conn, _params) do
    # TODO making filler assumptions for 1 user and dumping all data,
    # these queries should be made much more efficient
    users_box = Users.data_dump()
    this_week = Enum.find(users_box.sections, &(&1.name == "This Week"))
    recipe_box = Enum.find(users_box.sections, &(&1.name == "Recipe Box"))

    # Today this is only one section of planned, future could be everything
    # minus recipe_box
    shopping_list = Boxes.shopping_list([this_week])

    render(
      conn,
      "index.html",
      recipe_box: recipe_box,
      this_week: this_week,
      shopping_list: shopping_list
    )
  end
end

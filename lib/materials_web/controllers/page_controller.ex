defmodule MaterialsWeb.PageController do
  use MaterialsWeb, :controller

  alias Materials.{Dishes, Meals, Repo, Meal, Dish}

  def index(conn, _params) do
    # TODO Hacking to prove out concept

    planned = Repo.all(Meal) |> Repo.preload(:dishes) |> List.first()
    planned = planned.dishes

    all_dishes = Repo.all(Dish)
    all_dishes = all_dishes -- planned

    shopping_list = Meals.list_meals() |> Meals.shopping_list()

    render(
      conn,
      "index.html",
      dishes: all_dishes,
      shopping_list: shopping_list,
      meals: planned
    )
  end
end

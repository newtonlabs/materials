defmodule MaterialsWeb.PageController do
  use MaterialsWeb, :controller

  alias Materials.{Dishes, Meals}

  def index(conn, _params) do
    dishes = Dishes.list_dishes()
    meals = Meals.list_meals()
    selected_meals = Enum.flat_map(meals, & &1.dishes)
    shopping_list = Meals.shopping_list(meals)

    render(
      conn,
      "index.html",
      dishes: dishes,
      shopping_list: shopping_list,
      meals: selected_meals
    )
  end
end

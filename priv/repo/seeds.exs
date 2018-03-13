# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Materials.Repo.insert!(%Materials.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

user = Materials.Repo.insert!(%Materials.User{email: "foo@example.com"})
{:ok, box} = Materials.Boxes.create_box(%{name: "My Recipe Box", user_id: user.id})

# TODO Need to make this more dynamic eventually
{:ok, section} = Materials.Sections.create_section(%{name: "Recipe Box", box_id: box.id})
Materials.Sections.create_section(%{name: "This Week", box_id: box.id})

MaterialsCli.Data.load_board_from_csv(section)

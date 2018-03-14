require IEx

defmodule MaterialsTest do
  use Materials.DataCase
  alias Materials.{Card, Cards, Sections}

  describe "cards" do
    @card_attrs %{name: "card name", ingredients: "a,b,c"}
    # @box_attrs %{name: "box name"}
    @section_attrs %{name: "section name"}

    def card_fixture(attrs \\ %{}) do
      {:ok, card} =
        attrs
        |> Enum.into(@card_attrs)
        |> Cards.create_card()

      card
    end

    # def box_fixture(attrs \\ %{}) do
    #   {:ok, table} =
    #     attrs
    #     |> Enum.into(@box_attrs)
    #     |> Boxes.create_box()
    #
    #   table
    # end

    def section_fixture(attrs \\ %{}) do
      {:ok, section} =
        attrs
        |> Enum.into(@section_attrs)
        |> Sections.create_section()

      section
    end

    def full_fixture(attrs \\ %{}) do
      # box = box_fixture()
      section = section_fixture()

      attrs =
        @card_attrs
        |> Enum.into(attrs)
        |> Enum.into(%{section_id: section.id})

      {:ok, card} = Cards.create_card(attrs)
      card
    end

    test "create_card/1 with valid data creates a card" do
      # box = box_fixture()
      section = section_fixture()

      attrs =
        @card_attrs
        |> Enum.into(%{section_id: section.id})

      assert {:ok, %Card{} = card} = Cards.create_card(attrs)
      # assert card.box_id == box.id
      assert card.section_id == section.id
      assert Enum.count(card.ingredients) == 3
    end

    test "update_card/2 with valid data updates the card" do
      card = full_fixture()
      section = section_fixture(%{name: "new section name"})

      assert {:ok, card} =
               Cards.update_card(card, %{
                 name: "some updated name",
                 section_id: section.id
               })

      assert %Card{} = card
      assert card.name == "some updated name"
      assert card.section_id == section.id
    end

    test "get_card/1 with gets the card and preloads" do
      card = full_fixture()
      fetched = Cards.get_card!(card.id)
      assert card.id == fetched.id
    end

    # test "get_card/1 with gets the card and preloads" do
    #   card = full_fixture()
    #   fetched = Cards.get_card!(card.id)
    #   assert fetched.table.name == "table name"
    #   assert fetched.section.name == "section name"
    # end

    # test "get_card/1 with gets the card and preloads" do
    #   card = full_fixture()
    #   fetched = Cards.get_card!(card.id)
    #   assert fetched.table.name == "table name"
    #   assert fetched.section.name == "section name"
    # end
  end
end

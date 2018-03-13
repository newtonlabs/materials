defmodule Materials.Sections do
  import Ecto.Query, warn: false
  alias Materials.{Repo, Section}

  def list_sections do
    Repo.all(Section)
  end

  def get_section!(id), do: Repo.get!(Section, id)

  def create_section(attrs \\ %{}) do
    %Section{}
    |> Section.changeset(attrs)
    |> Repo.insert()
  end

  def update_section(%Section{} = section, attrs) do
    section
    |> Section.changeset(attrs)
    |> Repo.update()
  end

  def delete_section(%Section{} = section) do
    Repo.delete(section)
  end

  def change_section(%Section{} = section) do
    Section.changeset(section, %{})
  end
end

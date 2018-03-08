defmodule Materials.Repo.Migrations.CreateDishes do
  use Ecto.Migration

  def change do
    create table(:dishes) do
      add(:name, :string)
      add(:body, :string)

      timestamps()
    end

    create(unique_index(:dishes, [:name]))
  end
end

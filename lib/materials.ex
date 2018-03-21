defmodule Materials do
  @moduledoc """
  Materials keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  # Hard code for now
  alias Materials.{Users, Wunderlist}

  def main(args) do
    args
    |> parse_args
    |> process
  end

  def process(options) do
    Users.shopping_list()
    |> Enum.map(&Wunderlist.add_task(125_473_172, &1, options))
    |> Enum.each(&IO.inspect(&1))
  end

  def parse_args(args) do
    {options, _, _} = OptionParser.parse(args, switches: [commit: :boolean])
    options
  end
end

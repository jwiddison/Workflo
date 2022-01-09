defmodule Workflo.Test do
  @moduledoc """
  Some description about what this module does
  """
  @module_attributes "Work sort of like constants"

  @doc """
  Has some weird pattern matches, but will add two
  integers together if it receives two non-1 values
  """
  @spec some_function(list | integer, any) :: String.t() | integer
  def some_function(list, _) when is_list(list), do: "A LIST??"
  def some_function(1, 1), do: @module_attributes

  def some_function(a, b) do
    a + b
  end

  @spec another_function(list | integer, any) :: {:ok, integer} | {:error, atom}
  def another_function(x, y) do
    case some_function(x, y) do
      "A LIST??" -> {:error, :list}
      @module_attributes -> {:error, :ones}
      x when is_integer(x) -> {:ok, x}
    end
  end

  def too_much_cmon_man(arg_1, arg_2) do
    with x when is_integer(x) <- some_function(arg_1, arg_2),
         {:ok, y} <- another_function(x, arg_2) do
      {:ok, y}
    end
  end
end

defmodule Workflo do
  @moduledoc """
  TODO
  """

  defmodule InvalidWorkflowException do
    defexception [:message]
  end

  defmacro __using__(_opts) do
    quote do
      @before_compile Workflo
    end
  end

  defmacro __before_compile__(env) do
    ensure_at_least_one_step!(env.module)
  end

  defmacro step(pattern, func, args) do
    quote do
      case unquote(func).(unquote(args)) do
        ^unquote(pattern) = return -> return
        other -> other
      end
    end
  end

  ################################################################################
  # PRIVATE
  ################################################################################

  @spec ensure_at_least_one_step!(module) :: nil | no_return
  defp ensure_at_least_one_step!(_workflow_module) do
    unless false do
      raise InvalidWorkflowException, """
      Workflows must define at least one step
      """
    end
  end
end

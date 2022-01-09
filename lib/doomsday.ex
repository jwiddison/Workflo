defmodule Doomsday do
  @moduledoc """
  For figuring out the day of week
  """

  @type day :: 1..31
  @type doomsday :: 0..6
  @type month :: 1..12
  @type year :: 1900..2099
  @type year_in_century :: 0..99

  @day_mappings %{
    0 => "Sunday",
    1 => "Monday",
    2 => "Tuesday",
    3 => "Wednesday",
    4 => "Thursday",
    5 => "Friday",
    6 => "Saturday"
  }

  @doc """
  Gives the day of the year for a given day, month, and year.
  Checks for valid dates, leap years, etc.
  Only supports 1990 to 2099 for now

  Example: (January 7, 1990)

      iex> find(1, 7, 1990)
      "Sunday"
  """
  @spec find(day, month, year, keyword) :: String.t()
  def find(day, month, year, options \\ [])
  def find(day, _month, _year, _opts) when day not in 1..31, do: "Invalid Day"
  def find(_day, month, _year, _opts) when month not in 1..12, do: "Invalid Month"
  def find(_day, _month, year, _opts) when year < 0 or year > 9_999, do: "Invalid Year"
  def find(31, month, _year, _opts) when month in [2, 4, 6, 9, 11], do: "Month doesn't have 31 days"
  def find(day, 2, _year, _opts) when day > 29, do: "February doesn't have that many days"

  def find(29, 2, year, []) do
    # If the year is divisible by 4 with no remainder, its a leap year
    if rem(year, 4) == 0 do
      opts = [already_checked: true]
      find(29, 2, year, opts)
    else
      "Not a leap year, no February 29th"
    end
  end

  def find(day, month, year, _opts) do
    is_leap_year = rem(year, 4) == 0

    with century_doomsday when is_integer(century_doomsday) <- century_doomsday_for_year(year),
         year_in_century <- year_in_century(year),
         year_doomsday <- year_doomsday(century_doomsday, year_in_century),
         anchor_day_in_month <- closest_doomsday_in_month(month, is_leap_year),
         final_day <- find_final_day(day, anchor_day_in_month, year_doomsday) do
      Map.get(@day_mappings, final_day)
    else
      error_msg when is_binary(error_msg) -> error_msg
    end
  end

  ################################################################################
  # PRIVATE
  ################################################################################

  @spec century_doomsday_for_year(year) :: doomsday | String.t()
  defp century_doomsday_for_year(year) when year in 1900..1999, do: 3
  defp century_doomsday_for_year(year) when year in 2000..2099, do: 2
  defp century_doomsday_for_year(_year), do: "Year not yet supported"

  @spec closest_doomsday_in_month(month, boolean) :: day
  defp closest_doomsday_in_month(month, is_leap_year?) do
    case month do
      1 -> if is_leap_year?, do: 4, else: 3
      2 -> if is_leap_year?, do: 29, else: 28
      3 -> 14
      4 -> 4
      5 -> 9
      6 -> 6
      7 -> 11
      8 -> 8
      9 -> 5
      10 -> 10
      11 -> 7
      12 -> 12
    end
  end

  @spec find_final_day(day, day, doomsday) :: doomsday
  defp find_final_day(day, anchor_day_in_month, year_doomsday) do
    if day < anchor_day_in_month do
      # Before doomsday
      days_to_go_back = anchor_day_in_month - day

      year_doomsday
      |> Kernel.-(days_to_go_back)
      |> make_it_positive()
    else
      # On or after doomsday
      day
      |> Kernel.-(anchor_day_in_month)
      |> Kernel.+(year_doomsday)
      |> Kernel.rem(7)
    end
  end

  @spec make_it_positive(integer) :: non_neg_integer
  defp make_it_positive(x) when x < 0, do: make_it_positive(x + 7)
  defp make_it_positive(x) when x >= 0, do: x

  @spec year_doomsday(doomsday, year_in_century) :: doomsday
  defp year_doomsday(century_doomsday, year_in_century) do
    days_to_add = year_in_century + div(year_in_century, 4)

    century_doomsday
    |> Kernel.+(days_to_add)
    |> Kernel.rem(7)
  end

  @spec year_in_century(year) :: year_in_century
  defp year_in_century(year) when year in 1900..1999, do: rem(year, 1900)
  defp year_in_century(year) when year in 2000..2099, do: rem(year, 2000)
end

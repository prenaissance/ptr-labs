defmodule Algorithms do
  @moduledoc "Algorithms for tasks in lab 1"
  @spec prime?(number) :: boolean
  def prime?(n) do
    if n < 2 do
      false
    else
      Enum.all?(2..(n - 1), &(rem(n, &1) != 0))
    end
  end

  @spec cylinder_area(number, number) :: float
  def cylinder_area(r, h) do
    2 * :math.pi() * r * (r + h)
  end

  @spec reverse(list) :: list
  def reverse(list, acc \\ []) do
    case list do
      [] -> acc
      [head | tail] -> reverse(tail, [head | acc])
    end
  end

  @spec unique_sum(list) :: number
  def unique_sum(list, dict \\ %{}) do
    case list do
      [] -> dict |> Map.values() |> Enum.sum()
      [head | tail] -> unique_sum(tail, Map.put(dict, head, head))
    end
  end

  @spec extract_random_n(list, number) :: list
  def extract_random_n(list, n) do
    case {list, n} do
      {[], _} -> []
      {_, 0} -> []
      {list, n} -> [Enum.random(list) | extract_random_n(list, n - 1)]
    end
  end

  def first_fibonacci_elements(n, head \\ []) do
    case {n, head} do
      {0, _} -> Enum.reverse(head)
      {_, []} -> first_fibonacci_elements(n - 1, [1])
      {_, [1]} -> first_fibonacci_elements(n - 1, [1, 1])
      {_, [head | tail]} -> first_fibonacci_elements(n - 1, [head + hd(tail) | [head | tail]])
      {_, _} -> :error
    end
  end
end

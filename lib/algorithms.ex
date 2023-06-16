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

  @spec extract_random_n(list, integer) :: list
  def extract_random_n(list, n) do
    case {list, n} do
      {[], _} -> []
      {_, 0} -> []
      {list, n} -> [Enum.random(list) | extract_random_n(list, n - 1)]
    end
  end

  @spec first_fibonacci_elements(any, any) :: :error | list
  def first_fibonacci_elements(n, head \\ []) do
    case {n, head} do
      {0, _} -> Enum.reverse(head)
      {_, []} -> first_fibonacci_elements(n - 1, [1])
      {_, [1]} -> first_fibonacci_elements(n - 1, [1, 1])
      {_, [head | tail]} -> first_fibonacci_elements(n - 1, [head + hd(tail) | [head | tail]])
      {_, _} -> :error
    end
  end

  @spec translate(map, String.t()) :: String.t()
  def translate(dict, sentence) do
    sentence |> Enum.map(&Map.get(dict, &1, &1)) |> Enum.join(" ")
  end

  @spec smallest_number(integer, integer, integer) :: integer
  def smallest_number(n1, n2, n3) do
    case Enum.sort([n1, n2, n3]) do
      [0, 0, 0] -> 0
      [0, 0, n3] -> "#{n3}00" |> String.to_integer()
      [0, n2, n3] -> "#{n2}0#{n3}" |> String.to_integer()
      [n1, n2, n3] -> [n1, n2, n3] |> Enum.join() |> String.to_integer()
    end
  end

  @spec rotate_left(list, integer) :: list
  def rotate_left(list, n) do
    case {list, n} do
      {[], _} -> []
      {_, 0} -> list
      {list, n} -> rotate_left(tl(list) ++ [hd(list)], n - 1)
    end
  end

  @spec right_angle_triangles(integer) :: list
  def right_angle_triangles(n \\ 20) do
    for a <- 1..n, b <- 1..n, c <- 1..n, a < b, b < c, a * a + b * b == c * c, do: {a, b, c}
  end

  @spec remove_consecutive_duplicates(list(integer)) :: list(integer)
  def remove_consecutive_duplicates(list) do
    case list do
      [] ->
        []

      [head | tail] ->
        [head | remove_consecutive_duplicates(tail |> Enum.drop_while(&(head == &1)))]
    end
  end

  @spec line_words(list(String.t())) :: list(String.t())
  def line_words(words) do
    lines = [
      "qwertyuiop",
      "asdfghjkl",
      "zxcvbnm"
    ]

    words
    |> Enum.filter(fn word ->
      lines
      |> Enum.any?(fn line ->
        word
        |> String.downcase()
        |> String.graphemes()
        |> Enum.filter(&(&1 != " "))
        |> Enum.all?(&String.contains?(line, &1))
      end)
    end)
  end

  @spec encode_caesar(String.t(), any) :: String.t()
  def encode_caesar(string, shift) do
    string
    |> String.to_charlist()
    |> Enum.map(fn codepoint ->
      cond do
        codepoint >= 65 and codepoint <= 90 -> rem(codepoint - 65 + shift, 26) + 65
        codepoint >= 97 and codepoint <= 122 -> rem(codepoint - 97 + shift, 26) + 97
        true -> codepoint
      end
    end)
    |> List.to_string()
  end

  @spec decode_caesar(String.t(), any) :: String.t()
  def decode_caesar(string, shift) do
    string |> encode_caesar(-shift)
  end

  @spec flatmap_combinations(list(list)) :: list(list)
  defp flatmap_combinations(list, acc \\ []) do
    case list do
      [] ->
        acc

      [head | tail] ->
        case acc do
          [] ->
            flatmap_combinations(tail, head |> Enum.map(fn element -> [element] end))

          _ ->
            flatmap_combinations(
              tail,
              head
              |> Enum.flat_map(fn head_element ->
                acc |> Enum.map(fn acc_list -> acc_list ++ [head_element] end)
              end)
            )
        end
    end
  end

  @spec letters_combinations(String.t()) :: list(String.t())
  def letters_combinations(string) do
    skip = fn keypad ->
      case keypad do
        x when x in 1..6 -> (x - 2) * 3
        7 -> 15
        8 -> 19
        9 -> 22
      end
    end

    take = fn keypad ->
      case keypad do
        x when x in 2..6 -> 3
        8 -> 3
        x when x in 7..9 -> 4
      end
    end

    keypads =
      string
      |> String.graphemes()
      |> Enum.map(&Integer.parse(&1))
      |> Enum.map(&elem(&1, 0))
      |> Enum.map(fn mobile_keypad ->
        "abcdefghijklmnopqrstuvwxyz"
        |> String.graphemes()
        |> Enum.drop(skip.(mobile_keypad))
        |> Enum.take(take.(mobile_keypad))
      end)

    flatmap_combinations(keypads) |> Enum.map(&Enum.join/1)
  end

  @spec group_anagrams(list(String.t())) :: list({String.t(), list(String.t())})
  def group_anagrams(words) do
    words
    |> Enum.group_by(fn word ->
      word
      |> String.downcase()
      |> String.graphemes()
      |> Enum.sort()
      |> Enum.join()
    end)
    |> Enum.map(fn {key, value} -> {key, value |> Enum.sort()} end)
    |> Enum.sort(fn {key1, _}, {key2, _} -> key1 < key2 end)
  end

  @spec common_prefix(list(String.t())) :: String.t()
  def common_prefix(list, matching_chars \\ 0) do
    case list do
      [] ->
        ""

      [head | _] ->
        checked_char = String.at(head, matching_chars)

        if checked_char != nil and
             Enum.all?(list, fn word -> String.at(word, matching_chars) == checked_char end),
           do: common_prefix(list, matching_chars + 1),
           else: String.slice(head, 0, matching_chars)
    end
  end

  @spec to_roman(non_neg_integer()) :: String.t()
  def to_roman(num, string_acc \\ "") do
    case num do
      0 ->
        string_acc

      _ ->
        cond do
          num >= 1000 -> to_roman(num - 1000, string_acc <> "M")
          num >= 900 -> to_roman(num - 900, string_acc <> "CM")
          num >= 500 -> to_roman(num - 500, string_acc <> "D")
          num >= 400 -> to_roman(num - 400, string_acc <> "CD")
          num >= 100 -> to_roman(num - 100, string_acc <> "C")
          num >= 90 -> to_roman(num - 90, string_acc <> "XC")
          num >= 50 -> to_roman(num - 50, string_acc <> "L")
          num >= 40 -> to_roman(num - 40, string_acc <> "XL")
          num >= 10 -> to_roman(num - 10, string_acc <> "X")
          num >= 9 -> to_roman(num - 9, string_acc <> "IX")
          num >= 5 -> to_roman(num - 5, string_acc <> "V")
          num >= 4 -> to_roman(num - 4, string_acc <> "IV")
          num >= 1 -> to_roman(num - 1, string_acc <> "I")
        end
    end
  end

  @spec factorize(integer, list(integer)) :: list(integer)
  def factorize(num, acc \\ []) do
    case num do
      1 ->
        acc

      _ ->
        factor = 2..num |> Enum.find(&(rem(num, &1) == 0))
        factorize(div(num, factor), acc ++ [factor])
    end
  end
end

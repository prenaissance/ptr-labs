defmodule AlgorithmsTest do
  use ExUnit.Case
  doctest Algorithms

  test "should determine if a number is prime" do
    assert Algorithms.prime?(12) == false
    assert Algorithms.prime?(13) == true
    assert Algorithms.prime?(193) == true
  end

  test "should calculate the area of a cylinder" do
    assert Algorithms.cylinder_area(1, 2) == 18.84955592153876
  end

  test "should reverse a list" do
    assert Algorithms.reverse([1, 2, 3]) == [3, 2, 1]
  end

  test "should calculate the sum of unique elements in a list" do
    assert Algorithms.unique_sum([1, 2, 3, 2, 1, 6, 9]) == 21
  end

  test "should get the first n fibonacci elements" do
    assert Algorithms.first_fibonacci_elements(5) == [1, 1, 2, 3, 5]
  end

  test "should translate a sentence given a dictionary" do
    dictionary = %{
      "mama" => "mother",
      "papa" => "father"
    }

    assert "mama is with papa" |> Algorithms.translate(dictionary) == "mother is with father"
  end

  test "should find the smallest number between 3 digits" do
    assert Algorithms.smallest_number(3, 2, 1) == 123
    assert Algorithms.smallest_number(0, 0, 0) == 0
    assert Algorithms.smallest_number(0, 0, 1) == 100
    assert Algorithms.smallest_number(0, 1, 4) == 104
  end

  test "should rotate a list to the left" do
    assert Algorithms.rotate_left([1, 2, 3, 4, 5], 2) == [3, 4, 5, 1, 2]
  end

  test "should remove consecutive duplicates from a list" do
    assert Algorithms.remove_consecutive_duplicates([1, 2, 2, 3, 3, 3, 4, 5, 5]) ==
             1..5 |> Enum.to_list()
  end

  test "should find words that can be written with a single keyboard line" do
    words = ["Hello", "Alaska", "Dad", "Peace"]
    assert Algorithms.line_words(words) == ["Alaska", "Dad"]
  end

  test "should encode caesar code" do
    assert Algorithms.encode_caesar("lorem", 3) == "oruhp"
  end

  test "should decode caesar code" do
    assert Algorithms.decode_caesar("oruhp", 3) == "lorem"
  end

  test "should find combinations of letters that are written on a dumb phone keyboard" do
    expected_combinations = [
      "ad",
      "ae",
      "af",
      "bd",
      "be",
      "bf",
      "cd",
      "ce",
      "cf"
    ]

    assert Algorithms.letters_combinations("23") |> Enum.sort() == expected_combinations
  end

  test "should group anagrams" do
    words = ["eat", "tea", "tan", "ate", "nat", "bat"]

    expected_list = [
      {"abt", ["bat"]},
      {"aet", ["ate", "eat", "tea"]},
      {"ant", ["nat", "tan"]}
    ]

    assert Algorithms.group_anagrams(words) == expected_list
  end

  test "should find the longest common prefix" do
    assert Algorithms.common_prefix(["flower", "flow", "flight"]) == "fl"
    assert Algorithms.common_prefix(["dog", "racecar", "car"]) == ""
  end

  test "should convert numbers to roman format" do
    assert Algorithms.to_roman(13) == "XIII"
    assert Algorithms.to_roman(1994) == "MCMXCIV"
  end

  test "should factorize numbers" do
    assert Algorithms.factorize(177_013) == [177_013]
    assert Algorithms.factorize(123_456_789) == [3, 3, 3607, 3803]
  end
end

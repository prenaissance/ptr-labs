defmodule StarwarsApiTest do
  use ExUnit.Case
  doctest StarwarsApi

  test "greets the world" do
    assert StarwarsApi.hello() == :world
  end
end

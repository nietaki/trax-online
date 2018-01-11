defmodule TraxWeb.GameIdTest do
  use ExUnit.Case

  import TraxWeb.GameId

  describe "generate" do
    test "returns a 21 char string" do
      game_id = generate()

      assert is_binary(game_id)
      assert String.length(game_id) == 21
    end
  end

  describe "is_valid" do
    test "succeeds on a generated id" do
      game_id = generate()
      assert {:ok, game_id} == validate(game_id)
    end

    test "succeeds on a 3 character id" do
      assert {:ok, "foo"} == validate("foo")
    end

    test "fails on an id containing invalid characters" do
      assert {:error, _} = validate("7*6")
      assert {:error, _} = validate("łóżko")
    end
  end
end

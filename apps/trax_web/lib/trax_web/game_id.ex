defmodule TraxWeb.GameId do

  @game_id_regex ~r/[a-zA-Z_~]{3,21}/

  def generate() do
    Nanoid.generate()
  end

  def validate(game_id) do
    case Regex.match?(@game_id_regex, game_id) do
      true -> {:ok, game_id}
      false -> {:error, :invalid_game_id}
    end
  end

end

defmodule Trax.Message do
  defstruct [
    :type,
    :data,
    :metadata,
  ]

  def parse(json_text) when is_binary(json_text) do
    with {:ok, parsed} <- Poison.decode(json_text),
         [type, data, metadata] <- parsed,
         true <- is_binary(type)
    do
      {:ok, %__MODULE__{
        type: type,
        data: data,
        metadata: metadata
      }}
    else
      _other ->
        {:error, :invalid_message}
    end
  end


  def encode(message = %__MODULE__{}) do
    Poison.encode([message.type, message.data, message.metadata])
  end
end

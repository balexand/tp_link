# FIXME move to Local module

defmodule TpLink.Message do
  def decode(binary) when is_binary(binary) do
    {decoded, _} =
      binary
      |> :binary.bin_to_list()
      |> Enum.map_reduce(0xAB, fn byte, key ->
        {Bitwise.bxor(byte, key), byte}
      end)

    decoded
    |> :binary.list_to_bin()
    |> Jason.decode!()
  end

  def encode(%{} = map) do
    {encoded, _acc} =
      map
      |> Jason.encode!()
      |> :binary.bin_to_list()
      |> Enum.map_reduce(0xAB, fn byte, key ->
        result = Bitwise.bxor(byte, key)
        {result, result}
      end)

    :binary.list_to_bin(encoded)
  end
end

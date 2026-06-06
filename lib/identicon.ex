defmodule Identicon do
  def main(input) do
    input
    |> hash_input # pass input to hash_input using pipe operator
  end

  def hash_input(input) do
    hex = :crypto.hash(:md5, input) # use Erlang module to convert string to md5 hash
    |> :binary.bin_to_list # convert binary to list

    %Identicon.Image{hex: hex} # creates a struct (a special map) of type Identicon.Image
  end
end

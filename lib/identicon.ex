defmodule Identicon do
  def main(input) do
    input
    |> hash_input # pass input to hash_input using pipe operator
    |> pick_color
  end

  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do # | _tail means I acknowledge there are remaining values, but I ignore them.
    %Identicon.Image{image | color: {r, g, b}}
  end

  # if pick_color module is a JS function
  # pick_color: function(image) {
  #   image.color = {
  #     r: image.hex[0],
  #     g: image.hex[1],
  #     b: image.hex[2]
  #   }

  #   return image
  # }

  def hash_input(input) do
    hex = :crypto.hash(:md5, input) # use Erlang module to convert string to md5 hash
    |> :binary.bin_to_list # convert binary to list

    %Identicon.Image{hex: hex} # creates a struct (a special map) of type Identicon.Image
  end
end

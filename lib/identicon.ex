defmodule Identicon do
  def main(input) do
    input
    |> hash_input # pass input to hash_input using pipe operator
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  def save_image(image, input) do
    File.write("#{input}.png", image)

  end

  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do # no need to use = image in this pattern matching as it will not be used
    image = :egd.create(250, 250) # Erlang module
    fill = :egd.color(color)

    Enum.each pixel_map, fn({start, stop, }) ->
      :egd.filledRectangle(image, start, stop, fill)
    end

    :egd.render(image)
  end

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map = Enum.map grid, fn({_code, index}) ->
      horizontal = rem(index, 5) * 50
      vertical = div(index, 5) * 50

      top_left = {horizontal, vertical}
      bottom_right = {horizontal + 50, vertical + 50}

      {top_left, bottom_right}
    end

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do # In JS, it is like const { hex, grid } = image;
    grid = Enum.filter grid, fn({code, _index}) ->
      rem(code, 2)
    end

    %Identicon.Image{image | grid: grid} # update only grid in the existing image struct. In JS, it is like const newImage = { ...image, grid: grid };
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid = hex
    |> Enum.chunk_every(3, 3, :discard) # chunk will create inner list
    |> Enum.map(&mirror_row/1)
    |> List.flatten
    |> Enum.with_index

    %Identicon.Image{image | grid: grid}
  end

  def mirror_row(row) do
    #[145, 46, 200]
    [first, second | _tail] = row

    #[145, 46, 200, 46, 145]
    row ++ [second, first] # ++ will join the list
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

defmodule GenReport.Parser do
  @months %{
    "1" => "janeiro",
    "2" => "fevereiro",
    "3" => "março",
    "4" => "abril",
    "5" => "maio",
    "6" => "junho",
    "7" => "julho",
    "8" => "agosto",
    "9" => "setembro",
    "10" => "outubro",
    "11" => "novembro",
    "12" => "dezembro"
  }

  def parse_file(filename) do
    filename
    |> File.stream!()
    |> Stream.map(fn line -> parse_line(line) end)
  end

  defp parse_line(line) do
    line
    |> String.trim()
    |> String.split(",")
    |> List.update_at(0, fn item -> String.downcase(item) end)
    |> List.update_at(3, fn item -> @months[item] end)
    |> List.update_at(1, fn item -> String.to_integer(item) end)
    |> List.update_at(2, fn item -> String.to_integer(item) end)
    |> List.update_at(4, fn item -> String.to_integer(item) end)
  end
end

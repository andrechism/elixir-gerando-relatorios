defmodule GenReport do
  alias GenReport.Parser

  @list_keys [
    "all_hours",
    "hours_per_month",
    "hours_per_year"
  ]

  def build(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.reduce(generate_acc(), &reduce_handler/2)
  end

  def build() do
    {:error, "Insira o nome de um arquivo"}
  end

  defp reduce_handler(
         [name, hours, _day, month, year],
         %{
           "all_hours" => all_hours,
           "hours_per_month" => hours_per_month,
           "hours_per_year" => hours_per_year
         }
       ) do
    all_hours = handle_all_hours(all_hours, name, hours)
    hours_per_month = handle_hours_per_month(hours_per_month, name, hours, month)
    hours_per_year = handle_hours_per_year(hours_per_year, name, hours, year)

    %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
  end

  defp handle_hours_per_year(hours_per_year, name, hours, year) do
    hours_per_year
    |> sum_per_year(name, hours, year)
  end

  defp sum_per_year(hours_per_year, name, hours, year) do
    if Map.has_key?(hours_per_year, name) do
      name_map = Map.get(hours_per_year, name)

      name_map =
        Map.put(
          name_map,
          year,
          if(name_map[year],
            do: Map.get(name_map, year) + hours,
            else: hours
          )
        )

      Map.put(hours_per_year, name, name_map)
    else
      hours_per_year = Map.put(hours_per_year, name, %{})
      name_map = Map.get(hours_per_year, name)

      name_map =
        Map.put(
          name_map,
          year,
          if(name_map[year],
            do: Map.get(name_map, year) + hours,
            else: hours
          )
        )

      Map.put(hours_per_year, name, name_map)
    end
  end

  defp handle_hours_per_month(hours_per_month, name, hours, month) do
    hours_per_month
    |> sum_per_month(name, hours, month)
  end

  defp sum_per_month(hours_per_month, name, hours, month) do
    if Map.has_key?(hours_per_month, name) do
      name_map = Map.get(hours_per_month, name)

      name_map =
        Map.put(
          name_map,
          month,
          if(name_map[month],
            do: name_map[month] + hours,
            else: hours
          )
        )

      Map.put(hours_per_month, name, name_map)
    else
      hours_per_month = Map.put(hours_per_month, name, %{})
      name_map = Map.get(hours_per_month, name)

      name_map =
        Map.put(
          name_map,
          month,
          if(Map.has_key?(name_map, month),
            do: Map.get(name_map, month) + hours,
            else: hours
          )
        )

      Map.put(hours_per_month, name, name_map)
    end
  end

  defp handle_all_hours(all_hours, name, hours) do
    all_hours
    |> Map.put(
      name,
      sum_hours(all_hours, name, hours)
    )
  end

  defp sum_hours(all_hours, name, hours) do
    if Map.has_key?(all_hours, name) do
      all_hours[name] + hours
    else
      hours
    end
  end

  defp generate_acc do
    Enum.into(@list_keys, %{}, &{&1, %{}})
  end
end

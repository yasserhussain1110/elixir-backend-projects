defmodule ApiTimestamp.TimestampController do
  use ApiTimestamp.Web, :controller

  def parse_natural(input) do
    with {:error, _} <- Timex.parse(input, "{Mfull} {D}, {YYYY}"),
         {:error, _} <- Timex.parse(input, "{Mfull} {D} {YYYY}") do
      {:error, "Failed to parse date"}
    else
      {:ok, date_time} -> {:ok, date_time}
    end
  end

  def parse_unix(input) do
    Timex.parse(input, "{s-epoch}")
  end

  def parse(input) do
    case parse_unix(input) do
      {:ok, date_time} -> {:ok, date_time}
      {:error, _} -> parse_natural(input)
    end
  end

  def get_date_time_map({:ok, date_time}) do
    %{
      unix: Timex.to_unix(date_time),
      natural: Timex.format!(date_time, "{Mfull} {0D}, {YYYY}")
    }
  end

  def get_date_time_map({:error, _}) do
    %{unix: nil, natural: nil}
  end

  def get_time_stamp(conn, %{"input" => [input]}) do
    json conn, input |> parse |> get_date_time_map
  end
end

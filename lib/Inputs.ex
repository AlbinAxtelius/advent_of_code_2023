defmodule AdventOfCode.Input do
  @cache_path "~/.cache/advent_of_code"

  @spec get(non_neg_integer()) :: {:ok, String.t()} | {:error, String.t()}
  def get(day) when day > 25 or day < 1, do: {:error, "Invalid day: #{day}"}

  def get(day) do
    cond do
      in_cache?(day) -> get_cache(day)
      has_session_cookie?() -> download(day)
      true -> {:error, "wrong"}
    end
  end

  @spec filepath(non_neg_integer()) :: String.t()
  defp filepath(day), do: Path.join([@cache_path, "day#{day}"]) |> Path.expand()

  @spec in_cache?(non_neg_integer()) :: boolean()
  defp in_cache?(day), do: File.exists?(filepath(day))

  @spec get_cache(non_neg_integer()) :: {:ok, String.t()} | {:error, String.t()}
  defp get_cache(day) do
    case File.read(filepath(day)) do
      {:ok, contents} -> {:ok, contents}
      {:error, reason} -> {:error, reason}
    end
  end

  @spec has_session_cookie?() :: boolean()
  defp has_session_cookie?(), do: session_cookie() != nil

  defp download(day) do
    case HTTPoison.get("https://adventofcode.com/2022/day/#{day}/input", headers()) do
      {:ok, %{status_code: 200} = response} -> save_to_cache(day, response.body)
      {:error, reason} -> {:error, reason}
    end
  end

  defp save_to_cache(day, contents) do
    path = day |> filepath() |> Path.dirname()

    File.mkdir_p(path)
    File.write(filepath(day), contents)

    {:ok, contents}
  end

  defp config, do: Application.get_env(:advent_of_code, __MODULE__)
  defp session_cookie, do: Keyword.get(config(), :session_cookie, nil)

  defp headers, do: [{"cookie", "session=#{session_cookie()}"}]
end

import Config

try do
  import_config "secrets.exs"
rescue
  _ -> :ok
end

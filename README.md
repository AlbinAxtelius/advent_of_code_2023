# Advent of code 2023

## Configuration

### Configure session cookie

Create a file named `config/secrets.exs` in the root of the project and paste your session cookie in it.

```elixir

import Config

config :advent_of_code, AdventOfCode.Input, session_cookie: "..."

```

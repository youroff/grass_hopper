# GrassHopper

GrassHopper is a tiny abstraction over GenServer, that helps building
dynamically scheduled recursive processes. It allows to efficiently jump
along timestamps and perform user defined actions. Think of a librarian
going through the list of borrowed books and calling the borrowers
as their leases reach the due date.

User of GrassHopper needs to implement two callbacks:

- `next` is called to compute the next timestamp (NaiveDateTime) or nil which will cause
  the process to wait indefinitely or max_timeout
- `perform`: called to perform the operation on a given interval

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `grass_hopper` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:grass_hopper, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/grass_hopper>.


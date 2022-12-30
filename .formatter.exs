[
  import_deps: [:ecto, :phoenix],
  inputs: ["*.{ex,exs,heex}", "{config,lib,test}/**/*.{ex,exs,heex}", "priv/*/seeds.exs"],
  plugins: [Phoenix.LiveView.HTMLFormatter],
  subdirectories: ["priv/*/migrations"]
]

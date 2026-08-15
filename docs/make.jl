using Documenter
using AtomicAndPhysicalConstants

makedocs(
    sitename = "AtomicAndPhysicalConstants.jl",
    authors  = "David Sagan and contributors",
    modules  = [AtomicAndPhysicalConstants],
    format   = Documenter.HTML(
        prettyurls       = get(ENV, "CI", nothing) == "true",
        canonical        = "https://bmad-sim.github.io/AtomicAndPhysicalConstants.jl",
        assets           = String[],
    ),
    pages = [
        "Home"               => "index.md",
        "Species"            => "species.md",
        "Constants"          => "constants.md",
        "CODATA Releases"    => "codata.md",
        "API Reference"      => "api.md",
    ],
    checkdocs = :exports,   # warn on exported symbols without docstrings
    doctest   = true,
)

deploydocs(
    repo   = "github.com/bmad-sim/AtomicAndPhysicalConstants.jl",
    target = "build",
    branch = "gh-pages",
    devbranch = "main",
    push_preview = true,   # deploy PR builds to previews/PR##
    # Documenter redirects the site root to the first entry of `versions`, so
    # putting "dev" first makes the landing page show the docs built from main.
    # Doc fixes are then live on merge instead of waiting for the next release.
    # The released versions stay available under stable/ and v#.# as usual.
    versions = ["dev" => "dev", "stable" => "v^", "v#.#"],
)

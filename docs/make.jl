using Documenter
using AtomicAndPhysicalConstants

makedocs(
    sitename = "AtomicAndPhysicalConstants.jl",
    authors  = "David Sagan and contributors",
    modules  = [AtomicAndPhysicalConstants],
    format   = Documenter.HTML(
        prettyurls       = get(ENV, "CI", nothing) == "true",
        canonical        = "https://rot4te.github.io/AtomicAndPhysicalConstants.jl",
        assets           = String[],
    ),
    pages = [
        "Home"               => "index.md",
        "Manual" => [
            "Species"        => "man/species.md",
            "Constants"      => "man/constants.md",
            "CODATA Releases"=> "man/codata.md",
        ],
        "API Reference"      => "api.md",
    ],
    checkdocs = :exports,   # warn on exported symbols without docstrings
    doctest   = true,
)

deploydocs(
    repo   = "github.com/rot4te/AtomicAndPhysicalConstants.jl",
    target = "build",
    branch = "gh-pages",
    devbranch = "main",
)

using StarTIN
using Documenter

makedocs(;
    modules=[StarTIN],
    authors="Maarten Pronk <git@evetion.nl> and contributors",
    repo="https://github.com/evetion/StarTIN.jl/blob/{commit}{path}#L{line}",
    sitename="StarTIN.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://evetion.github.io/StarTIN.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/evetion/StarTIN.jl",
)

using startinj
using Documenter

makedocs(;
    modules=[startinj],
    authors="Maarten Pronk <git@evetion.nl> and contributors",
    repo="https://github.com/evetion/startinj.jl/blob/{commit}{path}#L{line}",
    sitename="startinj.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://evetion.github.io/startinj.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/evetion/startinj.jl",
)

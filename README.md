# StarTIN

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://evetion.github.io/StarTIN.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://evetion.github.io/StarTIN.jl/dev)
[![Build Status](https://github.com/evetion/StarTIN.jl/workflows/CI/badge.svg)](https://github.com/evetion/StarTIN.jl/actions)

A Julia wrapper around the Delaunay triangulator [startin](https://github.com/hugoledoux/startin) written in Rust by [Hugo Ledoux](https://3d.bk.tudelft.nl/hledoux).

# Install
```julia
]add StarTIN
```

# Usage
```julia
using StarTIN

t = DT()
points = rand(3,100)
insert!(t, points)

value = interpolate_linear(t, 0.5, 0.5)

write!("test.obj", t)
```

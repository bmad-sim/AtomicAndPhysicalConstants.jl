# AtomicAndPhysicalConstants.jl
[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://bmad-sim.github.io/AtomicAndPhysicalConstants.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://bmad-sim.github.io/AtomicAndPhysicalConstants.jl/dev/)
[![Build Status](https://github.com/bmad-sim/AtomicAndPhysicalConstants.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/bmad-sim/AtomicAndPhysicalConstants.jl/actions/workflows/CI.yml?query=branch%3Amain)

## Setup

To install and use AtomicAndPhysicalConstants, execute the commands:
```julia-repl
julia> using Pkg; Pkg.add("AtomicAndPhysicalConstants.jl")
julia> using AtomicAndPhysicalConstants
```

## Introduction

`AtomicAndPhysicalConstants.jl` (APC) provides a convenient, fast, and lightweight API to access information about different species and physical constants optimized for faster compile time and simulations.

It is designed to provide atomic and physical constants including:
1. fundamental constants (_e.g._ speed of light, Planck's constant, etc.), 
2. subatomic particle properties (_e.g._ rest mass, charge, magnetic moment, etc.), 
3. and atomic isotope properties (_e.g._ mass of any isotope with arbitrary charge states, etc.) 

Values are obtained from CODATA (Committee on Data of the International Science Council), NIST (National Institute of Standards and Technology), and PDG (Particle Data Group). 
This package enables users to access CODATA releases from 2002, 2006, 2010, 2014, 2018, and 2022. New releases will be added as they become available.
Each set of constants is stored in an object called "CODATAYYYY" (where YYYY is the release year). In these objects the constants have values in the units provided by NIST.
Constants from the preferred release (most recent by default) are used to define all objects from the package, and they have the following units:
1. length - _m_
2. energy - _eV_
3. mass - _eV/c^2_
4. action - _eV*s_
5. charge - _e_
6. magnetic moment - _eV/T_
7. electric permittivity - _F/m_
8. magnetic permeability - _N/A^2_


## Documentation

The API reference may be obtained at 
[https://bmad-sim.github.io/AtomicAndPhysicalConstants.jl](https://bmad-sim.github.io/AtomicAndPhysicalConstants.jl)


## Defining Species

The immutable `Species` struct is the fundamental object provided by this package. It contains the following information about the stored particle type:
1. The name (or atomic symbol) of the particle,
2. the charge on the particle in units of _e_,
3. the mass of the particle in _eV/c^2_,
4. the spin of the particle in units of Planck's reduced constant,
5. the gyromagnetic factor for subatomic particles,
6. the magnetic moment of subatomic particles in _eV/T_,
7. the mass number for atomic isotopes,
8. and the type of particle (_e.g._ Hadron, Boson, Lepton, etc.)

The `Species()` constructor is a fast and stable way to create a species object from input text.
The following snippet shows examples of creating an object with the properties of an electron, and another with the properties of tritium.

```julia-repl
julia> e = Species("electron")
Species("electron", -1, 510998.95069, 0.5, -2.00231930436092, -5.795094307320036e-5, 0, AtomicAndPhysicalConstants.Kind.LEPTON)

julia> tritium = Species("3H")
Species("H", 0, 2.8094321188928137e9, 1.5, 0.0, 0.0, 3, AtomicAndPhysicalConstants.Kind.ATOM)
```

For stability, it is not possible to use the standard 'dot' syntax to access the fields of a Species object.
To do so, use one of the functions designed for this purpose. An example of each is shown below.

```julia-repl
julia> nameof(e)
"electron"
julia> chargeof(tritium)
0
julia> massof(e)
510998.95069
julia> spinof(e)
0.5
julia> gspin_of(e)
-2.00231930436092
julia> momentof(e)
-5.795094307320036e-5
julia> iso_of(tritium)
3
```

See more about `Species()` constructors and field access functions [here](https://bmad-sim.github.io/AtomicAndPhysicalConstants.jl/stable/species/)

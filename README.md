# AtomicAndPhysicalConstants.jl
[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://bmad-sim.github.io/AtomicAndPhysicalConstants.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://bmad-sim.github.io/AtomicAndPhysicalConstants.jl/dev/)
[![Build Status](https://github.com/bmad-sim/AtomicAndPhysicalConstants.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/bmad-sim/AtomicAndPhysicalConstants.jl/actions/workflows/CI.yml?query=branch%3Amain)



`AtomicAndPhysicalConstants.jl` (APC) provides a quick way to access information about different species and physical constants optimized for faster compile time and simulations.

It is designed to provide atomic and physical constants including things like the speed of light, subatomic particle properties, atomic isotope properties, etc. 

Values are obtained from CODATA (Committee on Data of the International Science Council), NIST (National Institute of Standards and Technology), and PDG (Particle Data Group). This package enables users to access and customize units for the constants. 

The package is compatible with Julia's `Unitful.jl` library for convenient unit manipulation. 

`AtomicAndPhysicalConstants.jl` has the following main features and advantages:

1. **Simple Unit Manipulation**: Users can define the units they want to use in a simple and consistent way. `Unitful.jl` provides a simple way to do unit conversion and calculations.
2. **Rigorous and Up-to-Date Data**: We uses the most updated values from creditable sources. We also provided the option to use past data for specific purposes.
3. **Simple usage**: Users can access data of a wide range of particles and physic constants by simply defining a species with their name or call a variable in the namespace. 

## Documentation

Documentation is at 
[https://bmad-sim.github.io/AtomicAndPhysicalConstants.jl/dev](https://bmad-sim.github.io/AtomicAndPhysicalConstants.jl/dev)

## Setup

To use AtomicAndPhysicalConstants, like any Julia package, execute the commands:
```julia
julia> using Pkg; Pkg.add("AtomicAndPhysicalConstants.jl")
julia> using AtomicAndPhysicalConstants
```
The top level package, 'AtomicAndPhysicalConstants', gives access to one function, 'CODATA_releases()', and (presently) six submodules 'CODATAyyyy' where 'yyyy' stands in for a release year.
'CODATA_releases' indicates which years are available (to replace 'yyyy' in the submodule name), and each of the submodules contains all functionality for the package imposed on a particular set of constants.

The macro `@APCdef` initializes the APC package.
@APCdef sets the units for physical constants, species mass and charge. It defines the physical constants and getter functions for species mass and charge with the proper unit and data. Documentation is  [here](https://bmad-sim.github.io/AtomicAndPhysicalConstants.jl/dev/units/).

```julia
julia> @APCdef
julia> APC.C_LIGHT
2.99792458e8
```

Users have the options for choosing the type and unit of the constants, see [this page](https://bmad-sim.github.io/AtomicAndPhysicalConstants.jl/dev/units/)

## Defining Species

The constructor `Species()` helps you create a structure with all the information of the species stored in it.

```julia
julia> e = Species("electron")
julia> hydrogen = Species("H")
```

You could use getter functions to access its properties or directly calling its fields. 

```julia
julia> massof(e)
510998.95069
julia> hydrogen.spin
1.0 h_bar
```

See more about `Species()` constructors and getter functions [here](https://bmad-sim.github.io/AtomicAndPhysicalConstants.jl/dev/species/)
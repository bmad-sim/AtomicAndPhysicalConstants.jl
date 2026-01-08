# AtomicAndPhysicalConstants.jl

## Installation

To use AtomicAndPhysicalConstants, install it like any Julia package:
```julia
julia> using Pkg
julia> Pkg.add("AtomicAndPhysicalConstants.jl")
```

## Quick Start

```julia
using AtomicAndPhysicalConstants

# Access physical constants directly
C_LIGHT          # 2.99792458e8 [m/s]
H_PLANCK         # 6.62607015e-34 [J⋅s]
M_ELECTRON       # 510998.95069 [eV/c²]
FINE_STRUCTURE   # 0.0072973525643

# Create species objects
e = Species("electron")
p = Species("proton")
h = Species("H")
h_ion = Species("H+")
anti_p = Species("anti-proton")

# Access species properties using helper functions (recommended)
massof(e)        # 510998.95069 [eV/c²]
chargeof(p)      # 1.0 [e]
kindof(e)        # LEPTON
g_spin(e)        # g-factor (dimensionless)
```

## Introduction

`AtomicAndPhysicalConstants.jl` provides a simple and efficient way to access physical constants and particle properties optimized for fast compile times and simulations.

The package provides:
- Fundamental physical constants (speed of light, Planck constant, etc.)
- Subatomic particle properties (electrons, protons, muons, pions, etc.)
- Atomic and isotope data for all elements
- Support for ions and antiparticles

All values are sourced from **CODATA 2022**.

## Documentation

Full documentation is available at
[https://bmad-sim.github.io/AtomicAndPhysicalConstants.jl](https://bmad-sim.github.io/AtomicAndPhysicalConstants.jl)

## Working with Species

`Species` is a structure that holds information about a particle or atom, including mass, charge, spin, magnetic moment, and g-factor.

### Creating Species

```julia
using AtomicAndPhysicalConstants

# Subatomic particles
electron = Species("electron")
proton = Species("proton")
muon = Species("muon")

# Atomic species
hydrogen = Species("H")
carbon12 = Species("12C")
carbon_ion = Species("C+3")

# Antiparticles
anti_proton = Species("anti-proton")
```

### Accessing Properties

The recommended way to access species properties is through helper functions:

```julia
e = Species("electron")

# Using helper functions (recommended)
massof(e)              # 510998.95069 [eV/c²]
chargeof(e)            # -1.0 [e]
kindof(e)              # LEPTON
atomicnumberof(e)      # Mass number
g_spin(e)              # g-factor (dimensionless)
gyromagnetic_anomaly(e) # (g-2)/2
isnullspecies(e)       # false
```

Alternatively, properties can be accessed directly as fields:

```julia
e.mass           # 510998.95069 [eV/c²]
e.charge         # -1.0 [e]
e.spin           # 0.5 [ħ]
e.moment         # Magnetic moment [J/T]
e.g_factor       # g-factor (dimensionless)
e.kind           # LEPTON
e.name           # "electron"
```

See the [Species](https://bmad-sim.github.io/AtomicAndPhysicalConstants.jl/stable/species/) page for more details on supported species and naming conventions.

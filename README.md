# AtomicAndPhysicalConstants.jl

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://bmad-sim.github.io/AtomicAndPhysicalConstants.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://bmad-sim.github.io/AtomicAndPhysicalConstants.jl/dev/)
[![Build Status](https://github.com/bmad-sim/AtomicAndPhysicalConstants.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/bmad-sim/AtomicAndPhysicalConstants.jl/actions/workflows/CI.yml?query=branch%3Amain)


## Installation

```julia-repl
julia> using Pkg
julia> Pkg.add("AtomicAndPhysicalConstants.jl")
```

## Quick Start

```julia-repl
julia> using AtomicAndPhysicalConstants

julia> # Access physical constants directly

julia> C_LIGHT # in [m/s]      
2.99792458e8

julia> H_PLANCK # in [eV⋅s]
4.135667696e-15

julia> M_ELECTRON # in [eV/c²]   
510998.95069 

julia> FINE_STRUCTURE # unitless
0.0072973525643

julia> # Create species objects

julia> e = Species("electron") # print the output on this for example
Species("electron", -1, 510998.95069, 0.5, -2.00231930436092, -5.795094307320036e-5, 0, AtomicAndPhysicalConstants.Kind.LEPTON)

julia> p = Species("proton"); # suppress the output for the rest of the definitions

julia> h = Species("H"); # a neutral hydrogen atom

julia> he = Species("3He"); # a neutral helium atom

julia> h_ion = Species("H+"); # a hydrogen atom with one less electron than usual

julia> anti_p = Species("anti-proton"); 

julia> # retrieve Species qualities with access functions

julia> nameof(anti_p)
"anti-proton"

julia> chargeof(p) # charge of the particle in [e]
1

julia> massof(e) # retrieve the mass of a particle in [eV/c²]
510998.95069

julia> massof(h, AMU=true) # or grab the mass of an atom in AMU (also called Daltons)
1.0079407540557772

julia> spinof(e) # spin projection of the particle in [ħ]
0.5

julia> gspin_of(e) # spin g-factor (dimensionless)
2.00231930436092


julia> gyromagnetic_anomaly(e)
0.0011596521804599913

julia> momentof(p) # magnetic dipole moment in [eV/T] - errors for atoms
8.804315113647238e-8

julia> iso_of(he) # mass number of the specified atom - errors for non-atoms
3

```

## Supported Particle Species

### Subatomic Particles

The following list of strings may be used as arguments to the `Species()` function.

- `"electron"`, `"positron"`
- `"proton", `"anti-proton"`
- `"neutron"`, `"anti-neutron"`
- `"muon"`, `"anti-muon"`
- `"pion0"`, `"pion+"`, `"pion-"`
- `"deuteron"`, `"anti-deuteron"`
- `"photon"`


### Atomic Species

Atomic numbers from 1 (`"H"`) to 118 (`"Og"`) are available with the `Species()` function.

#### Mass Number Formatting

To access different isotopes of a particular atomic element, two different syntax option are available:

```julia-repl
julia> he = Species("#5He"); he5 = Species("5He");

julia>  massof(he5, AMU=true)
5.012057

julia> he == he5
true
```

#### Charge State Specification

Charge state may be specified for atoms.
Positive charges with magnitude less than 4_e_ may be given with repeated plus symbols, _e.g._
```julia-repl
julia> chargeof(Species("Li+++"))
3
```
Similarly, negative charges with magnitude less than 4_e_ may be given with repeated plus symbols, _e.g._
```julia-repl
julia> chargeof(Species("K---"))
-3
```
A single positive or negative sign followed by and integer may be used the same way, _e.g._
```julia-repl
julia> Species("Li+++") == Species("Li+3")
true

julia> Species("K---") == Species("K-3")
true
```

## Directly Exported Constants

### Masses with units [eV/c²]
- `M_ELECTRON`
- `M_PROTON`
- `M_NEUTRON`
- `M_MUON`
- `M_DEUTERON`
- `M_HELION`
- `M_PION_0`
- `M_PION_CHARGED`

Both Pion masses are obtained from PDG, rather than CODATA.

### Magnetic dipole moments with units [eV/T]
- `MU_ELECTRON`
- `MU_PROTON`
- `MU_NEUTRON`
- `MU_MUON`
- `MU_DEUTERON`
- `MU_HELION`
- `MU_TRION`

### Dimensionless constants

- `AVOGADRO`
- `FINE_STRUCTURE`

#### Spin G-factors
- `G_ELECTRON`
- `G_PROTON`
- `G_NEUTRON`
- `G_MUON`
- `G_DEUTERON`
- `G_HELION`
  - This constant is not available from CODATA releases prior to 2010
- `G_TRITON`

#### Gyromagnetic Anomalies
- `ANOMALY_ELECTRON`
  - This constant is not available from CODATA releases prior to 2010
- `ANOMALY_MUON`
  - This constant is not available from CODATA releases prior to 2010


### Other Physical Constants
- `E_CHARGE` - charge on the electron in [C]
- `R_ELECTRON` : classical electron radius in [m]
- `R_PROTON`: classical proton radius in [m]
- `C_LIGHT`: speed of light in [m/s]
- `H_PLANCK`: Planck's constant in [eV⋅s]
- `H_BAR`: Planck's reduced constant in [eV⋅s]
- `CLASSICAL_RADIUS_FACTOR` 
- `EPS_0`: Permittivity of free space in [F/m]
- `MU_0`: Vacuum Permeability in [N/A^2]


### Conversion Constants
- `KG_PER_AMU`:
- `EV_PER_AMU`
- `J_PER_EV`
- `G_PER_EV`
- `KG_PER_MEV_C2`
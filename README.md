<<<<<<< HEAD
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

julia> he = Species("3He"); # a neutral helium atom with mass number 3

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
=======
# APClite.jl

A lightweight version of AtomicAndPhysicalConstants.jl that provides atomic and physical constants as plain Float64 values in fixed units.

## Features

- **Latest CODATA 2022 data**: All physical constants from the most recent CODATA release
- **No dependencies**: Pure Julia with no external dependencies
- **Fast compilation**: Simple static constants for optimal performance
- **Simple API**: Easy-to-use Species struct with direct field access
- **Comprehensive coverage**: Subatomic particles, atoms, ions, and isotopes

## Comparison with AtomicAndPhysicalConstants.jl

| Feature | APClite | AtomicAndPhysicalConstants |
|---------|---------|----------------------------|
| Dependencies | None | Unitful, DynamicQuantities, etc. |
| Performance | Fast | Slower |
| Units | Plain Float64 | Unitful quantities |
| Data sources | CODATA 2022 only | Multiple years available |
| API | Direct field access | Macro-based API |

## Installation
>>>>>>> 6ad1211 (APClite)

```julia
julia> using Pkg
julia> Pkg.add(url="https://github.com/ndwang/APClite")
```

<<<<<<< HEAD
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
=======
## Quick Start

```julia
using APClite

# Access physical constants directly
C_LIGHT          # 2.99792458e8 [m/s]
H_PLANCK         # 6.62607015e-34 [J⋅s]
M_ELECTRON       # 0.51099895069 [MeV/c²]
FINE_STRUCTURE   # 0.0072973525643

# Create species objects
e = Species("electron")
p = Species("proton")
h = Species("H")
h_ion = Species("H+")
anti_p = Species("anti-proton")

# Access species properties (direct fields)
e.mass           # 0.51099895069 [MeV/c²]
p.charge         # 1.0 [e]
e.spin           # 0.5 [ħ]
e.g_factor       # g-factor (dimensionless)
```

## Supported Species

### Subatomic Particles
- `"electron"`, `"positron"`
- `"proton"`, `"anti-proton"`
- `"neutron"`, `"anti-neutron"`
- `"muon"`, `"anti-muon"`
- `"pion0"`, `"pion+"`, `"pion-"`
- `"deuteron"`, `"anti-deuteron"`
- `"photon"`

### Atomic Species
- Supported elements: `"H"`, `"He"`, `"Li"`, `"Be"`, `"B"`, `"C"`, `"N"`, `"O"`, `"F"`, `"Ne"`, `"Na"`, `"Mg"`, `"Al"`, `"Si"`, `"P"`, `"S"`, `"Cl"`, `"Ar"`, `"K"`, `"Ca"`, `"Fe"`, `"Cu"`, `"Zn"`, `"U"`
- Ions: `"H+"`, `"He++"`, `"C+"`, `"O-"`, etc.
- Isotopes: `"H1"`, `"C12"`, `"U235"`, etc.

## API Reference

### Constants
All constants are available as module-level constants, grouped by type:

- Fundamental constants
  - `C_LIGHT`: Speed of light [m/s]
  - `H_PLANCK`: Planck constant [J⋅s]
  - `H_BAR`: Reduced Planck constant [J⋅s]
  - `E_CHARGE`: Elementary charge [C]
  - `FINE_STRUCTURE`: Fine structure constant (dimensionless)
  - `AVOGADRO`: Avogadro constant [mol⁻¹]
  - `R_ELECTRON`: Classical electron radius [m]
  - `R_PROTON`: Classical proton radius [m]
  - `EPS_0`: Permittivity of free space [F/m]
  - `MU_0`: Permeability of free space [N/A²]

- Particle masses [MeV/c²]
  - `M_ELECTRON`: Electron
  - `M_PROTON`: Proton
  - `M_NEUTRON`: Neutron
  - `M_MUON`: Muon
  - `M_PION_0`: Neutral pion
  - `M_PION_CHARGED`: Charged pion
  - `M_DEUTERON`: Deuteron
  - `M_HELION`: Helion (³He nucleus)

- Magnetic moments [J/T]
  - `MU_ELECTRON`: Electron
  - `MU_PROTON`: Proton
  - `MU_NEUTRON`: Neutron
  - `MU_MUON`: Muon
  - `MU_DEUTERON`: Deuteron
  - `MU_HELION`: Helion
  - `MU_TRITON`: Triton

- g-factors (dimensionless)
  - `G_ELECTRON`: Electron
  - `G_PROTON`: Proton
  - `G_NEUTRON`: Neutron
  - `G_MUON`: Muon
  - `G_DEUTERON`: Deuteron
  - `G_HELION`: Helion
  - `G_TRITON`: Triton

- Magnetic moment anomalies (dimensionless)
  - `ANOMALY_ELECTRON`: Electron
  - `ANOMALY_MUON`: Muon

- Unit conversions
  - `KG_PER_AMU`: Kilograms per atomic mass unit [kg/amu]
  - `EV_PER_AMU`: Electronvolts per atomic mass unit [eV/amu]
  - `J_PER_EV`: Joules per electronvolt [J/eV]
  - `C_PER_E`: Coulombs per elementary charge [C/e]

- Release info
  - `RELEASE_YEAR`: Data release year

### Species
- `Species(name::String)`: Create a species from name
- Access fields directly:
  - `species.mass` (MeV/c²)
  - `species.charge` (units of e)
  - `species.spin` (ħ)
  - `species.moment` (J/T)
  - `species.g_factor` (dimensionless)
  - `species.iso` (mass number)
  - `species.kind` (ATOM, HADRON, LEPTON, PHOTON, NULL)
  - `species.name` or `nameof(species)` for isotope and charge information

## Examples

```julia
using APClite

# Physical constants
println("Speed of light: ", C_LIGHT, " m/s")
println("Electron mass: ", M_ELECTRON, " MeV/c²")

# Create particles
electron = Species("electron")
proton = Species("proton")
hydrogen = Species("H")
carbon12 = Species("C12")

# Access properties
println("Electron charge: ", electron.charge, " e")
println("Proton mass: ", proton.mass, " MeV/c²")
println("Hydrogen mass: ", hydrogen.mass, " MeV/c²")

# Display species
println(electron)
println(proton)
```

### Custom species

```julia
using APClite

# 1) Direct construction (no registry entry needed)
#    name, charge [e], mass [MeV/c^2], spin [ħ], moment [J/T], g_factor, iso, kind
custom = Species("my-hadron", 1.0, 2500.0, 0.5, 0.0, 2.0, 0.0, HADRON)
println(custom)

# 2) Register a custom subatomic species for name-based construction
APClite.SUBATOMIC_SPECIES["X-"] = (
    charge=-1.0,
    mass=1000.0,
    spin=0.5,
    moment=0.0,
    kind=HADRON,
)
xminus = Species("X-")
println(xminus)

# 3) Register a custom atomic element (with isotopes) for name/ion/isotope parsing
APClite.ATOMIC_SPECIES["Xe"] = (
    Z=54,
    isotopes=Dict(129 => 120000.0, 132 => 122000.0, -1 => 121000.0),
)
xe129pp = Species("Xe129++")
println(xe129pp)
```
>>>>>>> 6ad1211 (APClite)

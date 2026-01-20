# For Developers: Package Architecture

## Overview

AtomicAndPhysicalConstants.jl provides simple, direct access to physical constants and particle properties without requiring initialization macros or complex configuration.

## Species Type

The `Species` type is the core data structure that holds information about particles and atoms.

### Species Structure

A `Species` object contains the following fields:

- `name::String` - Name of the particle
- `charge::Float64` - Charge in elementary charges [e]
- `mass::Float64` - Mass in [eV/c²]
- `spin::Float64` - Spin in [ħ]
- `moment::Float64` - Magnetic moment in [J/T]
- `g_factor::Float64` - g-factor (dimensionless)
- `iso::Float64` - Mass number for isotopes (0.0 for subatomic particles)
- `kind::Kind` - Species classification (ATOM, HADRON, LEPTON, PHOTON, NULL)

### Example

```julia
e = Species("electron")
# Accesses:
# name = "electron"
# charge = -1.0
# mass = 510998.95069
# spin = 0.5
# moment = -928.4764620e-26
# g_factor = -2.00231930436256
# iso = 0.0
# kind = LEPTON
```

## Species Registry

Species data is stored in two main registries:

### 1. Subatomic Species Registry

The `SUBATOMIC_SPECIES` dictionary maps particle names to their properties:

```julia
SUBATOMIC_SPECIES = Dict(
    "electron" => (
        charge=-1.0,
        mass=510998.95069,
        spin=0.5,
        moment=-928.4764620e-26,
        kind=LEPTON,
    ),
    "proton" => (
        charge=1.0,
        mass=938272088.16,
        spin=0.5,
        moment=1.41060679736e-26,
        kind=HADRON,
    ),
    # ... more particles
)
```

### 2. Atomic Species Registry

The `ATOMIC_SPECIES` dictionary maps element symbols to atomic data:

```julia
ATOMIC_SPECIES = Dict(
    "H" => (
        Z=1,  # Atomic number
        isotopes=Dict(
            1 => 1007825.0322,   # Hydrogen-1 mass
            2 => 2014101.778,    # Deuterium mass
            3 => 3016049.2779,   # Tritium mass
            -1 => 1007940.0,     # Natural abundance average
        ),
    ),
    # ... more elements
)
```

The key `-1` in the isotopes dictionary represents the natural abundance average mass.

## Species Constructor Logic

The `Species(name::String)` constructor follows this parsing order:

1. **Check for Null Species**: If name is "Null" or empty, create a NULL species
2. **Check for Antiparticles**: If name starts with "anti-", set antimatter flag
3. **Check Subatomic Registry**: Look up in `SUBATOMIC_SPECIES` dictionary
4. **Parse Atomic Species**:
   - Extract mass number prefix (e.g., "12" in "12C")
   - Extract element symbol (e.g., "C")
   - Extract charge suffix (e.g., "+3" in "C+3")
   - Look up in `ATOMIC_SPECIES` dictionary
   - Calculate properties based on isotope mass and ionization

### Parsing Examples

- `"electron"` → Direct lookup in subatomic registry
- `"12C"` → Mass number: 12, Element: C, Charge: 0
- `"12C+3"` → Mass number: 12, Element: C, Charge: +3
- `"C+3"` → Mass number: -1 (natural), Element: C, Charge: +3
- `"anti-proton"` → Antimatter flag set, lookup "proton", negate charge

## Constants

Physical constants are defined as module-level constants:

```julia
# Fundamental constants
const C_LIGHT = 2.99792458e8          # [m/s]
const H_PLANCK = 6.62607015e-34       # [J⋅s]
const H_BAR = 1.054571817e-34         # [J⋅s]
const E_CHARGE = 1.602176634e-19      # [C]
const FINE_STRUCTURE = 0.0072973525643

# Particle masses [eV/c²]
const M_ELECTRON = 510998.95069
const M_PROTON = 938272088.16
const M_NEUTRON = 939565420.52

# ... more constants
```

These are available immediately after `using AtomicAndPhysicalConstants`.

## Adding Custom Species

### Method 1: Direct Construction

Create a species by providing all parameters:

```julia
custom = Species(
    "my-particle",  # name
    1.0,            # charge [e]
    2.5e9,          # mass [eV/c²]
    0.5,            # spin [ħ]
    0.0,            # moment [J/T]
    2.0,            # g_factor
    0.0,            # iso
    HADRON          # kind
)
```

### Method 2: Register Custom Subatomic Species

Add to the registry for name-based construction:

```julia
AtomicAndPhysicalConstants.SUBATOMIC_SPECIES["X-"] = (
    charge=-1.0,
    mass=1e9,
    spin=0.5,
    moment=0.0,
    kind=HADRON,
)

# Now can create by name
x = Species("X-")
```

### Method 3: Register Custom Atomic Element

Add a custom element with isotopes:

```julia
AtomicAndPhysicalConstants.ATOMIC_SPECIES["Xe"] = (
    Z=54,
    isotopes=Dict(
        129 => 120000.0,  # Xe-129 mass
        132 => 122000.0,  # Xe-132 mass
        -1 => 121000.0,   # Natural abundance average
    ),
)

# Now can create with full parsing
xe = Species("129Xe++")
```

## Data Sources

All constants, particle properties, and atomic data are sourced from **CODATA 2022** (Committee on Data of the International Science Council), the most recent internationally recommended values for fundamental physical constants.

## Package Design Philosophy

1. **Simplicity**: No initialization required, direct access to all data
2. **Performance**: Module-level constants enable compiler optimizations
3. **Extensibility**: Easy to add custom species via dictionaries
4. **Standards Compliance**: Uses authoritative data sources
5. **Type Stability**: All properties use standard Julia numeric types

## File Organization

The package source is organized as follows:

- Type definitions and core structures
- Subatomic species data dictionary
- Atomic species and isotope data dictionary
- Physical constants definitions
- Species constructor and parsing logic
- Helper functions (`nameof()`, etc.)

This structure keeps the implementation simple and maintainable while providing all necessary functionality.

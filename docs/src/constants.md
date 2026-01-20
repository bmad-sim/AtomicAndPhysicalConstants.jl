# Constants

## Available Constants

Physical constants are available directly after importing the package. No initialization is required.

```julia
julia> using AtomicAndPhysicalConstants
julia> C_LIGHT
2.99792458e8
```

## Fundamental Constants

All constants are available as module-level constants:

### Speed and Universal Constants
- `C_LIGHT`: Speed of light [m/s]
- `H_PLANCK`: Planck constant [J⋅s]
- `H_BAR`: Reduced Planck constant [J⋅s]
- `E_CHARGE`: Elementary charge [C]
- `FINE_STRUCTURE`: Fine structure constant (dimensionless)
- `AVOGADRO`: Avogadro constant [mol⁻¹]

### Electromagnetic Constants
- `EPS_0`: Permittivity of free space [F/m]
- `MU_0`: Permeability of free space [N/A²]

### Classical Radii
- `R_ELECTRON`: Classical electron radius [m]
- `R_PROTON`: Classical proton radius [m]

## Particle Masses

All masses are in [eV/c²]:

- `M_ELECTRON`: Electron mass
- `M_PROTON`: Proton mass
- `M_NEUTRON`: Neutron mass
- `M_MUON`: Muon mass
- `M_PION_0`: Neutral pion mass
- `M_PION_CHARGED`: Charged pion mass
- `M_DEUTERON`: Deuteron mass
- `M_HELION`: Helion (³He nucleus) mass

## Magnetic Moments

All magnetic moments are in [J/T]:

- `MU_ELECTRON`: Electron magnetic moment
- `MU_PROTON`: Proton magnetic moment
- `MU_NEUTRON`: Neutron magnetic moment
- `MU_MUON`: Muon magnetic moment
- `MU_DEUTERON`: Deuteron magnetic moment
- `MU_HELION`: Helion magnetic moment
- `MU_TRITON`: Triton magnetic moment

## g-factors

All g-factors are dimensionless:

- `G_ELECTRON`: Electron g-factor
- `G_PROTON`: Proton g-factor
- `G_NEUTRON`: Neutron g-factor
- `G_MUON`: Muon g-factor
- `G_DEUTERON`: Deuteron g-factor
- `G_HELION`: Helion g-factor
- `G_TRITON`: Triton g-factor

## Magnetic Moment Anomalies

Dimensionless anomalies:

- `ANOMALY_ELECTRON`: Electron magnetic moment anomaly
- `ANOMALY_MUON`: Muon magnetic moment anomaly

## Unit Conversions

- `KG_PER_AMU`: Kilograms per atomic mass unit [kg/amu]
- `EV_PER_AMU`: Electronvolts per atomic mass unit [eV/amu]
- `J_PER_EV`: Joules per electronvolt [J/eV]

## Release Information

- `RELEASE_YEAR`: CODATA release year (2022)

## Examples

```julia
using AtomicAndPhysicalConstants

# Physical constants
println("Speed of light: ", C_LIGHT, " m/s")
println("Electron mass: ", M_ELECTRON, " eV/c²")
println("Planck constant: ", H_PLANCK, " J⋅s")
println("Fine structure constant: ", FINE_STRUCTURE)

# Unit conversions
println("1 amu = ", EV_PER_AMU, " eV/c²")
println("1 eV = ", J_PER_EV, " J")
```

## Data Sources

All constants and species data are sourced from **CODATA 2022** (Committee on Data of the International Science Council), the most recent internationally recommended values for fundamental physical constants.

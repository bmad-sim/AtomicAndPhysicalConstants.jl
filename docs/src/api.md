# API Reference

Complete index of all exported symbols.

## Internal Types

```@docs
AtomicAndPhysicalConstants.SubatomicSpecies
AtomicAndPhysicalConstants.AtomicSpecies
AtomicAndPhysicalConstants.CODATA_release
```

## Species type and constructor

```@docs
Species
```

## Accessor functions

The full docstrings for these live on the
[Species](@ref man-species-accessors) page, next to the narrative description of
the unit conventions and of what each one returns for species that do not carry
the property:

- [`nameof`](@ref Base.nameof(::Species)) — canonical species name
- [`chargeof`](@ref) — net charge, in units of *e* or in coulombs
- [`massof`](@ref) — rest mass, in eV/c² or in daltons
- [`spinof`](@ref) — spin, in ħ
- [`momentof`](@ref) — magnetic dipole moment, in eV/T
- [`g_spin`](@ref) — spin g-factor, unsigned or signed
- [`gyromagnetic_anomaly`](@ref) — ``a = (|g| - 2)/2``
- [`iso_of`](@ref) — mass number
- [`atomicnumberof`](@ref) — atomic number *Z*
- [`kindof`](@ref) — particle classification
- [`isnullspecies`](@ref) — null-species test

## Configuration

```@docs
set_release
```

## Particle kind enum

```@docs
AtomicAndPhysicalConstants.Kind
```

## Particle data dictionaries

```@docs
SUBATOMIC_SPECIES
ATOMIC_SPECIES
```

## CODATA release structs

```@docs
CODATA2002
CODATA2006
CODATA2010
CODATA2014
CODATA2018
CODATA2022
```

## Physical constants

```@docs
M_ELECTRON
M_PROTON
M_NEUTRON
M_MUON
M_DEUTERON
M_HELION
M_TRITON
M_PION_0
M_PION_CHARGED
MU_ELECTRON
MU_PROTON
MU_NEUTRON
MU_MUON
MU_DEUTERON
MU_HELION
MU_TRITON
G_ELECTRON
G_PROTON
G_NEUTRON
G_MUON
G_DEUTERON
G_HELION
G_TRITON
ANOMALY_ELECTRON
ANOMALY_MUON
E_CHARGE
C_LIGHT
H_PLANCK
H_BAR
R_ELECTRON
R_PROTON
CLASSICAL_RADIUS_FACTOR
K_BOLTZMANN
EPS_0
MU_0
AVOGADRO
FINE_STRUCTURE
RELEASE_YEAR
KG_PER_AMU
EV_PER_AMU
J_PER_EV
EV_PER_J
G_PER_EV
KG_PER_MEV_C2
```

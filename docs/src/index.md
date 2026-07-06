# AtomicAndPhysicalConstants.jl

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://bmad-sim.github.io/AtomicAndPhysicalConstants.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://bmad-sim.github.io/AtomicAndPhysicalConstants.jl/dev/)
[![Build Status](https://github.com/bmad-sim/AtomicAndPhysicalConstants.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/bmad-sim/AtomicAndPhysicalConstants.jl/actions/workflows/CI.yml?query=branch%3Amain)

AtomicAndPhysicalConstants.jl provides fundamental physical constants and
particle data drawn from official [CODATA](https://codata.org/) releases
(2002 – 2022).  Values are expressed in units natural to accelerator and
atomic physics (eV, eV/c², eV·s, eV/T, …).

## Installation

```julia
using Pkg
Pkg.add("AtomicAndPhysicalConstants")
```

## Quick start

```julia
using AtomicAndPhysicalConstants

# ── physical constants ──────────────────────────────────────────────
C_LIGHT    # 2.99792458e8  m/s
H_PLANCK   # 4.135667696e-15  eV·s
M_ELECTRON # 510998.95069  eV/c²

# ── particle species ────────────────────────────────────────────────
e    = Species("electron")
p    = Species("proton")
h    = Species("H")          # neutral hydrogen, abundance-averaged mass
he3  = Species("3He")        # neutral helium-3
hion = Species("H+")         # singly-ionised hydrogen
antip = Species("anti-proton")

# ── accessor functions ───────────────────────────────────────────────
massof(e)                    # 510998.95069  eV/c²
massof(h, AMU=true)          # mass in atomic mass units
chargeof(hion)               # 1  (units of e)
spinof(e)                    # 0.5  ħ
gspin_of(e)                  # 2.00231930436092
gyromagnetic_anomaly(e)      # ≈ 0.00115965…
momentof(p)                  # magnetic dipole moment  eV/T
iso_of(he3)                  # 3  (mass number)
```

## Package overview

| Topic | Description |
|-------|-------------|
| [Species](@ref man-species) | Constructing and querying particle species |
| [Constants](@ref man-constants) | Exported physical constants |
| [CODATA Releases](@ref man-codata) | Switching between CODATA release years |
| [API Reference](@ref) | Complete docstring index |

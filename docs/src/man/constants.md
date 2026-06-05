# [Physical Constants](@id man-constants)

AtomicAndPhysicalConstants.jl exports a flat set of `const` values drawn from the
active CODATA release.  All values are `Float64` scalars in the units shown below.

The active release is selected at package-load time via a
[Preferences.jl](https://github.com/JuliaPackaging/Preferences.jl) setting
(default: 2022).  See [CODATA Releases](@ref man-codata) for how to change it.

---

## Particle masses

Units: **eV/c²**

| Constant | Particle |
|----------|----------|
| `M_ELECTRON` | electron |
| `M_PROTON` | proton |
| `M_NEUTRON` | neutron |
| `M_MUON` | muon |
| `M_DEUTERON` | deuteron |
| `M_HELION` | helion (³He nucleus) |
| `M_PION_0` | neutral pion † |
| `M_PION_CHARGED` | charged pion † |

† Pion masses are taken from the Particle Data Group (PDG), not from CODATA,
and are the same across all release years.

```@docs
M_ELECTRON
M_PROTON
M_NEUTRON
M_MUON
M_DEUTERON
M_HELION
M_PION_0
M_PION_CHARGED
```

---

## Magnetic dipole moments

Units: **eV/T**

Stored values are CODATA SI values (J/T) converted to eV/T via `EV_PER_J`.

| Constant | Particle |
|----------|----------|
| `MU_ELECTRON` | electron |
| `MU_PROTON` | proton |
| `MU_NEUTRON` | neutron |
| `MU_MUON` | muon |
| `MU_DEUTERON` | deuteron |
| `MU_HELION` | helion |
| `MU_TRITON` | triton |

```@docs
MU_ELECTRON
MU_PROTON
MU_NEUTRON
MU_MUON
MU_DEUTERON
MU_HELION
MU_TRITON
```

---

## Spin g-factors (dimensionless)

| Constant | Particle | CODATA availability |
|----------|----------|---------------------|
| `G_ELECTRON` | electron | all releases |
| `G_PROTON` | proton | all releases |
| `G_NEUTRON` | neutron | all releases |
| `G_MUON` | muon | all releases |
| `G_DEUTERON` | deuteron | all releases |
| `G_HELION` | helion | 2010 and later |
| `G_TRITON` | triton | all releases |

```@docs
G_ELECTRON
G_PROTON
G_NEUTRON
G_MUON
G_DEUTERON
G_HELION
G_TRITON
```

---

## Gyromagnetic anomalies (dimensionless)

The gyromagnetic anomaly is defined as ``a = (g - 2)/2``.

| Constant | Particle | CODATA availability |
|----------|----------|---------------------|
| `ANOMALY_ELECTRON` | electron | 2010 and later |
| `ANOMALY_MUON` | muon | 2010 and later |

```@docs
ANOMALY_ELECTRON
ANOMALY_MUON
```

---

## Other physical constants

| Constant | Description | Units |
|----------|-------------|-------|
| `E_CHARGE` | elementary charge | C |
| `C_LIGHT` | speed of light | m/s |
| `H_PLANCK` | Planck's constant *h* | eV·s |
| `H_BAR` | reduced Planck constant *ħ* | eV·s |
| `R_ELECTRON` | classical electron radius | m |
| `R_PROTON` | classical proton radius | m |
| `CLASSICAL_RADIUS_FACTOR` | ``e^2 / (4\pi\varepsilon_0) = r_e m_e c^2`` | eV·m |
| `EPS_0` | permittivity of free space | F/m |
| `MU_0` | vacuum permeability | N/A² |
| `AVOGADRO` | Avogadro's constant | mol⁻¹ |
| `FINE_STRUCTURE` | fine-structure constant | dimensionless |
| `RELEASE_YEAR` | active CODATA release year | — |

```@docs
E_CHARGE
C_LIGHT
H_PLANCK
H_BAR
R_ELECTRON
R_PROTON
CLASSICAL_RADIUS_FACTOR
EPS_0
MU_0
AVOGADRO
FINE_STRUCTURE
RELEASE_YEAR
```

---

## Unit-conversion constants

| Constant | Conversion |
|----------|------------|
| `KG_PER_AMU` | kg per dalton |
| `EV_PER_AMU` | eV/c² per dalton |
| `J_PER_EV` | joules per eV |
| `EV_PER_J` | eV per joule |
| `G_PER_EV` | grams per eV/c² |
| `KG_PER_MEV_C2` | kg per MeV/c² |

```@docs
KG_PER_AMU
EV_PER_AMU
J_PER_EV
EV_PER_J
G_PER_EV
KG_PER_MEV_C2
```

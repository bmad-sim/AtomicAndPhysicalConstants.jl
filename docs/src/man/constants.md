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
| `M_TRITON` | triton (³H nucleus) ‡ |
| `M_PION_0` | neutral pion † |
| `M_PION_CHARGED` | charged pion † |

† Pion masses are taken from the Particle Data Group (PDG), not from CODATA,
and are the same across all release years.

‡ `M_TRITON` is not tabulated in the 2002 CODATA release; `CODATA2002.M_TRITON`
is `NaN`.


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


---

## Spin g-factors (dimensionless)

| Constant | Particle | CODATA availability |
|----------|----------|---------------------|
| `G_ELECTRON` | electron | all releases |
| `G_PROTON` | proton | all releases |
| `G_NEUTRON` | neutron | all releases |
| `G_MUON` | muon | all releases |
| `G_DEUTERON` | deuteron | all releases § |
| `G_HELION` | helion | 2010 and later § |
| `G_TRITON` | triton | all releases § |

§ These three are **not** the raw CODATA values — see below.

### Composite-nucleus g-factors are renormalized

CODATA/NIST tabulates the deuteron, helion, and triton g-factors relative to the
**nuclear magneton** ``\mu_N = e\hbar / 2m_p``, i.e. the published number is

```math
g_\text{NIST} = \frac{\mu}{I\,\mu_N}
```

so the proton mass — not the particle's own mass — sets the scale.  Used
directly in ``a = (|g|-2)/2`` those values give a meaningless anomaly (for the
deuteron, ``(0.857\ldots - 2)/2``).

This package instead stores the g-factor in the convention
``\boldsymbol{\mu} = g\,\frac{e}{2m}\,\mathbf{S}``, where the particle's *own*
mass sets the scale, which is the convention the spin-precession (Thomas–BMT)
equation and the gyromagnetic anomaly assume.  Converting between the two is a
single mass ratio, applied at package-load time:

```math
g = g_\text{NIST}\,\frac{m}{m_p}
```

| Exported constant | Definition |
|-------------------|------------|
| `G_DEUTERON` | `G_DEUTERON_NUCLEAR * M_DEUTERON / M_PROTON` |
| `G_HELION` | `G_HELION_NUCLEAR * M_HELION / M_PROTON` |
| `G_TRITON` | `G_TRITON_NUCLEAR * M_TRITON / M_PROTON` |

The `_NUCLEAR` suffix marks the nuclear-magneton normalization: those are the
names the raw NIST values carry as fields of the release structs
(`CODATA2022.G_DEUTERON_NUCLEAR`, …).  There is no exported top-level
`G_*_NUCLEAR` constant; the active release's values are held as the internal
`AtomicAndPhysicalConstants._G_DEUTERON`, `._G_HELION`, and `._G_TRITON`.

The mass ratio uses the mass from the *same* active CODATA release as the
g-factor, so switching releases with [`set_release`](@ref) renormalizes
consistently.

Only these three struct fields carry the `_NUCLEAR` suffix.  The electron, muon,
proton, and neutron g-factors need no rescaling — CODATA already tabulates them
against the magneton built from the particle's own mass — so `G_ELECTRON`,
`G_MUON`, `G_PROTON`, and `G_NEUTRON` keep their plain names in the release
structs and are exported exactly as published.

Because the renormalization is folded into the constants themselves,
[`g_spin`](@ref) and [`gyromagnetic_anomaly`](@ref) need no special-casing —
``a = (|g|-2)/2`` applies uniformly to every subatomic species:

```julia
gyromagnetic_anomaly(Species("deuteron"))   # ≈ -0.1429872697
```


---

## Gyromagnetic anomalies (dimensionless)

The gyromagnetic anomaly is defined as ``a = (|g| - 2)/2``.
[`gyromagnetic_anomaly`](@ref) takes the **unsigned** g-factor — the default of
[`g_spin`](@ref) — so particles with a negative stored g-factor (electron, muon,
neutron, helion) come out with the conventional positive anomaly rather than a
value near ``-2``.

| Constant | Particle | CODATA availability |
|----------|----------|---------------------|
| `ANOMALY_ELECTRON` | electron | 2010 and later |
| `ANOMALY_MUON` | muon | 2010 and later |


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
| `CLASSICAL_RADIUS_FACTOR` | ``e^2 / (4\pi\varepsilon_0) = r_e m_e c^2`` † | eV·m |
| `K_BOLTZMANN` | Bolzmann's constant k<sub>B<sub> | eV/K |
| `EPS_0` | permittivity of free space | 1/(eV·m) |
| `MU_0` | vacuum permeability | eV·s²/m |
| `AVOGADRO` | Avogadro's constant | mol⁻¹ |
| `FINE_STRUCTURE` | fine-structure constant | dimensionless |
| `RELEASE_YEAR` | active CODATA release year | — |

† `CLASSICAL_RADIUS_FACTOR` is not a tabulated CODATA value; it is computed as
`R_ELECTRON * M_ELECTRON` from the active release.  It is the same for all
particles of charge ±1.  Because it is derived, it is not a field of the
`CODATA_release` structs (e.g. there is no `CODATA2022.CLASSICAL_RADIUS_FACTOR`).


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


# [Physical Constants](@id man-constants)

AtomicAndPhysicalConstants.jl exports a flat set of `const` values drawn from the
active CODATA release.  All values are `Float64` scalars in the units shown below.

The active release is selected at package-load time via a
[Preferences.jl](https://github.com/JuliaPackaging/Preferences.jl) setting
(default: the most recent release the package ships, currently 2022).  See [CODATA Releases](@ref man-codata) for how to change it.

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

† Pion masses are taken from the Particle Data Group (PDG), not from CODATA.
Each release uses the PDG edition of the same year; see
[Constants not in CODATA](@ref).

‡ `M_TRITON` is not tabulated in the 2002 CODATA release; `CODATA2002.M_TRITON`
is `NaN`.

NIST does not tabulate particle masses in eV.  Each mass is NIST's "mass energy
equivalent in MeV" value with the decimal point moved to eV, which is exact.


---

## Magnetic dipole moments

Units: **eV/T**

Each is the release's `MU_*_SI` field — the CODATA value in J/T — converted to
eV/T via `EV_PER_J`.  The `_SI` suffix names the unit the published value is in;
see [Constants that differ from the tabulated release value](@ref).

| Constant | Particle |
|----------|----------|
| `MU_ELECTRON` | electron |
| `MU_PROTON` | proton |
| `MU_NEUTRON` | neutron |
| `MU_MUON` | muon |
| `MU_DEUTERON` | deuteron |
| `MU_HELION` | helion ‖ |
| `MU_TRITON` | triton ‖ |

‖ `MU_HELION` is `NaN` for the 2002 and 2006 releases and `MU_TRITON` for 2002,
which do not tabulate them.  See
[Quantities missing from a release](@ref).


---

## Spin g-factors (dimensionless)

| Constant | Particle | CODATA availability |
|----------|----------|---------------------|
| `G_ELECTRON` | electron | all releases |
| `G_PROTON` | proton | all releases |
| `G_NEUTRON` | neutron | all releases § |
| `G_MUON` | muon | all releases |
| `G_DEUTERON` | deuteron | 2006 and later § |
| `G_HELION` | helion | 2010 and later § |
| `G_TRITON` | triton | 2006 and later § |

§ These four are **not** the raw CODATA values — see below.

### Nuclear-magneton g-factors are renormalized

CODATA/NIST tabulates the neutron, deuteron, helion, and triton g-factors
relative to the **nuclear magneton** ``\mu_N = e\hbar / 2m_p``, i.e. the published number is

```math
g_\text{NIST} = \frac{\mu}{I\,\mu_N}
```

so the proton mass — not the particle's own mass — sets the scale.  Used
directly in the anomaly ``a = (g_q-2)/2`` those values give a meaningless
result (for the deuteron, ``(0.857\ldots - 2)/2``).

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
| `G_NEUTRON` | `G_NEUTRON_NUCLEAR_MAGNETON * M_NEUTRON / M_PROTON` |
| `G_DEUTERON` | `G_DEUTERON_NUCLEAR_MAGNETON * M_DEUTERON / M_PROTON` |
| `G_HELION` | `G_HELION_NUCLEAR_MAGNETON * M_HELION / M_PROTON` |
| `G_TRITON` | `G_TRITON_NUCLEAR_MAGNETON * M_TRITON / M_PROTON` |

The `_NUCLEAR_MAGNETON` suffix names the normalization the raw NIST value
carries, and those are the names the release-struct fields use
(`CODATA2022.G_DEUTERON_NUCLEAR_MAGNETON`, …).  There is no exported top-level
`G_*_NUCLEAR_MAGNETON` constant; the active release's values are held as the
internal `AtomicAndPhysicalConstants._G_NEUTRON_NUCLEAR_MAGNETON`,
`._G_DEUTERON_NUCLEAR_MAGNETON`, `._G_HELION_NUCLEAR_MAGNETON`, and
`._G_TRITON_NUCLEAR_MAGNETON`.

The mass ratio uses the mass from the *same* active CODATA release as the
g-factor, so switching releases with [`set_release`](@ref) renormalizes
consistently.

Only these four struct fields carry the `_NUCLEAR_MAGNETON` suffix.  The
electron and muon g-factors need no rescaling — CODATA tabulates them against the Bohr
magneton ``\mu_B = e\hbar/2m_e``, built from the particle's own mass — and for
the proton the nuclear magneton *is* its own magneton, so `G_ELECTRON`,
`G_MUON`, and `G_PROTON` keep their plain names in the release structs and are
exported exactly as published.

!!! note "The neutron correction is small but real"
    The neutron is the one uncharged particle in the list, so it is easy to
    overlook: NIST tabulates its g-factor against the nuclear magneton just as
    it does the three composite nuclei.  The ratio ``m_n/m_p = 1.0013784`` makes
    `G_NEUTRON` `-3.8313594707492573` where NIST publishes `-3.82608552`, a
    difference of 0.14 %.  [`gyromagnetic_anomaly`](@ref) returns `NaN` for the
    neutron either way, since ``g_q`` needs a charge, but
    `g_spin(Species("neutron"))` is now in the same convention as every other
    species.

Because the renormalization is folded into the constants themselves,
[`g_spin`](@ref) and [`gyromagnetic_anomaly`](@ref) need no special-casing —
``a = (g_q-2)/2`` applies uniformly to every charged subatomic species:

```julia
gyromagnetic_anomaly(Species("deuteron"))   # ≈ -0.1429872697
```


---

## Gyromagnetic anomalies (dimensionless)

The gyromagnetic anomaly is defined as

```math
a = \frac{g_q - 2}{2}, \qquad g_q = g\,\frac{e}{q},
```

where ``g`` is the signed g-factor in the convention
``\boldsymbol{\mu} = g\,\frac{e}{2m}\,\mathbf{S}`` and ``g_q`` the g-factor
normalized to the particle's own charge *q*, as in the Thomas–BMT equation.
Dividing by *q* gives the electron (``g<0``, ``q=-e``) and the positron
(``g>0``, ``q=+e``) the same positive anomaly, and the doubly charged helion
``a = -4.1841537…``.  [`gyromagnetic_anomaly`](@ref) returns `NaN` for neutral
particles, for which ``g_q`` is undefined.

| Constant | Particle | CODATA availability |
|----------|----------|---------------------|
| `ANOMALY_ELECTRON` | electron | all releases |
| `ANOMALY_MUON` | muon | all releases |


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
| `K_BOLTZMANN` | Boltzmann's constant k<sub>B</sub> | eV/K |
| `EPS_0` | permittivity of free space | 1/(eV·m) |
| `MU_0` | vacuum permeability | eV·s²/m |
| `AVOGADRO` | Avogadro's constant | mol⁻¹ |
| `FINE_STRUCTURE` | fine-structure constant | dimensionless |
| `RELEASE_YEAR` | active CODATA release year | — |

† `CLASSICAL_RADIUS_FACTOR` is not a tabulated CODATA value; it is computed as
`R_ELECTRON * M_ELECTRON` from the active release.  It is the same for all
particles of charge ±1.  Because it is derived, it is not a field of the
`CODATA_release` structs (e.g. there is no `CODATA2022.CLASSICAL_RADIUS_FACTOR`).
`KG_PER_AMU` and `KG_PER_MEV_C2` are derived in the same sense — see the note
below the unit-conversion table.


---

## Unit-conversion constants

| Constant | Conversion |
|----------|------------|
| `KG_PER_AMU` | kg per dalton † |
| `EV_PER_AMU` | eV/c² per dalton |
| `J_PER_EV` | joules per eV |
| `EV_PER_J` | eV per joule |
| `G_PER_EV` | grams per eV/c² |
| `KG_PER_MEV_C2` | kg per MeV/c² † |

† Two of these are derived rather than tabulated, so they are not fields of the
release structs.  `KG_PER_AMU` is the release's `G_PER_AMU` field (grams per
dalton) times `1e-3`, so the struct field and the exported constant differ in
both name and unit; `KG_PER_MEV_C2` is `G_PER_EV * 1e3`.


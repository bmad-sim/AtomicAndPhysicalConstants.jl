# [Physical Constants](@id man-constants)

AtomicAndPhysicalConstants.jl exports a flat set of `const` values drawn from the
active CODATA release.  All values are `Float64` scalars in the units shown below.

The active release is selected at package-load time via a
[Preferences.jl](https://github.com/JuliaPackaging/Preferences.jl) setting
(default: the most recent release the package ships, currently 2022).  See [CODATA Releases](@ref man-codata) for how to change it.

The tables below give two names for each quantity.  The **CODATA Name** is the
field of the `CODATA_release` struct that holds the published value, as in
`CODATA2022.MU_PROTON_SI`; the **APC Name** is the exported constant, as in
`MU_PROTON`.  The two differ wherever APC converts the published value before
exporting it — a unit change for the magnetic moments, a change of magneton for
four of the g-factors — and are the same name otherwise.

---

## Particle masses

Units: **eV/c²**

| CODATA Name | APC Name | Particle | CODATA availability |
|-------------|----------|----------|---------------------|
| `M_ELECTRON` | `M_ELECTRON` | electron | all releases |
| `M_PROTON` | `M_PROTON` | proton | all releases |
| `M_NEUTRON` | `M_NEUTRON` | neutron | all releases |
| `M_MUON` | `M_MUON` | muon | all releases |
| `M_DEUTERON` | `M_DEUTERON` | deuteron | all releases |
| `M_HELION` | `M_HELION` | helion (³He nucleus) | all releases |
| `M_TRITON` | `M_TRITON` | triton (³H nucleus) | 2006 and later ‡ |
| — | `M_PION_0` | neutral pion | not in CODATA † |
| — | `M_PION_CHARGED` | charged pion | not in CODATA † |

† Pion masses are taken from the Particle Data Group (PDG), not from CODATA,
so they have no CODATA name.  Each release uses the PDG edition of the same
year, and the release structs carry the values as `M_PION_0` and
`M_PION_CHARGED`; see [Constants not in CODATA](@ref).

‡ A quantity a release does not tabulate is `NaN` rather than absent, so
`CODATA2002.M_TRITON` is `NaN`.  See [Quantities missing from a release](@ref).

NIST does not tabulate particle masses in eV.  Each mass is NIST's "mass energy
equivalent in MeV" value with the decimal point moved to eV, which is exact.


---

## Magnetic dipole moments

Units: **eV/T**

Each is the release's `MU_*_SI` field — the CODATA value in J/T — converted to
eV/T.  The `_SI` suffix names the unit the published value is in;
see [Constants that differ from the tabulated release value](@ref).

| CODATA Name | APC Name | Particle | CODATA availability |
|-------------|----------|----------|---------------------|
| `MU_ELECTRON_SI` | `MU_ELECTRON` | electron | all releases |
| `MU_PROTON_SI` | `MU_PROTON` | proton | all releases |
| `MU_NEUTRON_SI` | `MU_NEUTRON` | neutron | all releases |
| `MU_MUON_SI` | `MU_MUON` | muon | all releases |
| `MU_DEUTERON_SI` | `MU_DEUTERON` | deuteron | all releases |
| `MU_HELION_SI` | `MU_HELION` | helion | 2010 and later ‖ |
| `MU_TRITON_SI` | `MU_TRITON` | triton | 2006 and later ‖ |

‖ For the releases not listed the field is `NaN`; the earlier tables give only
the *shielded* helion moment, which is a different quantity.  See
[Quantities missing from a release](@ref).


---

## Spin g-factors (dimensionless)

| CODATA Name | APC Name | Particle | CODATA availability |
|-------------|----------|----------|---------------------|
| `G_ELECTRON` | `G_ELECTRON` | electron | all releases |
| `G_PROTON` | `G_PROTON` | proton | all releases |
| `G_NEUTRON_NUCLEAR_MAGNETON` | `G_NEUTRON` | neutron | all releases § |
| `G_MUON` | `G_MUON` | muon | all releases |
| `G_DEUTERON_NUCLEAR_MAGNETON` | `G_DEUTERON` | deuteron | 2006 and later § |
| `G_HELION_NUCLEAR_MAGNETON` | `G_HELION` | helion | 2010 and later § |
| `G_TRITON_NUCLEAR_MAGNETON` | `G_TRITON` | triton | 2006 and later § |

§ These four are **not** the raw CODATA values — see below.

CODATA/NIST tabulates the neutron, deuteron, helion, and triton g-factors
relative to the **nuclear magneton** ``\mu_N = e\hbar / 2m_p``. That is, the published number is
```math
g_\text{NIST} = \frac{\mu}{I\,\mu_N}
```

so the proton mass — not the particle's own mass — sets the scale.
This means that the equation ``a = (g_q-2)/2`` is not valid for these quantities.
For this reason, to make code using g-factors cleaner, the APC values of the g-factor 
are computed from ``\boldsymbol{\mu} = g\,\frac{e}{2m}\,\mathbf{S}``, where the particle's *own*
mass sets the scale
```math
g_\text{APC} = g_\text{NIST}\,\frac{m_\text{particle}}{m_{proton}}
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

| CODATA Name | APC Name | Particle | CODATA availability |
|-------------|----------|----------|---------------------|
| `ANOMALY_ELECTRON` | `ANOMALY_ELECTRON` | electron | all releases |
| `ANOMALY_MUON` | `ANOMALY_MUON` | muon | all releases |


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
| `K_BOLTZMANN` | Boltzmann's constant ``k_B`` | eV/K |
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


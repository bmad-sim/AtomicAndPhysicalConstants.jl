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
exporting it.  An em dash in the CODATA Name column marks a constant
CODATA does not tabulate.

---

## Particle masses

APC Units: eV/c²

| CODATA Name | APC Name | Particle | CODATA availability |
|-------------|----------|----------|---------------------|
| `M_ELECTRON` | `M_ELECTRON` | electron | all releases |
| `M_PROTON` | `M_PROTON` | proton | all releases |
| `M_NEUTRON` | `M_NEUTRON` | neutron | all releases |
| `M_MUON` | `M_MUON` | muon | all releases |
| `M_DEUTERON` | `M_DEUTERON` | deuteron | all releases |
| `M_HELION` | `M_HELION` | helion (³He nucleus) | all releases |
| `M_TRITON` | `M_TRITON` | triton (³H nucleus) | 2006 and later |
| `M_PION_0` † | `M_PION_0` | neutral pion | from PDG |
| `M_PION_CHARGED` † | `M_PION_CHARGED` | charged pion | from PDG |

† Taken from the Particle Data Group (PDG) and not from CODATA
so technically there is no CODATA name but these parameters are carried in the release structs.
A release struct carries the PDG value of the corresponding CODATA year.

NIST tabulates particle masses in MeV/c².
A quantity a release does not tabulate has a value of `NaN` in the release struct.
For example, `M_TRITON` before 2006.

---

## Magnetic dipole moments

APC Units: **eV/T**

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

## Spin g-factors 

Units: dimensionless

| CODATA Name | APC Name | Particle | CODATA availability |
|-------------|----------|----------|---------------------|
| `G_ELECTRON` | `G_ELECTRON` | electron | all releases |
| `G_PROTON` | `G_PROTON` | proton | all releases |
| `G_NEUTRON_NUCLEAR_MAGNETON` | `G_NEUTRON` | neutron | all releases |
| `G_MUON` | `G_MUON` | muon | all releases |
| `G_DEUTERON_NUCLEAR_MAGNETON` | `G_DEUTERON` | deuteron | 2006 and later |
| `G_HELION_NUCLEAR_MAGNETON` | `G_HELION` | helion | 2010 and later |
| `G_TRITON_NUCLEAR_MAGNETON` | `G_TRITON` | triton | 2006 and later |

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
g_\text{APC} = g_\text{NIST}\,\frac{m_\text{particle}}{m_{\text{proton}}}
```

---

## Gyromagnetic anomalies

Units: dimensionless

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

| CODATA Name | APC Name | Description | APC Units |
|-------------|----------|-------------|-------|
| `E_CHARGE` | `E_CHARGE` | elementary charge | C |
| `C_LIGHT` | `C_LIGHT` | speed of light | m/s |
| `H_PLANCK` | `H_PLANCK` | Planck's constant *h* | eV·s |
| `H_BAR` | `H_BAR` | reduced Planck constant *ħ* | eV·s |
| `R_ELECTRON` | `R_ELECTRON` | classical electron radius | m |
| — † | `R_PROTON` | classical proton radius | m |
| — † | `CLASSICAL_RADIUS_FACTOR` | ``e^2 / (4\pi\varepsilon_0)`` | eV·m |
| `K_BOLTZMANN` | `K_BOLTZMANN` | Boltzmann's constant ``k_B`` | eV/K |
| `EPS_0_SI` | `EPS_0` | permittivity of free space | 1/(eV·m) |
| `MU_0_SI` | `MU_0` | vacuum permeability | eV·s²/m |
| `AVOGADRO` | `AVOGADRO` | Avogadro's constant | mol⁻¹ |
| `FINE_STRUCTURE` | `FINE_STRUCTURE` | fine-structure constant | dimensionless |
| `RELEASE_YEAR` | `RELEASE_YEAR` | active CODATA release year | — |

† Not a tabulated CODATA value.

---

## Unit-conversion constants

| CODATA Name | APC Name | APC Units |
|-------------|----------|------------|
| `G_PER_AMU` | `KG_PER_AMU` | kg/dalton |
| `EV_PER_AMU` | `EV_PER_AMU` | eV/(c²·dalton) |
| `J_PER_EV` | `J_PER_EV` | joules/eV |
| `EV_PER_J` | `EV_PER_J` | eV/joule |
| `G_PER_EV` | `G_PER_EV` | grams/(c²·eV) |
| `G_PER_EV` | `KG_PER_MEV_C2` | kg/(c²·MeV) |

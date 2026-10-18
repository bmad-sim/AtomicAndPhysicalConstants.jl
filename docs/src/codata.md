# [CODATA Releases](@id man-codata)

The [CODATA](https://codata.org/) task group on fundamental constants publishes
updated recommended values every four years.  AtomicAndPhysicalConstants.jl
ships constants from every release since 2002 and lets you choose which one to
use at runtime.

## Supported releases

| Release | Notes |
|---------|-------|
| 2002 | earliest supported; six quantities are `NaN` (see [Quantities missing from a release](@ref)) |
| 2006 | two quantities are `NaN` (see [Quantities missing from a release](@ref)) |
| 2010 | first release that tabulates every quantity the package uses |
| 2014 | |
| 2018 | |
| 2022 | most recent, so the **default** |

## Checking the active release

```julia
using AtomicAndPhysicalConstants
RELEASE_YEAR   # Int – the currently active release year
```

## Changing the release

```julia
using AtomicAndPhysicalConstants

set_release(year = "2014")
# [ Info: The default CODATA release is now 2014.
#         Restart your Julia session for this change to take effect.
```

The setting is stored via [Preferences.jl](https://github.com/JuliaPackaging/Preferences.jl)
and persists across Julia sessions until changed again.

!!! note "Restart required"
    Constants are resolved at package load time, so a Julia session restart
    is required for the new release to take effect.

!!! warning "Unsupported releases"
    Only the years listed under **Supported releases** above are valid. If the
    stored preference points at an unsupported release (for
    example after hand-editing `LocalPreferences.toml`), the package raises an
    error at load time listing the valid options rather than silently falling
    back to the default.

## The default release

With no release set, the package uses the most recent release it ships,
currently 2022.  When a newer release is added to the package, it becomes the
default for every environment that has not set one.

`set_release()` with no argument removes the setting, so the environment goes
back to following the most recent release:

```julia
set_release()
# [ Info: The CODATA release now follows the most recent one, currently 2022.
#         Restart your Julia session for this change to take effect.
```

Setting a year explicitly, including the current most recent one, pins it:
`set_release(year = "2022")` keeps 2022 after a newer release is added.


## Direct access to release structs

Each release is also exported as a named `CODATA_release` struct.
You can inspect or use individual values without changing the global default:

```julia
CODATA2018.M_ELECTRON    # electron mass from the 2018 release
CODATA2014.C_LIGHT       # speed of light from the 2014 release
```


## Constants not in CODATA

The pion masses (`M_PION_0`, `M_PION_CHARGED`) are not published in any CODATA
release.  Each release carries the values from the Particle Data Group (PDG)
Review of Particle Physics edition of the same year.  The PDG editions from
the years the CODATA releases were published (2005, 2008, 2012, 2016, 2019,
2024) give the same values.

| Release | PDG edition | `M_PION_0` (MeV/c²) | `M_PION_CHARGED` (MeV/c²) |
|---------|-------------|---------------------|---------------------------|
| 2002 | 2002 | 134.9766 ± 0.0006 | 139.57018 ± 0.00035 |
| 2006 | 2006 | 134.9766 ± 0.0006 | 139.57018 ± 0.00035 |
| 2010 | 2010 | 134.9766 ± 0.0006 | 139.57018 ± 0.00035 |
| 2014 | 2014 | 134.9766 ± 0.0006 | 139.57018 ± 0.00035 |
| 2018 | 2018 | 134.9770 ± 0.0005 | 139.57061 ± 0.00024 |
| 2022 | 2022 | 134.9768 ± 0.0005 | 139.57039 ± 0.00018 |

The table shows the rounded Summary Table numbers.  The stored values are
PDG's fit values, which carry more digits (for example
`CODATA2022.M_PION_0 == 1.349768277676847e8` eV/c²), so they differ from the
rounded numbers well within the quoted uncertainty.

`CLASSICAL_RADIUS_FACTOR` is derived rather than tabulated: it is computed as
`R_ELECTRON * M_ELECTRON` from the active release.  It is therefore not a field
of the `CODATA_release` structs — `CODATA2018.CLASSICAL_RADIUS_FACTOR` does not
exist, only the exported top-level constant.

## Constants that differ from the tabulated release value

`G_DEUTERON`, `G_HELION`, and `G_TRITON` are pulled from the NIST/CODATA tables
but are **rescaled before export**.  NIST tabulates these g-factors against the
nuclear magneton ``\mu_N = e\hbar/2m_p``; the package converts them to the
particle's own magneton so that the gyromagnetic anomaly ``a = (g_q-2)/2`` comes
out correct:

```julia
G_DEUTERON == CODATA2022.G_DEUTERON_NUCLEAR * M_DEUTERON / M_PROTON   # active release
```

The release structs name these fields `G_DEUTERON_NUCLEAR`, `G_HELION_NUCLEAR`,
and `G_TRITON_NUCLEAR` — the suffix flags the nuclear-magneton normalization, so
there is no field whose name matches the exported constant and whose value
differs from it:

```julia
CODATA2022.G_DEUTERON_NUCLEAR   # 0.8574382335  — as published by NIST
CODATA2022.G_DEUTERON           # ERROR: no such field
G_DEUTERON                      # 1.7140254606… — renormalized for the anomaly
```

Both the mass and the g-factor come from the active release, so the conversion
stays self-consistent when you call `set_release`.  The active release's
unscaled values are also kept as the unexported `_G_DEUTERON`, `_G_HELION`, and
`_G_TRITON`.  See [Physical Constants](@ref man-constants) for the full
explanation.

The other g-factors (`G_ELECTRON`, `G_MUON`, `G_PROTON`, `G_NEUTRON`) are
exported exactly as tabulated.


## Quantities missing from a release

Every value in a `CODATA<year>.jl` file is the one NIST tabulates for that
release.  Where a release does not tabulate a quantity, the field is `NaN`
rather than a value borrowed from another release:

| Release | Fields that are `NaN` |
|---------|------------------------|
| 2002 | `M_TRITON`, `MU_HELION`, `MU_TRITON`, `G_DEUTERON_NUCLEAR`, `G_HELION_NUCLEAR`, `G_TRITON_NUCLEAR` |
| 2006 | `MU_HELION`, `G_HELION_NUCLEAR` |
| 2010 and later | none |

The 2002 and 2006 tables list only the *shielded* helion magnetic moment, which
is a different quantity, so it is not used in place of `MU_HELION`.

The `NaN` carries through to everything computed from the field when that
release is active.  With 2002 active, for example, `G_DEUTERON`, `G_HELION`,
and `G_TRITON` are `NaN` (each is the nuclear-magneton value times a mass
ratio), and so are the mass of the triton species and the magnetic moments and
g-factors of the helion and triton species.  With 2006 active, the helion's
magnetic moment and g-factor are `NaN`.

## How the values are taken from the NIST tables

The release files are generated by `update/update_constants.jl` (see
[Regenerating the tabulated data](@ref)).  All masses and energies are stored
in eV (eV/c² for masses).  NIST does not tabulate particle masses in eV, so each
mass is read from its "mass energy equivalent in MeV" row and the decimal point
is moved six places.  That shift is exact: the stored mass is NIST's published
number, not the product of two rounded quantities.

The 2002 and 2006 tables have no row for the elementary charge alone.
`E_CHARGE` for those releases is read from the electron volt–joule
relationship, which is the same number because 1 eV = *e* × 1 J/C.

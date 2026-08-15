# [Internals](@id man-internals)

This chapter describes how the package is put together: where its numbers come
from, how they are stored, and how they are regenerated.  None of it is needed
to use the package — [Species](@ref man-species), [Physical
Constants](@ref man-constants), and [CODATA Releases](@ref man-codata) cover
that.  Read on if you need data the accessors do not expose, or if you maintain
the tabulated data.

Everything here except the two exported dictionaries is an implementation
detail and may change without a breaking release.

## [Reference data dictionaries](@id man-internals-dicts)

Two dictionaries back the species constructor and are exported for advanced use.
Both are keyed by the same strings the constructor accepts.

| Dictionary | Type | Contents |
|------------|------|----------|
| [`SUBATOMIC_SPECIES`](@ref) | `Dict{String, SubatomicSpecies}` | mass, charge, spin, moment, and g-factor of each subatomic particle |
| [`ATOMIC_SPECIES`](@ref) | `Dict{String, AtomicSpecies}` | atomic number, plus mass-number-keyed tables of isotope masses (in daltons) and ground-state nuclear spins (in ħ) |

```julia
SUBATOMIC_SPECIES["electron"].mass   # 510998.95069  eV/c²

ATOMIC_SPECIES["He"].Z               # 2
ATOMIC_SPECIES["He"].mass[3]         # 3.0160293201  u  (helium-3)
ATOMIC_SPECIES["He"].mass[-1]        # abundance-averaged mass
ATOMIC_SPECIES["He"].spin[3]         # 0.5  ħ  (helium-3)
ATOMIC_SPECIES["He"].spin[4]         # 0.0  ħ  (helium-4)
```

The `spin` table has no `-1` key, because the abundance average has no
meaningful nuclear spin.

`SUBATOMIC_SPECIES` is built from the exported constants of the active CODATA
release, so its values follow [`set_release`](@ref); the isotope masses in
`ATOMIC_SPECIES` are release-independent tabulated data.
Constructing a [`Species`](@ref) is the supported way to
get at these numbers; reach for the dictionaries only when you need data the
accessors do not expose, such as the mass of an isotope you have not built a
species for.

The element types of the two dictionaries,
[`SubatomicSpecies`](@ref AtomicAndPhysicalConstants.SubatomicSpecies) and
[`AtomicSpecies`](@ref AtomicAndPhysicalConstants.AtomicSpecies), are not
exported; their fields are documented in the
[API Reference](@ref).  Unlike [`Species`](@ref), they are plain structs with
ordinary dot access.

## Where the data comes from

| Data | Source | Stored in |
|------|--------|-----------|
| subatomic masses, magnetic moments, g-factors, and the general constants | CODATA, via the NIST tables | `src/CODATA20**.jl`, one file per release year |
| pion masses | Particle Data Group | the `M_PION_0` / `M_PION_CHARGED` fields of each release struct |
| isotope masses and natural abundances | [NIST atomic weights and isotopic compositions](https://physics.nist.gov/cgi-bin/Compositions/stand_alone.pl) | the `mass` dictionaries in `src/species_data.jl` |
| ground-state nuclear spins | [NUBASE2020](https://www-nds.iaea.org/amdc/) | the `spin` dictionaries in `src/species_data.jl` |

The atomic data is release-independent: only the constants in `src/constants.jl`
and the subatomic species built from them change when you switch releases.

A few exported constants are not copied straight out of the source tables —
`CLASSICAL_RADIUS_FACTOR` is derived, and the deuteron, helion, and triton
g-factors are renormalized.  See
[CODATA Releases](@ref man-codata) for the details.

## How the active release is resolved

The release year is a [Preferences.jl](https://github.com/JuliaPackaging/Preferences.jl)
setting, read once at precompile time:

```julia
const release::String = @load_preference("release", "2022")
const _ACTIVE = CODATA_MAP[release]
const M_ELECTRON::Float64 = _ACTIVE.M_ELECTRON
```

Two consequences follow.  Every exported constant is a `const` global bound at
precompile time, so there is no per-call lookup and no type instability.  And
because the binding is fixed when the module is compiled, [`set_release`](@ref)
cannot take effect until Julia is restarted — it writes the preference to the
`LocalPreferences.toml` of the active environment and triggers recompilation on
the next session.  The setting is per-environment, so different projects can
pin different releases.

`CODATA_MAP` maps each supported year string to its `CODATA_release` struct;
an unrecognised value errors at load time rather than silently falling back to
the default.

## Why field access is disabled

[`Species`](@ref) overloads `Base.getproperty` to raise an error, so `p.mass`
fails and `massof(p)` is the only way in.  This keeps unit conventions and the
undefined-property cases (see
[Accessing species parameters](@ref man-species-accessors)) in one
place, and leaves the field layout free to change.  The internal structs do not
do this, since they are the storage format rather than the interface.

## Regenerating the tabulated data

The `update/` directory holds maintainer scripts that refresh the tabulated data
from its upstream sources.  They are **not** part of the package module: they are
run by hand from the repository root and rewrite files in `src/` in place, so
their output should be reviewed as a diff and committed like any other change.

| Script | Refreshes | Upstream |
|--------|-----------|----------|
| `update/update_constants.jl` | the per-release constant files | NIST CODATA tables |
| `update/update_pion_mass.jl` | the pion masses | PDG API |
| `update/update_isos.jl` | isotope masses in `ATOMIC_SPECIES` | NIST compositions table |
| `update/update_spins.jl` | nuclear spins in `ATOMIC_SPECIES` | NUBASE2020 |

`update_spins.jl` downloads `nubase_4.mas20.txt`, keeps the ground state of each
nuclide (isomer index `0`), parses the `Jpi` column, and rewrites the
`ATOMIC_SPECIES` literal with sorted keys.  Sorting is what makes it
deterministic: `Dict` iteration order is not stable across rebuilds, so an
unsorted emission would produce a large spurious diff.  Re-running it against
unchanged NUBASE data is a no-op.

NUBASE flags each spin assignment as directly measured, tentative (parenthesised),
or extrapolated from systematics (`#`).  The package stores all three alike; only
assignments NUBASE leaves blank become `NaN`.  Every naturally occurring isotope
has a directly measured spin, so this distinction affects exotic nuclei only.

!!! warning "`update_isos.jl` is out of date"
    It constructs `AtomicSpecies` with three positional arguments and writes a
    table with no `spin` field, both of which predate the nuclear-spin data.
    Running it as-is will fail, and its writer would drop the spin dictionaries.
    It needs updating before the isotope masses are next refreshed.

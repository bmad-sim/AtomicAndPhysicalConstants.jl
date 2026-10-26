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
setting, read once at precompile time.  When it is not set, the most recent
release in `CODATA_MAP` is used:

```julia
const _LATEST_RELEASE::String = string(maximum(parse.(Int, keys(CODATA_MAP))))
const release::String = @load_preference("release", _LATEST_RELEASE)
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
They need network access to the upstream sources.

### Setup

Like `docs/` and `test/`, `update/` has its own environment.  Its
`Project.toml` points at the package in the repository root through
`[sources]`, which needs Julia 1.11 or later.  Set it up once, and again after
its dependencies change:

```bash
julia --project=update -e 'using Pkg; Pkg.instantiate()'
```

### Scripts

Each script is run from the repository root as
`julia --project=update update/<script>.jl [arguments]`.

| Script | Arguments | Rewrites | Upstream |
|--------|-----------|----------|----------|
| `update_constants.jl` | `<year>`, `--force`, `--db <file>` | `src/CODATA<year>.jl`, and registers it in `src/AtomicAndPhysicalConstants.jl` | NIST CODATA tables; PDG `pdgall` database |
| `update_pion_mass.jl` | `--db <file>` | the pion mass lines of every `src/CODATA<year>.jl` | PDG `pdgall` database |
| `update_isos.jl` | none | isotope masses in `ATOMIC_SPECIES` (`src/species_data.jl`) | NIST atomic weights and isotopic compositions |
| `update_spins.jl` | none | nuclear spins in `ATOMIC_SPECIES` | NUBASE2020 |

- `<year>`: the CODATA release to write.
- `--force`: overwrite an existing `src/CODATA<year>.jl`; without it the script
  refuses.
- `--db <file>`: a local copy of PDG's `pdgall` SQLite database, to skip
  downloading it (about 70 MB).

Each script prints what it read and what it changed.  Run against unchanged
upstream data, each leaves `src/` as it was; `update_constants.jl <year> --force`
rewrites the file identically.  Two files hold code the scripts share and are
not run on their own: `update/release_files.jl` (used by `update_constants.jl`
and `update_pion_mass.jl`) and `update/species_table.jl` (used by
`update_isos.jl` and `update_spins.jl`).

After any script, run the test suite:

```bash
julia --project=. -e 'using Pkg; Pkg.test()'
```

### Adding a CODATA release

1. Run `julia --project=update update/update_constants.jl <year>`.  If NIST
   has not yet published that release, it stops with an error saying so.
2. The script writes `src/CODATA<year>.jl` and adds the release to the include
   list, `CODATA_MAP`, and the exports.  If it is the most recent release, it
   is now the default for every environment that has not set one with
   [`set_release`](@ref).
3. Make the edits the script lists at the end.  They cover the tests (the set
   of release years, the pion and untabulated tables, and, for a new most
   recent release, the default values the tests check) and the docs (the
   release tables here and in the README, the docstrings that list releases,
   and the "currently" default year).
4. Run the test suite and review the diff.

### The CODATA values

`update_constants.jl` reads NIST's ASCII table for the requested year.  NIST
serves the newest release at `Table/allascii.txt` and moves it to
`ArchiveASCII/allascii_<year>.txt` once a newer one is published, so the
archive is tried first, and the current table is accepted only if its header
names the requested year.  NIST renamed several quantities between releases;
the script knows each name a quantity has had, and writes `NaN` for one a
release does not tabulate under any of them (see
[Quantities missing from a release](@ref)).  Masses are read from NIST's
"energy equivalent in MeV" rows and the decimal point is moved to eV, which is
exact.  An exact value NIST prints truncated (marked `...`) is computed from
the release's defining constants instead, by the `EXACT` rules in the script.

### Pion masses

Each release file carries the pion masses of the PDG edition of the same
year.  The PDG REST API serves only the current edition, so both
`update_constants.jl` and `update_pion_mass.jl` read PDG's `pdgall` SQLite
database instead, which holds the Summary Table values of every past edition.
Unless `--db` names a local copy, either script downloads the newest database
listed at <https://pdg.lbl.gov/api>, and reads it with SQLite.jl.

`update_constants.jl` sets the pion masses of each release file it writes.
`update_pion_mass.jl` rewrites only the `M_PION_0` and `M_PION_CHARGED` lines
of every existing release file, which is needed only if PDG revises a past
edition.  Both store PDG's fit value rather than the rounded Summary Table
number, moved from MeV to eV.

### Isotope masses and nuclear spins

`update_isos.jl` and `update_spins.jl` rewrite the same `ATOMIC_SPECIES` literal, each replacing only the
half it owns, so they can be run independently and in either order.  They share
`update/species_table.jl`, which parses the literal and emits it again with
sorted keys.  Sorting is what makes them deterministic: `Dict` iteration order is
not stable across rebuilds, so an unsorted emission would reshuffle the whole
table and bury the real change.  Re-running either against unchanged upstream
data is a no-op.

The mass numbers are NIST's: `update_isos.jl` is the script that adds or removes
an isotope.  An isotope it adds arrives with a spin of `NaN`, and it says so —
run `update_spins.jl` afterwards to fill the new entries in.  It also keeps the
package's atomic symbols rather than NIST's, which names hydrogen's heavy
isotopes `D` and `T`.

`update_spins.jl` downloads `nubase_4.mas20.txt`, keeps the ground state of each
nuclide (isomer index `0`), and parses the `Jpi` column.  NUBASE flags each
assignment as directly measured, tentative (parenthesised), or extrapolated from
systematics (`#`).  The package stores all three alike; only assignments NUBASE
leaves blank or ambiguous become `NaN`.  Every naturally occurring isotope has a
directly measured spin, so this distinction affects exotic nuclei only.

The NUBASE edition is fixed by `NUBASE_URL` in `update_spins.jl`, currently
NUBASE2020; using a later edition means changing that URL.

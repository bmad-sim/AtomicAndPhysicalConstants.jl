# ─────────────────────────────────────────────────────────────────────────────
# Improved docstrings for AtomicAndPhysicalConstants.jl
#
# These are meant to REPLACE the existing thin docstrings in the source files.
# Each block is marked with the file it belongs in.
# ─────────────────────────────────────────────────────────────────────────────


# ═══════════════════════════════════════════════════════════════════════
# FILE: src/types.jl
# ═══════════════════════════════════════════════════════════════════════

# ── Species (replace the empty `""" """` above the struct) ──────────────────

"""
    Species

Immutable struct representing a physical particle species (subatomic particle,
ion, or neutral atom).

# Fields

| Field | Type | Description |
|-------|------|-------------|
| `name` | `String` | Particle name (openPMD identifier for subatomic; atomic symbol for atoms) |
| `charge` | `Int` | Net charge in units of elementary charge *e* |
| `mass` | `Float64` | Rest mass in eV/c² |
| `spin` | `Float64` | Spin in units of ħ |
| `gspin` | `Float64` | Spin g-factor (0 for atoms) |
| `moment` | `Float64` | Magnetic dipole moment in eV/T (0 for atoms) |
| `iso` | `Int` | Mass number for atomic isotopes; −1 for abundance-averaged atomic mass; 0 for subatomic particles |
| `kind` | `Kind.T` | Particle classification: `LEPTON`, `HADRON`, `PHOTON`, `ATOM`, or `NULL` |

Direct field access is disabled; use the accessor functions
[`chargeof`](@ref), [`massof`](@ref), [`spinof`](@ref), [`gspin_of`](@ref),
[`momentof`](@ref), [`iso_of`](@ref), [`atomicnumberof`](@ref),
[`kindof`](@ref), [`isnullspecies`](@ref), and [`Base.nameof`](@ref).

See also: [`Species(::String)`](@ref) for the string constructor.
"""
Species  # (place this above the struct definition)


# ── SubatomicSpecies ─────────────────────────────────────────────────────────

"""
    SubatomicSpecies

Internal struct storing intrinsic data for a single subatomic particle.
Instances are stored in [`SUBATOMIC_SPECIES`](@ref).

# Fields

- `speciesname::String` — openPMD particle identifier.
- `charge::Int` — charge in units of *e*.
- `mass::Float64` — mass in eV/c².
- `moment::Float64` — magnetic dipole moment in eV/T.
- `spin::Float64` — spin in ħ.
- `gspin::Float64` — spin g-factor.
"""
SubatomicSpecies


# ── AtomicSpecies ─────────────────────────────────────────────────────────────

"""
    AtomicSpecies

Internal struct storing isotope mass data for a chemical element.
Instances are stored in [`ATOMIC_SPECIES`](@ref).

# Fields

- `Z::Int` — atomic number (number of protons).
- `speciesname::String` — standard atomic symbol (*e.g.* `"Fe"`).
- `mass::Dict{Int,Float64}` — isotope masses in atomic mass units (u), keyed by
  mass number.  The special key `−1` holds the abundance-averaged atomic mass.
"""
AtomicSpecies


# ── CODATA_release ────────────────────────────────────────────────────────────

"""
    CODATA_release

Keyword-argument struct holding all fundamental constants from one CODATA
release year.  Fields mirror the exported scalar constants
([`M_ELECTRON`](@ref), [`C_LIGHT`](@ref), *etc.*) but are grouped together so
that multiple release years can coexist in memory simultaneously.

Pre-built instances are exported as [`CODATA2002`](@ref), [`CODATA2006`](@ref),
[`CODATA2010`](@ref), [`CODATA2014`](@ref), [`CODATA2018`](@ref), and
[`CODATA2022`](@ref).

```julia
CODATA2018.M_ELECTRON   # electron mass from the 2018 release
CODATA2014.C_LIGHT      # speed of light from the 2014 release
```
"""
CODATA_release


# ═══════════════════════════════════════════════════════════════════════
# FILE: src/functions.jl
# ═══════════════════════════════════════════════════════════════════════

# ── nameof ───────────────────────────────────────────────────────────────────

"""
    nameof(species::Species) -> String

Return the canonical name of `species`.

For subatomic particles the openPMD name is returned unchanged.
For atomic species the name is assembled from the atomic symbol, mass number
(if a specific isotope was requested), and charge state, using the `#mAS±c`
convention:

```julia
nameof(Species("electron"))   # "electron"
nameof(Species("Fe"))         # "Fe"
nameof(Species("4He+2"))      # "#4He+2"
nameof(Species("Li+"))        # "Li+1"
```
"""
Base.nameof(::Species)


# ── chargeof ─────────────────────────────────────────────────────────────────

"""
    chargeof(species::Species; C::Bool = false) -> Union{Int, Float64}

Return the net charge of `species`.

By default the charge is returned as an integer multiple of the elementary
charge *e*.  Pass `C = true` to convert to coulombs using the active
[`E_CHARGE`](@ref) constant.

# Examples

```julia
chargeof(Species("proton"))       # 1
chargeof(Species("electron"))     # -1
chargeof(Species("Li+3"))         # 3
chargeof(Species("proton"), C=true)   # ≈ 1.602176634e-19
```
"""
chargeof


# ── massof ───────────────────────────────────────────────────────────────────

"""
    massof(species::Species; AMU::Bool = false) -> Float64

Return the rest mass of `species`.

By default the mass is returned in **eV/c²**.  Pass `AMU = true` to return the
mass in atomic mass units (daltons), which is particularly convenient for
atomic species.

# Examples

```julia
massof(Species("electron"))              # 510998.95069  eV/c²
massof(Species("proton"))               # 9.38272089430e8  eV/c²
massof(Species("H"), AMU = true)        # ≈ 1.00794  u
massof(Species("4He"), AMU = true)      # ≈ 4.0026  u
```
"""
massof


# ── spinof ───────────────────────────────────────────────────────────────────

"""
    spinof(species::Species) -> Float64

Return the spin of `species` in units of the reduced Planck constant ħ.

# Examples

```julia
spinof(Species("electron"))    # 0.5
spinof(Species("proton"))      # 0.5
spinof(Species("photon"))      # 1.0
```
"""
spinof


# ── gspin_of ─────────────────────────────────────────────────────────────────

"""
    gspin_of(species::Species; signed::Bool = false) -> Float64

Return the spin g-factor of `species`.

By default the absolute value is returned.  Pass `signed = true` to get the
signed g-factor (negative for particles with a negative gyromagnetic ratio,
such as the electron).

Returns 0 for atomic species, for which no g-factor is stored.

# Examples

```julia
gspin_of(Species("electron"))               # 2.00231930436092
gspin_of(Species("electron"), signed=true)  # -2.00231930436092
gspin_of(Species("proton"))                 # 5.5856946893
gspin_of(Species("H"))                      # 0.0
```
"""
gspin_of


# ── gyromagnetic_anomaly ──────────────────────────────────────────────────────

"""
    gyromagnetic_anomaly(species::Species) -> Float64

Compute and return the gyromagnetic anomaly

```math
a = \\frac{g - 2}{2}
```

for leptons and hadrons.  Returns 0 for photons, atoms, and null species.

# Examples

```julia
gyromagnetic_anomaly(Species("electron"))   # ≈  0.00115965218046
gyromagnetic_anomaly(Species("muon"))       # ≈  0.00116592062
gyromagnetic_anomaly(Species("H"))          # 0.0
```
"""
gyromagnetic_anomaly


# ── momentof ─────────────────────────────────────────────────────────────────

"""
    momentof(species::Species) -> Float64

Return the magnetic dipole moment of `species` in **eV/T**.

Returns 0 for atomic species and the null species (no moment is stored for
these types).

# Examples

```julia
momentof(Species("electron"))   # ≈ -5.7883818060e-5  eV/T
momentof(Species("proton"))     # ≈  8.8043151136e-8  eV/T
momentof(Species("H"))          # 0.0
```
"""
momentof


# ── iso_of ───────────────────────────────────────────────────────────────────

"""
    iso_of(species::Species) -> Int

Return the mass number (isotope) of `species`.

- For atomic species: the mass number of the requested isotope, or `−1` if the
  abundance-averaged atomic mass was used.
- For subatomic particles: always `0`.

# Examples

```julia
iso_of(Species("3He"))          # 3
iso_of(Species("He"))           # -1  (abundance average)
iso_of(Species("electron"))     # 0
```
"""
iso_of


# ── atomicnumberof ────────────────────────────────────────────────────────────

"""
    atomicnumberof(species::Species) -> Int

Return the atomic number (number of protons) of `species`.

Throws an error if `species` is not of kind `ATOM`.

# Examples

```julia
atomicnumberof(Species("Fe"))       # 26
atomicnumberof(Species("H+"))       # 1
atomicnumberof(Species("electron")) # ERROR
```
"""
atomicnumberof


# ── kindof ───────────────────────────────────────────────────────────────────

"""
    kindof(species::Species) -> Kind.T

Return the particle classification of `species` as a `Kind.T` enum value.

Possible values: `Kind.LEPTON`, `Kind.HADRON`, `Kind.PHOTON`, `Kind.ATOM`,
`Kind.NULL`.

# Examples

```julia
kindof(Species("electron"))    # Kind.LEPTON
kindof(Species("proton"))      # Kind.HADRON
kindof(Species("H"))           # Kind.ATOM
kindof(Species("photon"))      # Kind.PHOTON
kindof(Species())              # Kind.NULL
```
"""
kindof


# ── isnullspecies ─────────────────────────────────────────────────────────────

"""
    isnullspecies(species::Species) -> Bool

Return `true` if `species` is a null (placeholder) species, `false` otherwise.

```julia
isnullspecies(Species())           # true
isnullspecies(Species("null"))     # true
isnullspecies(Species("proton"))   # false
```
"""
isnullspecies


# ── set_release ───────────────────────────────────────────────────────────────

"""
    set_release(; year::String = "2022")

Persistently set the CODATA release year used by AtomicAndPhysicalConstants.jl.

The setting is stored via [Preferences.jl](https://github.com/JuliaPackaging/Preferences.jl)
in the active Julia environment and survives across sessions.  A Julia restart
is required for the new constants to take effect.

Valid values for `year`: `"2002"`, `"2006"`, `"2010"`, `"2014"`, `"2018"`,
`"2022"`.  Calling with no arguments resets to the default (`"2022"`).

# Examples

```julia
set_release(year = "2014")
# [ Info: The default CODATA release is now 2014.
#         Restart your Julia session for this change to take effect.

set_release()   # revert to 2022
```

See also: [`RELEASE_YEAR`](@ref).
"""
set_release


# ═══════════════════════════════════════════════════════════════════════
# FILE: src/species_data.jl
# ═══════════════════════════════════════════════════════════════════════

"""
    SUBATOMIC_SPECIES :: Dict{String, SubatomicSpecies}

Dictionary of all supported subatomic particles, keyed by openPMD name.

Supported keys: `"electron"`, `"positron"`, `"proton"`, `"anti-proton"`,
`"neutron"`, `"anti-neutron"`, `"muon"`, `"anti-muon"`, `"pion0"`, `"pion+"`,
`"pion-"`, `"deuteron"`, `"anti-deuteron"`, `"photon"`.
"""
SUBATOMIC_SPECIES

"""
    ATOMIC_SPECIES :: Dict{String, AtomicSpecies}

Dictionary of all supported atomic elements (Z = 1 … 118), keyed by atomic
symbol (*e.g.* `"H"`, `"Fe"`, `"Og"`).  Each value is an [`AtomicSpecies`](@ref)
struct containing the atomic number, symbol, and a dictionary of isotope masses
in atomic mass units.
"""
ATOMIC_SPECIES


# ═══════════════════════════════════════════════════════════════════════
# FILE: src/CODATA20XX.jl  (add above each const in CODATA2022.jl etc.)
# ═══════════════════════════════════════════════════════════════════════

"""
    CODATA2022 :: CODATA_release

Fundamental constants from the 2022 CODATA release.
This is the default release used when no preference has been set.

See [NIST 2022 CODATA](https://physics.nist.gov/cuu/Constants/) for the
primary source values.
"""
CODATA2022

"""
    CODATA2018 :: CODATA_release

Fundamental constants from the 2018 CODATA release.
"""
CODATA2018

"""
    CODATA2014 :: CODATA_release

Fundamental constants from the 2014 CODATA release.
"""
CODATA2014

"""
    CODATA2010 :: CODATA_release

Fundamental constants from the 2010 CODATA release.
First release to include `G_HELION`, `ANOMALY_ELECTRON`, and `ANOMALY_MUON`.
"""
CODATA2010

"""
    CODATA2006 :: CODATA_release

Fundamental constants from the 2006 CODATA release.
"""
CODATA2006

"""
    CODATA2002 :: CODATA_release

Fundamental constants from the 2002 CODATA release (earliest supported).
"""
CODATA2002

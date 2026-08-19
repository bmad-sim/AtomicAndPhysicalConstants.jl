# [Species](@id man-species)

A [`Species`](@ref) is the central data structure of AtomicAndPhysicalConstants.jl.
It bundles all intrinsic properties of a particle — mass, charge, spin, magnetic
moment, and particle kind — into a single immutable object.

## Constructing a species

All species are created with the single-string constructor

```julia
Species(speciesname::String)
```

The string format encodes the particle identity, isotope (for atoms), and charge
state in one compact expression.

### Subatomic particles

Pass the openPMD particle name exactly as it appears in the table below.

| String | Particle |
|--------|----------|
| `"electron"` | electron |
| `"positron"` | positron |
| `"proton"` | proton |
| `"anti-proton"` | antiproton |
| `"neutron"` | neutron |
| `"anti-neutron"` | antineutron |
| `"muon"` | muon (μ⁻) |
| `"anti-muon"` | antimuon (μ⁺) |
| `"pion0"` | neutral pion |
| `"pion+"` | positive pion |
| `"pion-"` | negative pion |
| `"deuteron"` | deuteron |
| `"anti-deuteron"` | antideuteron |
| `"triton"` | triton |
| `"anti-triton"` | antitriton |
| `"helion"` | helion |
| `"anti-helion"` | antihelion |
| `"photon"` | photon |

```julia
e  = Species("electron")
mu = Species("muon")
pi0 = Species("pion0")
```

### Atomic species

Atomic symbols from `"H"` (Z = 1) through `"Og"` (Z = 118) are supported.

The full format for an atomic species string is:

```
[mass_number] symbol [charge]
```

where both `mass_number` and `charge` are optional.

**Mass number** — when given as ASCII digits it must be preceded by `#`; it may
also be written with Unicode superscript digits (no `#` needed). A bare ASCII
mass number such as `"4He"` is **not** accepted:

```julia
Species("He")    # helium, abundance-averaged mass
Species("#4He")  # helium-4  (# prefix is required for ASCII digits)
Species("⁴He")   # helium-4  (Unicode superscript)
```

**Charge state** — appended after the symbol:

| Syntax | Meaning |
|--------|---------|
| `"Li+"` | +1 |
| `"Li++"` | +2 |
| `"Li+++"` | +3 |
| `"Li+3"` | +3 |
| `"K-"` | −1 |
| `"K--"` | −2 |
| `"K-3"` | −3 |
| `"N⁻³"` | −3 (Unicode superscript magnitude) |

Up to three repeated `+` or `-` signs are accepted; for larger charges use the
`+n` / `-n` form.

```julia
Species("Li+++") == Species("Li+3")   # true
Species("K---")  == Species("K-3")    # true
```

### Anti-atoms

Prepend `"anti-"` to any atomic symbol:

```julia
Species("anti-H")   # antihydrogen
Species("anti-Fe")  # anti-iron
```

### Null species

A null (placeholder) species is created with no arguments or with the strings
`"Null"`, `"null"`, or `""`:

```julia
Species()        # null species
Species("null")  # also null
```

Use [`isnullspecies`](@ref) to test for a null species.

---

## [Accessing species parameters](@id man-species-accessors)

A `Species` is immutable, and its fields are deliberately **not** reachable with
dot syntax.  Every property is read through an accessor function instead, which
keeps the unit conventions and the special cases below in one place:

```julia
p = Species("proton")

p.mass        # ERROR — dot access is disabled
massof(p)     # 9.3827208943e8   eV/c²
```

### Quick reference

Three of the accessors take a keyword argument that switches the unit or sign
convention; the signatures below show its default.  `sp` is any `Species`.

| Function | Returns | Units / convention |
|----------|---------|--------------------|
| [`nameof(sp)`](@ref Base.nameof(::Species)) | canonical species name | `String`, in the `#mAS±c` form |
| [`massof(sp; AMU = false)`](@ref massof) | rest mass | eV/c², or atomic mass units (daltons) with `AMU = true` |
| [`chargeof(sp; C = false)`](@ref chargeof) | net charge | multiples of the elementary charge *e*, or coulombs with `C = true`, using the active [`E_CHARGE`](@ref) |
| [`spinof(sp)`](@ref spinof) | spin; for an atom, the **nuclear** spin | ħ |
| [`momentof(sp)`](@ref momentof) | magnetic dipole moment | eV/T |
| [`g_spin(sp; signed = false)`](@ref g_spin) | spin g-factor | dimensionless \|g\|, or the signed value with `signed = true` (negative for the electron, muon, neutron, and helion) |
| [`gyromagnetic_anomaly(sp)`](@ref gyromagnetic_anomaly) | gyromagnetic anomaly *a* | dimensionless |
| [`iso_of(sp)`](@ref iso_of) | mass number | integer |
| [`atomicnumberof(sp)`](@ref atomicnumberof) | atomic number *Z* | integer, negative for anti-atoms |
| [`kindof(sp)`](@ref kindof) | particle classification | [`Kind.T`](@ref AtomicAndPhysicalConstants.Kind) enum value |
| [`isnullspecies(sp)`](@ref isnullspecies) | whether the species is a placeholder | `Bool` |

All of the numeric accessors return `Float64` except [`iso_of`](@ref) and
[`atomicnumberof`](@ref), which return `Int`.

[`gyromagnetic_anomaly`](@ref) is built on the *unsigned* g-factor, so
``a = (|g| - 2)/2`` comes out positive for the particles whose stored g-factor
is negative.  See [Physical Constants](@ref man-constants) for why the deuteron,
helion, and triton g-factors are renormalized before this formula is applied.

### Species that do not carry a given property

Not every property is defined for every kind of particle.  Rather than erroring,
most accessors return a neutral value:

| Function | Outside its domain |
|----------|--------------------|
| [`momentof`](@ref) | `0.0` for atoms and the null species |
| [`g_spin`](@ref) | `0.0` for atomic species (no g-factor is stored) |
| [`gyromagnetic_anomaly`](@ref) | `NaN` for photons, atoms, and the null species |
| [`spinof`](@ref) | `NaN` for an atom given without a mass number, and for the few isotopes NUBASE leaves unassigned |
| [`iso_of`](@ref) | `0` for subatomic particles; `-1` for an atom given without a mass number |
| [`atomicnumberof`](@ref) | **throws an error** for anything that is not an atom |

### Nuclear spin

For an atomic species, [`spinof`](@ref) returns the **nuclear** spin, from the
tabulated ground-state values of
[NUBASE2020](https://www-nds.iaea.org/amdc/).  Electron spin is not included,
since the total angular momentum of an atom depends on its electronic state,
which `Species` does not model.  Two consequences follow: ionising an atom does
not change its spin, and an anti-nucleus has the same spin as its mirror.

Nuclear spin is **not** a function of the mass number.  Nucleons pair off with
opposite spins, so every even-even nucleus has spin 0 and no closed formula in
*A* reproduces the tabulated values:

```jldoctest species-accessors
julia> using AtomicAndPhysicalConstants

julia> spinof(Species("#4He"))    # even-even: two paired protons, two paired neutrons
0.0

julia> spinof(Species("#3He"))    # one unpaired neutron
0.5

julia> spinof(Species("#12C"))
0.0

julia> spinof(Species("#235U"))
3.5
```

An atom given without a mass number has no single nuclear spin — the abundance
average runs over isotopes with differing spins — so `NaN` is returned:

```jldoctest species-accessors
julia> spinof(Species("He"))
NaN
```

Every isotope that occurs naturally has a directly measured spin.  For nuclei
far from stability the tabulated value may come from NUBASE systematics, and a
small number of exotic isotopes carry no unambiguous assignment at all; those
also return `NaN`.

### Worked example

```jldoctest species-accessors
julia> using AtomicAndPhysicalConstants

julia> e = Species("electron");

julia> massof(e)            # eV/c²
510998.95069

julia> chargeof(e)          # units of e
-1.0

julia> spinof(e)            # ħ
0.5

julia> g_spin(e)            # absolute value by default
2.00231930436092

julia> g_spin(e, signed = true)
-2.00231930436092

julia> gyromagnetic_anomaly(e)
0.0011596521804599913

julia> momentof(e)          # eV/T
-5.795094307320036e-5
```

Atomic species carry a mass number and an atomic number, and their mass is often
more convenient in daltons:

```jldoctest species-accessors
julia> he3 = Species("#3He");

julia> massof(he3, AMU = true)
3.0160293201

julia> iso_of(he3)
3

julia> atomicnumberof(he3)
2

julia> iso_of(Species("He"))   # abundance-averaged, no specific isotope
-1

julia> nameof(Species("Li+"))
"Li+1"
```

The full docstring of each accessor is in the
[API Reference](@ref api-accessors).

---

## The `Kind` enum

Every species carries a `kind` field of type `Kind.T` (provided by
[EnumX.jl](https://github.com/fredrikekre/EnumX.jl)):

| Value | Meaning |
|-------|---------|
| `Kind.LEPTON` | electron, positron, muon, anti-muon |
| `Kind.HADRON` | proton, neutron, pions, deuteron, … |
| `Kind.PHOTON` | photon |
| `Kind.ATOM` | any atomic / ionic species |
| `Kind.NULL` | null / placeholder species |

```julia
kindof(Species("electron")) == Kind.LEPTON   # true
kindof(Species("Fe"))       == Kind.ATOM     # true
```

---

## Going further

The tables behind the constructor — isotope masses and nuclear spins — are
exported as dictionaries, and the sources they are drawn from are described in
[Internals](@ref man-internals-dicts).

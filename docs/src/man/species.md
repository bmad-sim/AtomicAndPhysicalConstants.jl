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

## Accessor functions
See the [API Reference](@ref) for full docstrings of all accessor functions.

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

## Internal data dictionaries

Two dictionaries back the species constructor and are exported for
advanced use.

See the [API Reference](@ref) for full docstrings of all internal reference dictionaries.

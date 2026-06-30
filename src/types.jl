# AtomicAndPhysicalConstants/src/types.jl

# This module defines the core data structures used in APClite.
"""
    Species(speciesname::String)
    Species()

Construct a particle species by name, or a null placeholder with no arguments.

The string format encodes particle identity, isotope (for atoms), and charge
state in one expression: `[mass_number] symbol [charge]`.

# Subatomic particles

Pass the openPMD name exactly:

| Name | Particle |
|------|----------|
| `"electron"` / `"positron"` | electron / positron |
| `"proton"` / `"anti-proton"` | proton / antiproton |
| `"neutron"` / `"anti-neutron"` | neutron / antineutron |
| `"muon"` / `"anti-muon"` | muon / antimuon |
| `"pion0"` / `"pion+"` / `"pion-"` | pions |
| `"deuteron"` / `"anti-deuteron"` | deuteron / antideuteron |
| `"photon"` | photon |

# Atomic species

Atomic symbols `"H"` (Z=1) through `"Og"` (Z=118) are supported.

**Mass number** — prefix the symbol with ASCII digits, `#`-prefixed digits, or
Unicode superscripts. Omit for the abundance-averaged mass.

**Charge state** — append after the symbol. Repeated signs (`"++"`, `"---"`)
or `"+n"` / `"-n"` notation are both accepted.

```julia
Species("4He")      # helium-4, neutral
Species("⁴He")      # same, Unicode superscript
Species("#4He")     # same, # prefix
Species("Li+3")     # lithium, charge +3
Species("Li+++")    # same
Species("K-2")      # potassium, charge −2
```

**Anti-atoms**: prepend `"anti-"` to any atomic symbol.

```julia
Species("anti-H")   # antihydrogen
```

**Null species**: `Species()`, or names `"Null"`, `"null"`, `""`.

# Fields

| Field | Type | Description |
|-------|------|-------------|
| `name` | `String` | Particle name or atomic symbol |
| `charge` | `Float64` | Net charge in units of *e* |
| `mass` | `Float64` | Rest mass in eV/c² |
| `spin` | `Float64` | Spin in ħ |
| `gspin` | `Float64` | Spin g-factor (0 for atoms) |
| `moment` | `Float64` | Magnetic dipole moment in eV/T (0 for atoms) |
| `iso` | `Int` | Mass number; −1 for abundance average; 0 for subatomic particles |
| `kind` | `Kind.T` | `LEPTON`, `HADRON`, `PHOTON`, `ATOM`, or `NULL` |

Direct field access is disabled. Use [`chargeof`](@ref), [`massof`](@ref),
[`spinof`](@ref), [`gspin_of`](@ref), [`momentof`](@ref), [`iso_of`](@ref),
[`atomicnumberof`](@ref), [`kindof`](@ref), [`isnullspecies`](@ref),
[`Base.nameof`](@ref).
"""
struct Species
  name::String # name of the particle to track
  charge::Float64 # charge of the particle (important to consider ionized atoms) in [e]
  mass::Float64 # mass of the particle in [eV/c^2]
  spin::Float64 # spin of the particle in [ħ]
  gspin::Float64 # gyromagnetic factor (if particle is subatomic, otherwise 0)
  moment::Float64 # magnetic moment of the particle (for now it's 0 unless we have a recorded value)
  iso::Int # if the particle is an atomic isotope this is the mass number, otherwise 0
  kind::Kind.T

  function Species(name::String, charge::Real, mass::Float64, spin::Float64, gspin::Float64, moment::Float64, iso::Int, kind::Kind.T)
    new(name, Float64(charge), mass, spin, gspin, moment, iso, kind)
  end


  # null constructor
  Species() = new("Null", 0.0, 0.0, 0.0, 0.0, 0.0, 0, Kind.NULL)
end;



@doc """
    SubatomicSpecies

Internal struct storing intrinsic data for a single subatomic particle.
Instances are stored in [`SUBATOMIC_SPECIES`](@ref).

# Fields

- `speciesname::String` — openPMD particle identifier.
- `charge::Float64` — charge in units of *e*.
- `mass::Float64` — mass in eV/c².
- `moment::Float64` — magnetic dipole moment in eV/T.
- `spin::Float64` — spin in ħ.
- `gspin::Float64` — spin g-factor.
"""
struct SubatomicSpecies
  speciesname::String  # common species_name of the particle
  charge::Float64 # charge on the particle in e
  mass::Float64 # mass of the particle in [eV/c^2]
  moment::Float64 # magnetic moment in eV/T
  spin::Float64 # spin magnetic moment in [ħ]
  gspin::Float64
end;



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
struct AtomicSpecies
  Z::Int  # atomic number
  speciesname::String  # periodic table element symbol
  mass::Dict{Int,Float64}  # a dict to store the masses, keyed by isotope all masses in amu
  #=
  keyvalue -1 => average mass of common isotopes [amu],
  keyvalue n ∈ {0} ∪ N is the mass number of the isotope
  	=> mass of that isotope [amu]
  =#
end;



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
@kwdef struct CODATA_release

  #######################################
  # constants with dimension [mass]
  #######################################


  M_ELECTRON::Float64
  # Electron Mass [MeV]/c^2
  M_PROTON::Float64
  # Proton Mass [MeV]/c^2
  M_NEUTRON::Float64
  # Neutron Mass [MeV]/c^2
  M_MUON::Float64
  # Muon Mass [MeV]/c^2
  M_HELION::Float64
  # Helion Mass He3 nucleus [MeV]/c^2
  M_DEUTERON::Float64
  # Deuteron Mass [MeV]/c^2

  # constants mysteriously missing from the release
  # picked up from PDG
  M_PION_0::Float64
  # uncharged pion mass [eV]/c^2
  M_PION_CHARGED::Float64
  # charged pion mass [eV]/c^2


  #######################################
  # constants with dimension [magnetic moment]
  #######################################


  MU_DEUTERON::Float64
  # deuteron magnetic moment in [J/T]
  MU_ELECTRON::Float64
  # electron magnetic moment in [J/T]
  MU_HELION::Float64
  # helion magnetic moment in [J/T]
  MU_MUON::Float64
  # muon magnetic moment in [J/T]
  MU_NEUTRON::Float64
  # neutron magnetic moment in [J/T]
  MU_PROTON::Float64
  # proton magnetic moment in [J/T]
  MU_TRITON::Float64
  # triton magnetic moment in [J/T]


  #######################################
  # dimensionless constants
  #######################################


  AVOGADRO::Float64
  # Avogadro's constant: Number / mole (exact)
  FINE_STRUCTURE::Float64
  # fine structure constant

  ANOMALY_ELECTRON::Float64
  # electron magnetic moment anomaly
  ANOMALY_MUON::Float64
  # muon magnetic moment anomaly

  G_DEUTERON::Float64
  # deuteron g factor 
  G_ELECTRON::Float64
  # electron g factor 
  G_HELION::Float64
  # helion g factor 
  G_MUON::Float64
  # muon g factor 
  G_NEUTRON::Float64
  # neutron g factor 
  G_PROTON::Float64
  # proton g factor 
  G_TRITON::Float64
  # triton g factor


  #######################################
  # constants with miscellaneous dimension
  #######################################

  E_CHARGE::Float64
  # elementary charge [C]
  R_ELECTRON::Float64
  # classical electron radius [m]
  R_PROTON::Float64
  # classical proton radius [m]
  C_LIGHT::Float64
  # speed of light [m/s]
  H_PLANCK::Float64
  # Planck's constant [J*s]
  H_BAR::Float64
  # h_planck/twopi [J*s]
  CLASSICAL_RADIUS_FACTOR::Float64
  # e^2 / (4 pi eps_0) = classical_radius*mass*c^2.
  # Is same for all particles of charge +/- 1.

  K_BOLTZMANN::Float64
  # Boltzmann factor k_B in eV/K

  EPS_0::Float64
  # Permittivity of free space in [F/m]
  MU_0::Float64
  # Vacuum permeability in [N/A^2] (newtons per ampere squared)


  #######################################
  # conversion_consts
  #######################################

  G_PER_AMU::Float64
  # grams per dalton
  EV_PER_AMU::Float64
  # electronvolts/c^2 per dalton
  J_PER_EV::Float64
  # Joules per electronvolt
  EV_PER_J::Float64
  # electronvolts per joule
  G_PER_EV::Float64
  # grams per electronvolt/c^2


  RELEASE_YEAR::Int
  # release year for posterity
end

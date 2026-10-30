# AtomicAndPhysicalConstants/src/units.jl
#
# Choosing the units that constants and `Species` quantities are reported in.
#
# The native system -- eV/c^2, eV, m, s, e, T, K, hbar -- is frozen.  The fields
# of `Species`, the one-argument accessors, and the constants exported by this
# module are always in it, because downstream code compiles against those exact
# values: Beamlines' energy/rigidity conversions are written for mass in eV/c^2
# and charge in e, and BeamTracking splices C_LIGHT and EPS_0*H_BAR*C_LIGHT into
# `@generated` kernels at compile time.  A unit choice is therefore a value the
# *caller* holds -- a `UnitSystem` of Float64 scale factors -- and never a piece
# of mutable global state inside this package.

#####################################################################
# UnitSystem
#####################################################################

"""
    UnitSystem(; mass, energy, length, time, charge, field, temperature, spin)

A choice of units, stored as the factors that convert the native
(accelerator-physics) system to it.

Each field is the number a native value is **multiplied** by.  The native system
is `mass` eV/c², `energy` eV, `length` m, `time` s, `charge` *e*, `field` T,
`temperature` K, `spin` ħ, so `UnitSystem()` is the identity, also available as
[`ACCELERATOR`](@ref).

Each keyword takes either the name of a unit as a `Symbol` or a bare positive
number used as the factor directly:

| Keyword | Accepted names |
|---------|----------------|
| `mass` | `:eV` (eV/c², native), `:keV`, `:MeV`, `:GeV`, `:TeV`, `:amu`, `:Da`, `:kg`, `:g` |
| `energy` | `:eV` (native), `:keV`, `:MeV`, `:GeV`, `:TeV`, `:J`, `:erg` |
| `length` | `:m` (native), `:km`, `:cm`, `:mm`, `:um`, `:μm`, `:nm` |
| `time` | `:s` (native), `:ms`, `:us`, `:μs`, `:ns`, `:ps`, `:fs` |
| `charge` | `:e` (native), `:C`, `:statC`, `:esu` |
| `field` | `:T` (native), `:mT`, `:kG`, `:G`, `:gauss` |
| `temperature` | `:K` (native), `:mK` |
| `spin` | `:hbar` (native), `:ħ`, `:Js`, `:erg_s` |

A mass given as `:GeV` means GeV/c²; the dimension already says it is a mass.
The conversions are built from the active CODATA release, so they follow
[`set_release`](@ref).

Dimensions that are not base units are derived, so there is no way to pick an
inconsistent pair: a magnetic moment is reported in `energy/field`, a velocity
in `length/time`, an action in `energy*time`.

Hold a system in a `const` binding. The scale factors then fold into the
machine code at the call site and cost nothing; a non-`const` global infers as
`Any` and costs about 100× more per access.

# Examples

```jldoctest
julia> const GeV_cm = UnitSystem(mass = :GeV, energy = :GeV, length = :cm);

julia> massof(Species("proton"), GeV_cm)
0.93827208943

julia> constants(GeV_cm).C_LIGHT
2.99792458e10

julia> massof(Species("proton"), MKS)        # kg
1.672621925953106e-27

julia> chargeof(Species("proton"), MKS)      # C
1.602176634e-19
```

See also [`constants`](@ref), [`@apc_units`](@ref), [`ACCELERATOR`](@ref),
[`MKS`](@ref), [`CGS`](@ref).
"""
struct UnitSystem
  mass::Float64
  energy::Float64
  length::Float64
  time::Float64
  charge::Float64
  field::Float64
  temperature::Float64
  spin::Float64
end

"""
    _UNIT_FACTORS

Named units this package knows, grouped by dimension.  Each value is the factor
that converts the native unit of that dimension to the named one, so the native
unit of each group has the value 1.

The entries built from [`J_PER_EV`](@ref), [`G_PER_EV`](@ref),
[`EV_PER_AMU`](@ref), [`E_CHARGE`](@ref), [`C_LIGHT`](@ref), and [`H_BAR`](@ref)
follow the active CODATA release.
"""
const _UNIT_FACTORS = (
  mass = (eV = 1.0, keV = 1e-3, MeV = 1e-6, GeV = 1e-9, TeV = 1e-12,
          amu = 1 / EV_PER_AMU, Da = 1 / EV_PER_AMU,
          kg = G_PER_EV * 1e-3, g = G_PER_EV),
  energy = (eV = 1.0, keV = 1e-3, MeV = 1e-6, GeV = 1e-9, TeV = 1e-12,
            J = J_PER_EV, erg = J_PER_EV * 1e7),
  length = (m = 1.0, km = 1e-3, cm = 1e2, mm = 1e3, um = 1e6, μm = 1e6, nm = 1e9),
  time = (s = 1.0, ms = 1e3, us = 1e6, μs = 1e6, ns = 1e9, ps = 1e12, fs = 1e15),
  # 1 C = 10*c statC, with c in m/s; the elementary charge is 1 in the native system.
  charge = (e = 1.0, C = E_CHARGE, statC = E_CHARGE * 10 * C_LIGHT, esu = E_CHARGE * 10 * C_LIGHT),
  field = (T = 1.0, mT = 1e3, kG = 1e1, G = 1e4, gauss = 1e4),
  temperature = (K = 1.0, mK = 1e3),
  spin = (hbar = 1.0, ħ = 1.0, Js = H_BAR * J_PER_EV, erg_s = H_BAR * J_PER_EV * 1e7),
)

"""
    _unitfactor(dim::Symbol, unit) -> Float64

Resolve `unit` -- a name from [`_UNIT_FACTORS`](@ref) or a bare positive number
-- into the factor that converts the native unit of dimension `dim` to it.
"""
function _unitfactor(dim::Symbol, unit::Symbol)
  table = _UNIT_FACTORS[dim]
  haskey(table, unit) && return Float64(table[unit])
  throw(ArgumentError("$unit is not a known unit of $dim; options are " *
                      join(keys(table), ", ") *
                      ", or a positive number giving the factor directly."))
end

function _unitfactor(dim::Symbol, unit::Real)
  isfinite(unit) && unit > 0 ||
    throw(ArgumentError("the $dim factor must be a positive finite number, got $unit."))
  return Float64(unit)
end

_unitfactor(dim::Symbol, unit) =
  throw(ArgumentError("the $dim unit must be a Symbol or a positive number, got $(typeof(unit))."))

function UnitSystem(; mass=:eV, energy=:eV, length=:m, time=:s,
  charge=:e, field=:T, temperature=:K, spin=:hbar)
  return UnitSystem(
    _unitfactor(:mass, mass),
    _unitfactor(:energy, energy),
    _unitfactor(:length, length),
    _unitfactor(:time, time),
    _unitfactor(:charge, charge),
    _unitfactor(:field, field),
    _unitfactor(:temperature, temperature),
    _unitfactor(:spin, spin))
end

function Base.show(io::IO, ::MIME"text/plain", u::UnitSystem)
  println(io, "UnitSystem (factors converting the native system to this one)")
  for f in fieldnames(UnitSystem)
    println(io, "  ", rpad(f, 12), getfield(u, f))
  end
end

#####################################################################
# Predefined systems
#####################################################################

"""
    ACCELERATOR::UnitSystem

The native system, in which every factor is 1: mass eV/c², energy eV, length m,
time s, charge *e*, magnetic field T, temperature K, spin ħ.

`massof(s, ACCELERATOR)` and `massof(s)` are the same number, and
`constants(ACCELERATOR)` holds the values this module exports.
"""
const ACCELERATOR = UnitSystem()

"""
    MKS::UnitSystem

SI: mass kg, energy J, length m, time s, charge C, magnetic field T,
temperature K.

Spin stays in ħ, since that is how spin is quoted whatever the rest of the
system; pass `spin = :Js` to a [`UnitSystem`](@ref) of your own to change it.
"""
const MKS = UnitSystem(mass=:kg, energy=:J, length=:m, time=:s,
  charge=:C, field=:T, temperature=:K, spin=:hbar)

"""
    SI::UnitSystem

An alias for [`MKS`](@ref).
"""
const SI = MKS

"""
    CGS::UnitSystem

Gaussian CGS: mass g, energy erg, length cm, time s, charge statC, magnetic
field gauss, temperature K.

Spin stays in ħ; pass `spin = :erg_s` to a [`UnitSystem`](@ref) of your own to
change it.
"""
const CGS = UnitSystem(mass=:g, energy=:erg, length=:cm, time=:s,
  charge=:statC, field=:gauss, temperature=:K, spin=:hbar)

#####################################################################
# Species accessors in a chosen system
#####################################################################

"""
    massof(species::Species, units::UnitSystem) -> Float64

Return the rest mass of `species` in `units`.

`massof(species)` on its own always returns eV/c².

```jldoctest
julia> massof(Species("proton"), MKS)
1.672621925953106e-27

julia> massof(Species("#4He"), UnitSystem(mass = :amu))
4.00260325413
```
"""
massof(species::Species, units::UnitSystem) = massof(species) * units.mass

"""
    chargeof(species::Species, units::UnitSystem) -> Float64

Return the net charge of `species` in `units`.

`chargeof(species)` on its own always returns a multiple of the elementary
charge.

```jldoctest
julia> chargeof(Species("Li+3"), MKS)
4.806529901999999e-19
```
"""
chargeof(species::Species, units::UnitSystem) = chargeof(species) * units.charge

"""
    momentof(species::Species, units::UnitSystem) -> Float64

Return the magnetic dipole moment of `species` in `units`, which reports it as
`energy/field`.

`momentof(species)` on its own always returns eV/T.

```jldoctest
julia> momentof(Species("proton"), MKS)       # J/T
1.4106067954499998e-26
```
"""
momentof(species::Species, units::UnitSystem) =
  momentof(species) * units.energy / units.field

"""
    spinof(species::Species, units::UnitSystem) -> Float64

Return the spin of `species` in `units`.

`spinof(species)` on its own always returns a multiple of ħ, as do all the
predefined systems; a `UnitSystem` built with `spin = :Js` reports it as an
action instead.

```jldoctest
julia> spinof(Species("electron"), UnitSystem(spin = :Js))
5.272859088230782e-35
```
"""
spinof(species::Species, units::UnitSystem) = spinof(species) * units.spin

"""
    g_spin(species::Species, units::UnitSystem; signed::Bool = false) -> Float64

Return the spin g-factor of `species`.  It is dimensionless, so `units` leaves
it unchanged; the method exists so that code generic over a `UnitSystem` can
call every accessor the same way.
"""
g_spin(species::Species, units::UnitSystem; signed::Bool=false) =
  g_spin(species; signed=signed)

"""
    gyromagnetic_anomaly(species::Species, units::UnitSystem) -> Float64

Return the gyromagnetic anomaly of `species`.  It is dimensionless, so `units`
leaves it unchanged; the method exists so that code generic over a `UnitSystem`
can call every accessor the same way.
"""
gyromagnetic_anomaly(species::Species, units::UnitSystem) =
  gyromagnetic_anomaly(species)

#####################################################################
# Constants in a chosen system
#####################################################################

"""
    constants(units::UnitSystem) -> NamedTuple

Return every physical constant this module exports, converted to `units`.

Bind the result to a `const` and the field accesses fold into literals, so
`C.M_ELECTRON` costs exactly what the module's own `M_ELECTRON` costs:

```julia
const C = constants(MKS)
C.M_ELECTRON        # kg
```

[`@apc_units`](@ref) does the same thing but unpacks the names, so you can write
`M_ELECTRON` rather than `C.M_ELECTRON`.

Bind it once; do not call this inside a loop.  Each call builds the whole
`NamedTuple`, which measures about 9× the cost of a `sqrt`-and-two-multiplies
kernel per iteration, where the `const` form costs nothing at all.

The seven ratios between named units -- [`EV_PER_J`](@ref), [`E_CHARGE`](@ref),
[`J_PER_EV`](@ref), [`G_PER_EV`](@ref), [`EV_PER_AMU`](@ref),
[`KG_PER_AMU`](@ref), and [`KG_PER_MEV_C2`](@ref) -- name their own units and so
are the same number in every system; they are returned unchanged.  `E_CHARGE` is
one of them: it is the elementary charge *in coulombs*, which is the factor
`MKS.charge`, not a charge expressed in the native unit.

[`RELEASE_YEAR`](@ref) is metadata rather than a constant and is not included.

```jldoctest
julia> constants(ACCELERATOR).M_ELECTRON == M_ELECTRON
true

julia> constants(CGS).C_LIGHT
2.99792458e10

julia> constants(MKS).J_PER_EV == J_PER_EV     # a ratio between named units
true
```
"""
function constants(units::UnitSystem)
  m = units.mass
  en = units.energy
  L = units.length
  t = units.time
  Θ = units.temperature
  B = units.field
  q = units.charge
  # units.spin is not used here: no constant this module exports carries a spin
  # dimension.  It is what `spinof` applies.
  return (
    # [mass]
    M_ELECTRON=M_ELECTRON * m,
    M_PROTON=M_PROTON * m,
    M_NEUTRON=M_NEUTRON * m,
    M_MUON=M_MUON * m,
    M_HELION=M_HELION * m,
    M_DEUTERON=M_DEUTERON * m,
    M_TRITON=M_TRITON * m,
    M_PION_0=M_PION_0 * m,
    M_PION_CHARGED=M_PION_CHARGED * m,

    # [magnetic moment] = [energy]/[field]
    MU_DEUTERON=MU_DEUTERON * en / B,
    MU_ELECTRON=MU_ELECTRON * en / B,
    MU_HELION=MU_HELION * en / B,
    MU_MUON=MU_MUON * en / B,
    MU_NEUTRON=MU_NEUTRON * en / B,
    MU_PROTON=MU_PROTON * en / B,
    MU_TRITON=MU_TRITON * en / B,

    # dimensionless
    AVOGADRO=AVOGADRO,
    FINE_STRUCTURE=FINE_STRUCTURE,
    ANOMALY_ELECTRON=ANOMALY_ELECTRON,
    ANOMALY_MUON=ANOMALY_MUON,
    G_DEUTERON=G_DEUTERON,
    G_ELECTRON=G_ELECTRON,
    G_HELION=G_HELION,
    G_MUON=G_MUON,
    G_NEUTRON=G_NEUTRON,
    G_PROTON=G_PROTON,
    G_TRITON=G_TRITON,

    # [length]
    R_ELECTRON=R_ELECTRON * L,
    R_PROTON=R_PROTON * L,

    # [length]/[time]
    C_LIGHT=C_LIGHT * L / t,

    # [energy]*[time]
    H_PLANCK=H_PLANCK * en * t,
    H_BAR=H_BAR * en * t,

    # [energy]*[length]
    CLASSICAL_RADIUS_FACTOR=CLASSICAL_RADIUS_FACTOR * en * L,

    # [energy]/[temperature]
    K_BOLTZMANN=K_BOLTZMANN * en / Θ,

    # [charge]^2/([energy]*[length]).  The native unit of charge is e, so the
    # e^2 is invisible in the native value 1/(eV*m) -- but it is there, and
    # leaving it out puts EPS_0 and MU_0 out by a factor of E_CHARGE^2 in any
    # system that measures charge in anything else.
    EPS_0=EPS_0 * q^2 / (en * L),

    # [energy]*[time]^2/([charge]^2*[length])
    MU_0=MU_0 * en * t^2 / (q^2 * L),

    # ratios between named units: the same number in every system
    EV_PER_J=EV_PER_J,
    E_CHARGE=E_CHARGE,
    KG_PER_AMU=KG_PER_AMU,
    EV_PER_AMU=EV_PER_AMU,
    J_PER_EV=J_PER_EV,
    G_PER_EV=G_PER_EV,
    KG_PER_MEV_C2=KG_PER_MEV_C2,
  )
end

"""
    _CONSTANT_NAMES::Tuple{Vararg{Symbol}}

The names [`constants`](@ref) returns, in order.  Needed at macro-expansion
time by [`@apc_units`](@ref).
"""
const _CONSTANT_NAMES = keys(constants(ACCELERATOR))

"""
    @apc_units unitsystem

Define every constant [`constants`](@ref) returns as a `const` in the calling
module, converted to `unitsystem`.

```julia
module MyAnalysis
  using AtomicAndPhysicalConstants
  @apc_units MKS

  rest_energy() = M_ELECTRON * C_LIGHT^2    # kg * (m/s)^2 = J
end
```

The names land in the calling module and nowhere else, so this cannot change
what any other module sees -- in particular not the values this package exports,
which stay in the native system that downstream packages compile against.  Any
number of modules may each pick a different system.

Two further names are defined alongside the constants:

- `APC_UNITS`, the system itself, to pass to the `Species` accessors:
  `massof(species, APC_UNITS)`.  The one-argument `massof(species)` still
  returns eV/c², so reach for `APC_UNITS` to stay consistent with the
  constants this macro defined.
- `_APC_CONSTANTS`, the whole `NamedTuple`, should you want to inspect it.

Everything expands to `const` bindings with a declared type, so a use folds to a
literal exactly as the module's own constants do.

Put this near the top of the module, before any of the constants is used.  A
constant that has already been read in that module is bound to the value this
package exports, and Julia then refuses to let the macro rebind it:
`cannot assign a value to imported variable`.

Calling this twice in one module is fine if the system is the same, and is a
`const` redefinition if it is not.

See also [`constants`](@ref), [`UnitSystem`](@ref).
"""
macro apc_units(unitsystem)
  apc = AtomicAndPhysicalConstants
  # Every name being defined is escaped, so it lands in the calling module
  # rather than being hygiene-renamed or resolved in this one.
  bundle = esc(:_APC_CONSTANTS)
  defs = Any[]
  push!(defs, :(const $bundle = $apc.constants($(esc(unitsystem)))))
  push!(defs, :(const $(esc(:APC_UNITS))::$apc.UnitSystem = $(esc(unitsystem))))
  for name in _CONSTANT_NAMES
    push!(defs, :(const $(esc(name))::Float64 = $bundle.$name))
  end
  push!(defs, nothing)
  return Expr(:block, defs...)
end

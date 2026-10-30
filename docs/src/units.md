# [Units](@id man-units)

Everything this package exports is in one fixed system, the one accelerator
physics uses:

| Dimension | Native unit |
|-----------|-------------|
| mass | eV/c² |
| energy | eV |
| length | m |
| time | s |
| charge | *e* |
| magnetic field | T |
| temperature | K |
| spin | ħ |

If that is what you want, there is nothing on this page you need.

If you would rather work in SI, in CGS, or in GeV and centimetres, you can have
the constants and the [`Species`](@ref) quantities converted for you.  What you
cannot do is change what *this package* reports, and the first section explains
why, because it is the reason the rest of the page looks the way it does.

## The native system does not move

The values this module exports, the fields of a `Species`, and the
one-argument accessors `massof(species)`, `chargeof(species)`,
`momentof(species)`, and `spinof(species)` are always in the native system.  No
setting, preference, or environment variable changes them.

That is a deliberate guarantee rather than an oversight, because downstream
packages compile against those exact values:

- SciBmad's energy and rigidity conversions are written for mass in eV/c² and
  charge in *e*.  `R_to_E(species, R) = sqrt((R*C_LIGHT*chargeof(species))^2 +
  massof(species)^2)` is only true in that system; it would go on running, fast
  and silent, if the units underneath it changed.
- BeamTracking splices `C_LIGHT`, `1/C_LIGHT`, and
  `55/(24√3)/(4πε₀)·ħc` into `@generated` kernels, which fix their value the
  first time they are compiled.  A constant that can change at runtime does not
  reach them; the stale one does.
- Those constants are also read inside GPU kernels, where a mutable global is
  not reachable at all.

So a unit choice here is a **value you hold**, never state inside this package.
It costs nothing: a system bound to a `const` folds into the machine code at the
call site, and the code paths the packages above use are not touched at all.

## Choosing a system

A [`UnitSystem`](@ref) is the choice. Three are predefined --
[`ACCELERATOR`](@ref) (the native system), [`MKS`](@ref) (also [`SI`](@ref)),
and [`CGS`](@ref) -- and you can name your own units for any dimension:

```jldoctest units
julia> const GeV_cm = UnitSystem(mass = :GeV, energy = :GeV, length = :cm);

julia> const NS = UnitSystem(time = :ns, length = :mm);
```

Anything you leave out stays native, so `NS` above is the accelerator system
with different length and time units.  A bare positive number is taken as the
conversion factor directly, for a unit the table does not list.

Derived dimensions follow from the base ones, so there is no way to pick an
inconsistent pair: a velocity is reported in `length/time`, a magnetic moment in
`energy/field`, an action in `energy*time`.

## Constants

[`constants`](@ref) returns all of them, converted:

```jldoctest units
julia> const C = constants(MKS);

julia> C.M_ELECTRON        # kg
9.109383713868747e-31

julia> C.H_BAR             # J*s
1.0545718176461565e-34

julia> C.K_BOLTZMANN       # J/K
1.3806489999999998e-23
```

Bind the result to a `const` and a field access folds into a literal, so
`C.M_ELECTRON` costs exactly what this module's own `M_ELECTRON` costs.  On a
1000-point sweep of Beamlines' `R_to_E` the native form and the converted one
both take 883 ns.

Bind it once, though.  `constants(u)` builds the whole `NamedTuple`, so calling
it inside the loop instead costs 7.8 µs on the same sweep -- about 9× -- which is
the one way to make this scheme slow.

If you would rather write the bare names, [`@apc_units`](@ref) unpacks them into
your own module:

```julia
module MyAnalysis
  using AtomicAndPhysicalConstants
  @apc_units MKS

  # M_ELECTRON is in kg and C_LIGHT in m/s here, so this is a rest energy in J
  rest_energy() = M_ELECTRON * C_LIGHT^2
end
```

The names land in the calling module and nowhere else.  Any number of modules
can each pick a different system, and none of it changes what this package
exports or what any other package sees.

Put the macro call near the top, before any of the constants is used: a
constant already read in that module is bound to this package's value, and
Julia will not let the macro rebind it (`cannot assign a value to imported
variable`).  The error is loud and happens as the module is defined, so there is
no way to end up quietly half-converted.

## `Species` quantities

The dimensionful accessors take a system as a second argument:

```jldoctest units
julia> p = Species("proton");

julia> massof(p, MKS)        # kg
1.672621925953106e-27

julia> chargeof(p, MKS)      # C
1.602176634e-19

julia> momentof(p, MKS)      # J/T
1.4106067954499998e-26

julia> massof(p, GeV_cm)     # GeV/c^2
0.93827208943

julia> massof(p)             # always eV/c^2
9.3827208943e8
```

The last line is the point worth remembering: `massof(p)` does not follow your
choice, by design.  After `@apc_units MKS` the macro leaves the system behind
under the name `APC_UNITS`, so pass that and your constants and your species
quantities agree:

```julia
massof(species, APC_UNITS) * C_LIGHT^2      # J
```

`spinof` takes one too; it reports ħ in all three predefined systems, since that
is how spin is quoted whatever the rest of the system is, and
`UnitSystem(spin = :Js)` overrides it.  `g_spin` and `gyromagnetic_anomaly` are
dimensionless and accept a system only so that code generic over one can call
every accessor the same way.

The older keyword forms still work and are now special cases:

```jldoctest units
julia> massof(Species("#4He"), AMU = true) == massof(Species("#4He"), UnitSystem(mass = :amu))
true

julia> chargeof(p, C = true) == chargeof(p, UnitSystem(charge = :C))
true
```

## Two things that are not rescaled

**Ratios between named units.** `EV_PER_J`, `J_PER_EV`, `G_PER_EV`,
`EV_PER_AMU`, `KG_PER_AMU`, `KG_PER_MEV_C2`, and `E_CHARGE` each name their own
units, so they are the same number in every system and come back unchanged.
`E_CHARGE` is the one to watch: it is the elementary charge *in coulombs*, which
is the factor `MKS.charge`, not a charge expressed in the native unit.

**The charge in `EPS_0` and `MU_0`.** Natively `EPS_0` is in e²/(eV·m) and
`MU_0` in eV·s²/(e²·m).  The charge unit is the elementary charge, so the e²
is 1 and the values read as though the charge were not there — but it is, and
the dimension is what makes this hold in every system:

```jldoctest units
julia> α(u) = chargeof(Species("proton"), u)^2 /
              (4π * constants(u).EPS_0 * constants(u).H_BAR * constants(u).C_LIGHT);

julia> all(α(u) ≈ FINE_STRUCTURE for u in (ACCELERATOR, MKS, CGS, GeV_cm))
true
```

[`RELEASE_YEAR`](@ref) is metadata rather than a constant, and is not part of
the bundle.

## Reference

```@docs
UnitSystem
ACCELERATOR
MKS
SI
CGS
constants
@apc_units
```

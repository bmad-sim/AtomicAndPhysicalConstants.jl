# test/units_test.jl

# A module of its own, so @apc_units is exercised the way a user would use it
# and its names cannot leak into the rest of the test suite.
module ApcUnitsUser
using AtomicAndPhysicalConstants
@apc_units MKS

# M_ELECTRON here is in kg, so this is a rest energy in J.
rest_energy_electron() = M_ELECTRON * C_LIGHT^2
end  # module

# Top-level (not closures in a testset) so allocation and codegen can be
# measured without a closure's boxing getting in the way.
const _P = Species("proton")
_native_massof(s) = massof(s)
_mks_massof(s) = massof(s, MKS)
_folded_mass() = massof(_P, MKS)

@testset "UnitSystem construction" begin
  @test ACCELERATOR == UnitSystem()
  for f in fieldnames(UnitSystem)
    @test getfield(ACCELERATOR, f) == 1.0
  end

  @test SI === MKS
  @test MKS.mass ≈ G_PER_EV * 1e-3
  @test MKS.energy ≈ J_PER_EV
  @test MKS.charge ≈ E_CHARGE
  @test CGS.length == 1e2
  @test CGS.field == 1e4
  @test CGS.energy ≈ J_PER_EV * 1e7

  # a bare number is taken as the factor directly
  @test UnitSystem(length=1e2).length == 1e2
  # unicode and ASCII spellings agree
  @test UnitSystem(length=:μm).length == UnitSystem(length=:um).length
  @test UnitSystem(spin=:ħ).spin == UnitSystem(spin=:hbar).spin

  @test_throws ArgumentError UnitSystem(mass=:furlong)
  @test_throws ArgumentError UnitSystem(length=:eV)     # right name, wrong dimension
  @test_throws ArgumentError UnitSystem(time=-1.0)
  @test_throws ArgumentError UnitSystem(time=0)
  @test_throws ArgumentError UnitSystem(mass=Inf)
  @test_throws ArgumentError UnitSystem(mass="kg")
end

@testset "Species accessors in a chosen system" begin
  p = Species("proton")
  e = Species("electron")
  He = Species("#4He")
  Li = Species("Li+3")

  # the native system must leave every accessor exactly alone
  for s in (p, e, He, Li)
    @test massof(s, ACCELERATOR) === massof(s)
    @test chargeof(s, ACCELERATOR) === chargeof(s)
    @test momentof(s, ACCELERATOR) === momentof(s)
    @test spinof(s, ACCELERATOR) === spinof(s)
  end

  # MKS values, cross-checked against the published SI numbers
  @test massof(p, MKS) ≈ 1.67262192595e-27 rtol = 1e-9
  @test massof(e, MKS) ≈ 9.1093837139e-31 rtol = 1e-9
  @test chargeof(p, MKS) ≈ E_CHARGE
  @test chargeof(Li, MKS) ≈ 3 * E_CHARGE
  @test chargeof(e, MKS) ≈ -E_CHARGE
  @test momentof(p, MKS) ≈ 1.41060679545e-26 rtol = 1e-9
  @test momentof(e, MKS) ≈ -9.2847646917e-24 rtol = 1e-9

  # the existing keyword forms are special cases of a UnitSystem
  @test massof(He, UnitSystem(mass=:amu)) ≈ massof(He, AMU=true)
  @test massof(He, UnitSystem(mass=:Da)) ≈ 4.00260325413
  @test chargeof(p, UnitSystem(charge=:C)) ≈ chargeof(p, C=true)

  # scaling composes the way the dimensions say it should
  @test massof(p, UnitSystem(mass=:GeV)) ≈ massof(p) * 1e-9
  @test momentof(p, UnitSystem(energy=:J, field=:G)) ≈ momentof(p) * J_PER_EV / 1e4
  @test spinof(e, UnitSystem(spin=:Js)) ≈ 0.5 * H_BAR * J_PER_EV

  # dimensionless accessors ignore the system
  @test g_spin(e, MKS) == g_spin(e)
  @test g_spin(e, MKS, signed=true) == g_spin(e, signed=true)
  @test gyromagnetic_anomaly(e, CGS) == gyromagnetic_anomaly(e)

  # Gaussian CGS charge: the elementary charge is 4.80320471e-10 statC
  @test chargeof(p, CGS) ≈ 4.803204712570263e-10 rtol = 1e-9
end

@testset "constants()" begin
  native = constants(ACCELERATOR)

  # every exported Float64 constant must be in the bundle, so that adding a
  # constant without giving it a dimension fails here rather than silently
  # going unscaled
  exported = filter(names(AtomicAndPhysicalConstants)) do n
    isdefined(AtomicAndPhysicalConstants, n) &&
      isconst(AtomicAndPhysicalConstants, n) &&
      getproperty(AtomicAndPhysicalConstants, n) isa Float64
  end
  @test Set(exported) == Set(keys(native))
  @test !(:RELEASE_YEAR in keys(native))   # metadata, deliberately left out

  # the native bundle reproduces the module's own values exactly
  for n in keys(native)
    @test native[n] === getproperty(AtomicAndPhysicalConstants, n)
  end

  mks = constants(MKS)
  @test mks.C_LIGHT ≈ C_LIGHT                      # m/s either way
  @test mks.M_ELECTRON ≈ 9.1093837139e-31 rtol = 1e-9
  @test mks.H_PLANCK ≈ 6.62607015e-34 rtol = 1e-9  # J*s
  @test mks.H_BAR ≈ 1.054571817e-34 rtol = 1e-9
  @test mks.K_BOLTZMANN ≈ 1.380649e-23 rtol = 1e-9 # J/K
  @test mks.MU_PROTON ≈ 1.41060679545e-26 rtol = 1e-9
  @test mks.R_ELECTRON ≈ R_ELECTRON
  # EPS_0 is 1/(energy*length) natively, so in SI it comes back as F/m
  @test mks.EPS_0 ≈ 8.8541878188e-12 rtol = 1e-8
  @test mks.MU_0 ≈ 1.25663706127e-6 rtol = 1e-8

  cgs = constants(CGS)
  @test cgs.C_LIGHT ≈ 2.99792458e10                # cm/s
  @test cgs.R_ELECTRON ≈ R_ELECTRON * 1e2
  @test cgs.M_ELECTRON ≈ 9.1093837139e-28 rtol = 1e-9   # g
  @test cgs.H_BAR ≈ 1.054571817e-27 rtol = 1e-9         # erg*s

  gev = constants(UnitSystem(mass=:GeV, energy=:GeV, length=:cm))
  @test gev.M_PROTON ≈ M_PROTON * 1e-9
  @test gev.C_LIGHT ≈ C_LIGHT * 1e2
  @test gev.H_BAR ≈ H_BAR * 1e-9
  @test gev.CLASSICAL_RADIUS_FACTOR ≈ CLASSICAL_RADIUS_FACTOR * 1e-9 * 1e2
  @test gev.EPS_0 ≈ EPS_0 / (1e-9 * 1e2)

  # ratios between named units are the same number in every system
  for u in (MKS, CGS, UnitSystem(mass=:GeV, time=:ns))
    c = constants(u)
    @test c.J_PER_EV === J_PER_EV
    @test c.E_CHARGE === E_CHARGE
    @test c.EV_PER_J === EV_PER_J
    @test c.EV_PER_AMU === EV_PER_AMU
    @test c.KG_PER_AMU === KG_PER_AMU
    @test c.G_PER_EV === G_PER_EV
    @test c.KG_PER_MEV_C2 === KG_PER_MEV_C2
    # dimensionless constants likewise
    @test c.FINE_STRUCTURE === FINE_STRUCTURE
    @test c.G_ELECTRON === G_ELECTRON
    @test c.AVOGADRO === AVOGADRO
  end

  # A dimensionless combination must come out the same in every system.  This
  # is the check that pins the charge dimension of EPS_0: alpha = q^2/(4*pi*eps_0*hbar*c)
  # with q the elementary charge expressed in that system's own charge unit.
  p = Species("proton")
  for u in (ACCELERATOR, MKS, CGS, UnitSystem(mass=:GeV, energy=:GeV, length=:cm, time=:ns),
    UnitSystem(charge=:C, energy=:erg, length=:mm, time=:ps))
    c = constants(u)
    α = chargeof(p, u)^2 / (4 * pi * c.EPS_0 * c.H_BAR * c.C_LIGHT)
    @test α ≈ FINE_STRUCTURE rtol = 1e-9
    # and mu_0 * eps_0 * c^2 == 1 in every system
    @test c.MU_0 * c.EPS_0 * c.C_LIGHT^2 ≈ 1.0 rtol = 1e-9
    # e^2/(4*pi*eps_0) == alpha*hbar*c, which pins CLASSICAL_RADIUS_FACTOR
    @test c.CLASSICAL_RADIUS_FACTOR ≈ FINE_STRUCTURE * c.H_BAR * c.C_LIGHT rtol = 1e-9
    @test c.CLASSICAL_RADIUS_FACTOR ≈ c.R_ELECTRON * c.M_ELECTRON * (u.energy / u.mass) rtol = 1e-9
  end

  # a round trip through a system and its inverse returns the original
  inv = UnitSystem(mass=1 / MKS.mass, energy=1 / MKS.energy,
    length=1 / MKS.length, time=1 / MKS.time,
    charge=1 / MKS.charge, field=1 / MKS.field,
    temperature=1 / MKS.temperature, spin=1 / MKS.spin)
  @test constants(MKS).M_PROTON * inv.mass ≈ M_PROTON
  @test constants(MKS).MU_PROTON * inv.energy / inv.field ≈ MU_PROTON
end

@testset "@apc_units" begin
  # the macro defined the constants in the calling module, in MKS
  @test ApcUnitsUser.M_ELECTRON ≈ 9.1093837139e-31 rtol = 1e-9
  @test ApcUnitsUser.C_LIGHT ≈ C_LIGHT
  @test ApcUnitsUser.H_BAR ≈ 1.054571817e-34 rtol = 1e-9
  @test ApcUnitsUser.rest_energy_electron() ≈ 8.1871057880e-14 rtol = 1e-8  # J

  # and the system itself, for the Species accessors
  @test ApcUnitsUser.APC_UNITS === MKS
  @test massof(Species("proton"), ApcUnitsUser.APC_UNITS) ≈ 1.67262192595e-27 rtol = 1e-9

  # it defines every name constants() returns, and the bundle
  for n in keys(constants(ACCELERATOR))
    @test isdefined(ApcUnitsUser, n)
    @test isconst(ApcUnitsUser, n)
  end
  @test ApcUnitsUser._APC_CONSTANTS == constants(MKS)

  # using a constant before the macro runs is refused, loudly, as the module is
  # defined -- there is no quietly half-converted module
  @test_throws ErrorException @eval module ApcUnitsTooLate
    using AtomicAndPhysicalConstants
    const too_early = M_ELECTRON
    @apc_units MKS
  end

  # and it left this package's own values alone -- the whole point
  @test M_ELECTRON == constants(ACCELERATOR).M_ELECTRON
  @test massof(Species("electron")) ≈ 0.51099895069e6
end

@testset "Unit selection is free" begin
  p = Species("proton")

  @test (@inferred massof(p, MKS)) isa Float64
  @test (@inferred chargeof(p, MKS)) isa Float64
  @test (@inferred momentof(p, MKS)) isa Float64
  @test (@inferred spinof(p, MKS)) isa Float64
  @test (@inferred g_spin(p, MKS)) isa Float64
  @test (@inferred gyromagnetic_anomaly(p, MKS)) isa Float64
  @test (@inferred constants(MKS)) isa NamedTuple
  @test (@inferred UnitSystem()) isa UnitSystem

  # UnitSystem is isbits, so it can be passed into a GPU kernel if anyone wants to
  @test isbitstype(UnitSystem)

  # a const UnitSystem costs no allocation, exactly as the native accessor does
  @test _mks_massof(p) == massof(p) * MKS.mass
  _mks_massof(p); _native_massof(p)        # compile before measuring
  @test (@allocated _mks_massof(p)) == 0
  @test (@allocated _native_massof(p)) == 0

  # And it folds: with both the species and the system `const`, the whole
  # expression must compile down to a single Float64 literal, which is the
  # performance claim this scheme rests on.  If a future Julia stops folding
  # this, that is worth knowing about loudly.
  ci = first(only(code_typed(_folded_mass, Tuple{})))
  @test length(ci.code) == 1
  @test ci.code[1] isa Core.ReturnNode
  @test ci.code[1].val isa Float64
  @test ci.code[1].val == massof(_P) * MKS.mass
end

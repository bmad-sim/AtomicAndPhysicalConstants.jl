"""
Choosing units in AtomicAndPhysicalConstants.jl

This script demonstrates how to have the constants and `Species` quantities
reported in a system other than the native one, and why the native one does not
move.  Run it with

    julia --project examples/units.jl
"""

using AtomicAndPhysicalConstants

println("=== Choosing units in AtomicAndPhysicalConstants.jl ===\n")

p = Species("proton")
e = Species("electron")

# ---------------------------------------------------------------------------
println("1. What you get without asking for anything")
println()
# Everything this package exports is in the accelerator-physics system:
# mass eV/c^2, energy eV, length m, time s, charge e, field T, temperature K,
# spin hbar.
println("  massof(proton)   = ", massof(p), " eV/c^2")
println("  chargeof(proton) = ", chargeof(p), " e")
println("  C_LIGHT          = ", C_LIGHT, " m/s")
println("  H_BAR            = ", H_BAR, " eV*s")
println()

# ---------------------------------------------------------------------------
println("2. The predefined systems")
println()
# ACCELERATOR is the native one, MKS (also spelled SI) and CGS are the other two.
for (name, u) in (("ACCELERATOR", ACCELERATOR), ("MKS", MKS), ("CGS", CGS))
  println("  $name:")
  println("    massof(proton)   = ", massof(p, u))
  println("    chargeof(proton) = ", chargeof(p, u))
  println("    momentof(proton) = ", momentof(p, u))
  println("    C_LIGHT          = ", constants(u).C_LIGHT)
end
println()
# A UnitSystem prints its own scale factors, which are the numbers a native
# value is multiplied by:
println("  MKS itself:")
show(stdout, MIME"text/plain"(), MKS)
println()

# ---------------------------------------------------------------------------
println("3. A system of your own")
println()
# Name a unit per dimension.  Anything left out stays native, so this is the
# accelerator system with GeV and centimetres.
const GeV_cm = UnitSystem(mass=:GeV, energy=:GeV, length=:cm)

println("  massof(proton, GeV_cm)  = ", massof(p, GeV_cm), " GeV/c^2")
println("  C_LIGHT in GeV_cm       = ", constants(GeV_cm).C_LIGHT, " cm/s")
println("  H_BAR in GeV_cm         = ", constants(GeV_cm).H_BAR, " GeV*s")
println()

# Derived dimensions follow from the base ones, so there is no way to ask for an
# inconsistent pair: a magnetic moment is always energy/field.
const erg_gauss = UnitSystem(energy=:erg, field=:gauss)
println("  momentof(electron, UnitSystem(energy=:erg, field=:gauss)) = ",
  momentof(e, erg_gauss), " erg/G")
println()

# A bare positive number is taken as the conversion factor directly, for a unit
# the table does not know.  Here: furlongs, 1 m = 1/201.168 furlong.
const furlong = UnitSystem(length=1 / 201.168)
println("  R_ELECTRON in furlongs  = ", constants(furlong).R_ELECTRON)
println()

# An unknown name is an error that lists what is available.
try
  UnitSystem(mass=:slug)
catch err
  println("  UnitSystem(mass = :slug) -> ", sprint(showerror, err))
end
println()

# ---------------------------------------------------------------------------
println("4. All the constants at once")
println()
# constants(units) returns every constant this package exports, converted.
# Bind it to a `const`: then a field access folds into a literal and costs
# nothing.  Calling constants() inside a loop instead rebuilds the whole
# NamedTuple every iteration, which is the one way to make this slow.
const C = constants(MKS)

println("  C.M_ELECTRON  = ", C.M_ELECTRON, " kg")
println("  C.H_PLANCK    = ", C.H_PLANCK, " J*s")
println("  C.K_BOLTZMANN = ", C.K_BOLTZMANN, " J/K")
println("  C.EPS_0       = ", C.EPS_0, " F/m")
println("  C.MU_0        = ", C.MU_0, " N/A^2")
println("  (", length(C), " constants in all)")
println()

# ---------------------------------------------------------------------------
println("5. @apc_units: the bare names, in your own module")
println()
# Put the macro near the top of your module, before any constant is used.  It
# defines the constants there and nowhere else.
module MyAnalysis
using AtomicAndPhysicalConstants
@apc_units MKS

# M_ELECTRON is in kg and C_LIGHT in m/s here, so this is a rest energy in J.
electron_rest_energy() = M_ELECTRON * C_LIGHT^2

# APC_UNITS is the system itself, left behind by the macro.  Pass it to the
# Species accessors and they agree with the constants above.
rest_energy(species) = massof(species, APC_UNITS) * C_LIGHT^2
end

println("  MyAnalysis.M_ELECTRON            = ", MyAnalysis.M_ELECTRON, " kg")
println("  MyAnalysis.electron_rest_energy()= ", MyAnalysis.electron_rest_energy(), " J")
println("  MyAnalysis.rest_energy(proton)   = ", MyAnalysis.rest_energy(p), " J")
println()

# Another module can pick a different system; neither reaches the other.
module MyOtherAnalysis
using AtomicAndPhysicalConstants
@apc_units CGS
end
println("  MyAnalysis.M_ELECTRON      = ", MyAnalysis.M_ELECTRON, " kg")
println("  MyOtherAnalysis.M_ELECTRON = ", MyOtherAnalysis.M_ELECTRON, " g")
println("  and this package's own      = ", M_ELECTRON, " eV/c^2")
println()

# ---------------------------------------------------------------------------
println("6. The native system does not move, and that is the point")
println()
# Downstream code compiles against the native values: SciBmad's energy and
# rigidity conversions are only valid with mass in eV/c^2 and charge in e, and
# BeamTracking splices C_LIGHT into @generated kernels that fix their value the
# first time they compile.  So no setting here changes what they see.
println("  after all of the above, massof(proton) = ", massof(p), " eV/c^2")
println("  and C_LIGHT                           = ", C_LIGHT, " m/s")
println()

# It is free, too.  With the species and the system both `const`, the whole
# expression compiles down to a single Float64 literal.
const P = Species("proton")
mass_in_gev() = massof(P, GeV_cm)

ci = first(only(Base.code_typed(mass_in_gev, Tuple{})))
println("  the compiled body of massof(P, GeV_cm):")
for stmt in ci.code
  println("    ", stmt)
end
println()

# A rough timing of Beamlines' R_to_E, native against converted.
R_to_E_native(s, R) = sqrt((R * C_LIGHT * chargeof(s))^2 + massof(s)^2)
const CG = constants(GeV_cm)
R_to_E_gev(s, R) = sqrt((R * CG.C_LIGHT * chargeof(s, GeV_cm))^2 + massof(s, GeV_cm)^2)

function sweep(f, s, Rs)
  acc = 0.0
  @inbounds for R in Rs
    acc += f(s, R)
  end
  acc
end

Rs = collect(range(1.0, 10.0, length=1000))
sweep(R_to_E_native, P, Rs)                  # compile first
sweep(R_to_E_gev, P, Rs)
t_native = minimum(@elapsed(sweep(R_to_E_native, P, Rs)) for _ in 1:2000)
t_gev = minimum(@elapsed(sweep(R_to_E_gev, P, Rs)) for _ in 1:2000)
println("  1000-point R_to_E sweep, native:    ", round(t_native * 1e9, digits=1), " ns")
println("  1000-point R_to_E sweep, GeV/cm:    ", round(t_gev * 1e9, digits=1), " ns")
println()

# ---------------------------------------------------------------------------
println("7. Two things that are not rescaled")
println()
# Ratios between named units name their own units, so they are the same number
# in every system.  E_CHARGE is one of them: it is the elementary charge in
# coulombs, which is the factor MKS.charge, not a charge in the native unit.
println("  J_PER_EV: native ", J_PER_EV, "  MKS ", C.J_PER_EV, "  CGS ", constants(CGS).J_PER_EV)
println("  E_CHARGE: native ", E_CHARGE, "  MKS ", C.E_CHARGE, "  and MKS.charge = ", MKS.charge)
println()

# EPS_0 and MU_0 carry a charge dimension their native values hide: natively
# EPS_0 is in e^2/(eV*m), and the native charge unit makes that e^2 equal 1.
# Leaving it out would put them out by a factor of E_CHARGE^2 anywhere else.
# These two dimensionless combinations are what pin it down.
println("  alpha = q^2/(4*pi*eps_0*hbar*c), and mu_0*eps_0*c^2 = 1, in every system:")
for (name, u) in (("ACCELERATOR", ACCELERATOR), ("MKS", MKS), ("CGS", CGS), ("GeV_cm", GeV_cm))
  c = constants(u)
  α = chargeof(p, u)^2 / (4π * c.EPS_0 * c.H_BAR * c.C_LIGHT)
  println("    ", rpad(name, 12), "alpha = ", α,
    "   mu_0*eps_0*c^2 = ", c.MU_0 * c.EPS_0 * c.C_LIGHT^2)
end
println("    FINE_STRUCTURE = ", FINE_STRUCTURE)
println()

println("=== End of Examples ===")

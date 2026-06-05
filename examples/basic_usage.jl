"""
Basic usage examples for APClite.jl

This script demonstrates the main features of APClite.
"""

using APClite

println("=== APClite.jl Basic Usage Examples ===\n")

# 1. Access physical constants
println("1. Physical Constants:")
println("Speed of light: ", C_LIGHT, " m/s")
println("Planck constant: ", H_PLANCK, " J⋅s")
println("Electron mass: ", M_ELECTRON, " MeV/c²")
println("Proton mass: ", M_PROTON, " MeV/c²")
println("Fine structure constant: ", FINE_STRUCTURE)
println()

# 2. Create subatomic particles
println("2. Subatomic Particles:")
electron = Species("electron")
proton = Species("proton")
neutron = Species("neutron")
muon = Species("muon")
photon = Species("photon")

println("Electron: ", electron)
println("Proton: ", proton)
println("Neutron: ", neutron)
println("Muon: ", muon)
println("Photon: ", photon)
println()

# 3. Create anti-particles
println("3. Anti-particles:")
positron = Species("positron")
anti_proton = Species("anti-proton")
anti_muon = Species("anti-muon")

println("Positron: ", positron)
println("Anti-proton: ", anti_proton)
println("Anti-muon: ", anti_muon)
println()

# 4. Create atomic species
println("4. Atomic Species:")
hydrogen = Species("H")
helium = Species("He")
carbon = Species("C")
iron = Species("Fe")

println("Hydrogen: ", hydrogen)
println("Helium: ", helium)
println("Carbon: ", carbon)
println("Iron: ", iron)
println()

# 5. Create ions
println("5. Ions:")
h_plus = Species("H+")
he_plus_plus = Species("He++")
c_plus = Species("C+")
o_minus = Species("O-")

println("H⁺: ", h_plus)
println("He⁺⁺: ", he_plus_plus)
println("C⁺: ", c_plus)
println("O⁻: ", o_minus)
println()

# 6. Create isotopes
println("6. Isotopes:")
h1 = Species("H1")
c12 = Species("C12")
c13 = Species("C13")
u235 = Species("U235")
u238 = Species("U238")

println("¹H: ", h1)
println("¹²C: ", c12)
println("¹³C: ", c13)
println("²³⁵U: ", u235)
println("²³⁸U: ", u238)
println()

# 7. Access properties using direct field access
println("7. Accessing Properties:")
println("Electron properties:")
println("  Name: ", nameof(electron))
println("  Charge: ", electron.charge, " e")
println("  Mass: ", electron.mass, " MeV/c²")
println("  Spin: ", electron.spin, " ħ")
println("  Magnetic moment: ", electron.moment, " J/T")
println("  Kind: ", electron.kind)
println()

println("Proton properties:")
println("  Name: ", nameof(proton))
println("  Charge: ", proton.charge, " e")
println("  Mass: ", proton.mass, " MeV/c²")
println("  Spin: ", proton.spin, " ħ")
println("  Magnetic moment: ", proton.moment, " J/T")
println("  Kind: ", proton.kind)
println()

println("=== End of Examples ===")


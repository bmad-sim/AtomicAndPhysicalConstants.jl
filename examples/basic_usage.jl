"""
Basic usage examples for AtomicAndPhysicalConstants.jl

This script demonstrates the main features of AtomicAndPhysicalConstants.jl.
"""

using AtomicAndPhysicalConstants

println("=== AtomicAndPhysicalConstants.jl Basic Usage Examples ===\n")

# 1. Access physical constants
println("1. Physical Constants:")
println("Speed of light: ", C_LIGHT, " m/s")
println("Planck constant: ", H_PLANCK, " eV⋅s")
println("Electron mass: ", M_ELECTRON, " eV/c²")
println("Proton mass: ", M_PROTON, " eV/c²")
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
h1 = Species("1H")
c12 = Species("12C")
c13 = Species("13C")
u235 = Species("235U")
u238 = Species("238U")

println("¹H: ", h1)
println("¹²C: ", c12)
println("¹³C: ", c13)
println("²³⁵U: ", u235)
println("²³⁸U: ", u238)
println()

# 7. Access properties using the provided accessor functions
println("7. Accessing Properties:")
println("Electron properties:")
println("  Name: ", nameof(electron))
println("  Charge: ", chargeof(electron), " e")
println("  Mass: ", massof(electron), " eV/c²")
println("  Spin: ", spinof(electron), " ħ")
println("  Magnetic moment: ", momentof(electron), " eV/T")
println("  Kind: ", kindof(electron))
println()

println("Proton properties:")
println("  Name: ", nameof(proton))
println("  Charge: ", chargeof(proton), " e")
println("  Mass: ", massof(proton), " eV/c²")
println("  Spin: ", spinof(proton), " ħ")
println("  Magnetic moment: ", momentof(proton), " eV/T")
println("  Kind: ", kindof(proton))
println()

println("=== End of Examples ===")

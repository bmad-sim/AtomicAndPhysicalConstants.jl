module DefaultAPCDef
using AtomicAndPhysicalConstants
using Test


@testset "test @APCdef" begin
  
  #constants should be of type float in the right unit
  @test c_light ≈ 2.99792458e8
  @test h_Planck ≈ 6.62607015e-34
  @test h_bar_Planck ≈ 1.05457182e-34
  @test r_e ≈ 2.8179403205e-15
  @test r_p ≈ 1.53469826e-18
  @test e_charge ≈ 1.602176634e-19
  @test mu_0_vac ≈ 1.25663706127e-6
  @test eps_0_vac ≈ 8.8541878188e-12
  @test classical_radius_factor ≈ 1.43996455e-15
  @test fine_structure ≈ 0.0072973525643
  @test N_Avogadro ≈ 6.02214076e23


  #test massof() and chargeof()
  H = Species("H")

  @test massof(H) ≈ 9.388908693006046e8
  @test chargeof(H) ≈ 0

  e = Species("electron")
  @test massof(e) ≈ 510998.95069
  @test chargeof(e) ≈ -1
end

@testset "test Species" begin
  #test '+' and '-' signs to charge
  @test chargeof(Species("H+")) ≈ 1
  @test chargeof(Species("Mg++")) ≈ 2
  @test chargeof(Species("Al+3")) ≈ 3
  @test chargeof(Species("Cl-")) ≈ -1
  @test chargeof(Species("O--")) ≈ -2
  @test chargeof(Species("N-3")) ≈ -3

  #test superscript numbers to charge
  @test chargeof(Species("He⁺")) ≈ 1
  @test chargeof(Species("Ca⁺⁺")) ≈ 2
  @test chargeof(Species("P⁻³")) ≈ -3
  @test chargeof(Species("Fe³⁺")) ≈ 3
  @test chargeof(Species("O²⁻")) ≈ -2
  @test chargeof(Species("He")) ≈ 0

  #test isotope numbers
  @test getfield(Species("#1H"), :iso) == 1
  @test getfield(Species("H"), :iso) == -1
  @test getfield(Species("#13C"), :iso) == 13
  @test getfield(Species("C"), :iso) == -1
  @test getfield(Species("#16O"), :iso) == 16
  @test getfield(Species("O"), :iso) == -1
  @test getfield(Species("#56Fe"), :iso) == 56
  @test getfield(Species("Fe"), :iso) == -1
  @test getfield(Species("#7Li"), :iso) == 7
  @test getfield(Species("Li"), :iso) == -1
  @test getfield(Species("#14N"), :iso) == 14
  @test getfield(Species("N"), :iso) == -1
  @test getfield(Species("#27Al"), :iso) == 27
  @test getfield(Species("Al"), :iso) == -1
  @test getfield(Species("#24Mg"), :iso) == 24
  @test getfield(Species("Mg"), :iso) == -1
  @test getfield(Species("#235U"), :iso) == 235
  @test getfield(Species("#236U"), :iso) == 236
  @test getfield(Species("U"), :iso) == -1

  #test isotope number with superscript
  @test getfield(Species("¹H"), :iso) == 1
  @test getfield(Species("²H"), :iso) == 2
  @test getfield(Species("³H"), :iso) == 3
  @test getfield(Species("⁴He"), :iso) == 4
  @test getfield(Species("⁵He"), :iso) == 5
  @test getfield(Species("⁶Li"), :iso) == 6
  @test getfield(Species("⁷Li"), :iso) == 7
  @test getfield(Species("⁸Be"), :iso) == 8
  @test getfield(Species("⁹Be"), :iso) == 9
  @test getfield(Species("¹⁴N"), :iso) == 14
  @test getfield(Species("¹⁵N"), :iso) == 15
  @test getfield(Species("¹⁶O"), :iso) == 16
  @test getfield(Species("¹⁷O"), :iso) == 17
  @test getfield(Species("¹⁸O"), :iso) == 18
  @test getfield(Species("²³Na"), :iso) == 23
  @test getfield(Species("²⁴Mg"), :iso) == 24
  @test getfield(Species("²⁵Mg"), :iso) == 25
  @test getfield(Species("²⁶Mg"), :iso) == 26
  @test getfield(Species("²⁷Al"), :iso) == 27
  @test getfield(Species("²³⁵U"), :iso) == 235
  @test getfield(Species("²³⁶U"), :iso) == 236
  @test getfield(Species("²³⁸U"), :iso) == 238
  @test getfield(Species("U"), :iso) == -1
end

@testset "test Species parsing" begin
  import AtomicAndPhysicalConstants: create_atomic_species
  @test Species("¹H") == create_atomic_species("H", 0, 1)
  @test Species("H⁺") == create_atomic_species("H", 1, -1)
  @test Species("³H⁺") == create_atomic_species("H", 1, 3)
  @test Species("¹⁵N³⁻") == create_atomic_species("N", -3, 15)
  @test Species("⁴He") == create_atomic_species("He", 0, 4)
  @test Species("²³⁶U⁺") == create_atomic_species("U", 1, 236)
end

end

module APCdefWithChangedName
using AtomicAndPhysicalConstants
using Test

# test default APCdef settings
@APCdef name = ABC
@testset "test name definition" begin
  #constants should be of type float in the right unit
  @test ABC.C_LIGHT ≈ 2.99792458e8
  @test ABC.H_PLANCK ≈ 2.0*pi #  4.135667696e-15
  @test ABC.H_BAR_PLANCK ≈ 1.0 # 6.582119568038699e-16
  @test ABC.R_E ≈ 2.8179403205e-15
  @test ABC.R_P ≈ 1.5346982640795807e-18
  @test ABC.E_CHARGE ≈ 1
  @test ABC.E_COULOMB ≈ 1.602176634e-19
  @test ABC.MU_0_VAC ≈ 1.25663706127e-6
  @test ABC.EPS_0_VAC ≈ 8.8541878188e-12
  @test ABC.CLASSICAL_RADIUS_FACTOR ≈ 1.4399645468825422e-9
  @test ABC.FINE_STRUCTURE ≈ 0.0072973525643
  @test ABC.N_AVOGADRO ≈ 6.02214076e23
end

end

module APCdefWithDifferentUnitSystem
using AtomicAndPhysicalConstants
using Test

# test default APCdef settings
@APCdef unitsystem = MKS
@testset "test constants" begin
  #constants should be of type float in the right unit
  @test APC.C_LIGHT ≈ 2.99792458e8
  @test APC.H_PLANCK ≈ 2.0*pi #  6.626070148519815e-34
  @test APC.H_BAR_PLANCK ≈ 1.0 # 1.0545718174105777e-34
  @test APC.R_E ≈ 2.8179403205e-15
  @test APC.R_P ≈ 1.5346982640795807e-18
  @test APC.E_CHARGE ≈ 1.602176634e-19
  @test APC.E_COULOMB ≈ 1.602176634e-19
  @test APC.MU_0_VAC ≈ 1.25663706127e-6
  @test APC.EPS_0_VAC ≈ 8.8541878188e-12
  @test APC.CLASSICAL_RADIUS_FACTOR ≈ 2.5669699662216776e-45
  @test APC.FINE_STRUCTURE ≈ 0.0072973525643
  @test APC.N_AVOGADRO ≈ 6.02214076e23
end

end

module APCdefWithoutTuple
using AtomicAndPhysicalConstants
using Test

@APCdef tupleflag = false
@testset "test no tuple setting " begin
  #constants should be of type float in the right unit and accessable in the namespace
  @test C_LIGHT ≈ 2.99792458e8
  @test H_PLANCK ≈ 2.0*pi #  4.135667696e-15
  @test H_BAR_PLANCK ≈ 1.0 # 6.582119568038699e-16
  @test R_E ≈ 2.8179403205e-15
  @test R_P ≈ 1.5346982640795807e-18
  @test E_CHARGE ≈ 1
  @test E_COULOMB ≈ 1.602176634e-19
  @test MU_0_VAC ≈ 1.25663706127e-6
  @test EPS_0_VAC ≈ 8.8541878188e-12
  @test CLASSICAL_RADIUS_FACTOR ≈ 1.4399645468825422e-9
  @test FINE_STRUCTURE ≈ 0.0072973525643
  @test N_AVOGADRO ≈ 6.02214076e23
end

end
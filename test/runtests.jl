module DefaultAPCDef
using AtomicAndPhysicalConstants.CODATA2022
using Test

# test default APCdef settings
@APCdef
@testset "test @APCdef" begin
  #constants should be of type float in the right unit
  @test APC.C_LIGHT ≈ 2.99792458e8
  @test APC.H_PLANCK ≈ 4.135667696e-15
  @test APC.H_BAR_PLANCK ≈ 6.582119568038699e-16
  @test APC.R_E ≈ 2.8179403205e-15
  @test APC.R_P ≈ 1.5346982640795807e-18
  @test APC.E_CHARGE ≈ 1
  @test APC.MU_0_VAC ≈ 1.25663706127e-6
  @test APC.EPS_0_VAC ≈ 8.8541878188e-12
  @test APC.CLASSICAL_RADIUS_FACTOR ≈ 1.4399645468825422e-9
  @test APC.FINE_STRUCTURE ≈ 0.0072973525643
  @test APC.N_AVOGADRO ≈ 6.02214076e23

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
  @test Species("#1H").iso == 1
  @test Species("H").iso == -1
  @test Species("#13C").iso == 13
  @test Species("C").iso == -1
  @test Species("#16O").iso == 16
  @test Species("O").iso == -1
  @test Species("#56Fe").iso == 56
  @test Species("Fe").iso == -1
  @test Species("#7Li").iso == 7
  @test Species("Li").iso == -1
  @test Species("#14N").iso == 14
  @test Species("N").iso == -1
  @test Species("#27Al").iso == 27
  @test Species("Al").iso == -1
  @test Species("#24Mg").iso == 24
  @test Species("Mg").iso == -1
  @test Species("#235U").iso == 235
  @test Species("#236U").iso == 236
  @test Species("U").iso == -1

  #test isotope number with superscript
  @test Species("¹H").iso == 1
  @test Species("²H").iso == 2
  @test Species("³H").iso == 3
  @test Species("⁴He").iso == 4
  @test Species("⁵He").iso == 5
  @test Species("⁶Li").iso == 6
  @test Species("⁷Li").iso == 7
  @test Species("⁸Be").iso == 8
  @test Species("⁹Be").iso == 9
  @test Species("¹⁴N").iso == 14
  @test Species("¹⁵N").iso == 15
  @test Species("¹⁶O").iso == 16
  @test Species("¹⁷O").iso == 17
  @test Species("¹⁸O").iso == 18
  @test Species("²³Na").iso == 23
  @test Species("²⁴Mg").iso == 24
  @test Species("²⁵Mg").iso == 25
  @test Species("²⁶Mg").iso == 26
  @test Species("²⁷Al").iso == 27
  @test Species("²³⁵U").iso == 235
  @test Species("²³⁶U").iso == 236
  @test Species("²³⁸U").iso == 238
  @test Species("U").iso == -1
end

@testset "test Species parsing" begin
  @test Species("¹H") == Species("H", 0, 1)
  @test Species("H⁺") == Species("H", 1, -1)
  @test Species("³H⁺") == Species("H", 1, 3)
  @test Species("¹⁵N³⁻") == Species("N", -3, 15)
  @test Species("⁴He") == Species("He", 0, 4)
  @test Species("²³⁶U⁺") == Species("U", 1, 236)
end

end

module APCdefWithChangedName
using AtomicAndPhysicalConstants.CODATA2022
using Test

# test default APCdef settings
@APCdef name = ABC
@testset "test name definition" begin
  #constants should be of type float in the right unit
  @test ABC.C_LIGHT ≈ 2.99792458e8
  @test ABC.H_PLANCK ≈ 4.135667696e-15
  @test ABC.H_BAR_PLANCK ≈ 6.582119568038699e-16
  @test ABC.R_E ≈ 2.8179403205e-15
  @test ABC.R_P ≈ 1.5346982640795807e-18
  @test ABC.E_CHARGE ≈ 1
  @test ABC.MU_0_VAC ≈ 1.25663706127e-6
  @test ABC.EPS_0_VAC ≈ 8.8541878188e-12
  @test ABC.CLASSICAL_RADIUS_FACTOR ≈ 1.4399645468825422e-9
  @test ABC.FINE_STRUCTURE ≈ 0.0072973525643
  @test ABC.N_AVOGADRO ≈ 6.02214076e23
end

end

module APCdefWithDifferentUnitSystem
using AtomicAndPhysicalConstants.CODATA2022
using Test

# test default APCdef settings
@APCdef unitsystem = MKS
@testset "test constants" begin
  #constants should be of type float in the right unit
  @test APC.C_LIGHT ≈ 2.99792458e8
  @test APC.H_PLANCK ≈ 6.626070148519815e-34
  @test APC.H_BAR_PLANCK ≈ 1.0545718174105777e-34
  @test APC.R_E ≈ 2.8179403205e-15
  @test APC.R_P ≈ 1.5346982640795807e-18
  @test APC.E_CHARGE ≈ 1.602176634e-19
  @test APC.MU_0_VAC ≈ 1.25663706127e-6
  @test APC.EPS_0_VAC ≈ 8.8541878188e-12
  @test APC.CLASSICAL_RADIUS_FACTOR ≈ 2.5669699662216776e-45
  @test APC.FINE_STRUCTURE ≈ 0.0072973525643
  @test APC.N_AVOGADRO ≈ 6.02214076e23
end

end
module DefaultAPCDef
using AtomicAndPhysicalConstants
using Test

@testset "Constants Access and Values" begin

  # Test exact values from CODATA 2022
  # Masses are stored in eV/c^2
  @test m_electron[] ≈ 0.51099895069e6  # electron mass in eV/c^2
  @test m_proton[] ≈ 9.382720894300001e8  # proton mass in eV/c^2
  @test m_neutron[] ≈ 9.395654219399999e8  # neutron mass in eV/c^2
  @test m_muon[] ≈ 1.056583755e8  # muon mass in eV/c^2
  @test m_deuteron[] ≈ 1.875612945e9  # deuteron mass in eV/c^2
  @test m_helion[] ≈ 2.80839161112e9  # helion mass in eV/c^2

  # Test magnetic moments (in J/T)
  @test mu_electron[] ≈ -9.2847646917e-24
  @test mu_proton[] ≈ 1.41060679545e-26
  @test mu_neutron[] ≈ -9.6623653e-27
  @test mu_muon[] ≈ -4.4904483e-26
  @test mu_deuteron[] ≈ 4.330735087e-27
  @test mu_triton[] ≈ 1.5046095178e-26

  # Test dimensionless constants
  @test N_Avogadro[] ≈ 6.02214076e23
  @test fine_structure[] ≈ 0.0072973525643
  @test gyro_anom_electron[] ≈ 1.15965218046e-3
  @test gyro_anom_muon[] ≈ 1.16592062e-3

  # Test g-factors
  @test gspin_electron[] ≈ -2.00231930436092
  @test gspin_proton[] ≈ 5.5856946893
  @test gspin_neutron[] ≈ -3.82608552
  @test gspin_muon[] ≈ -2.00233184123
  @test gspin_deuteron[] ≈ 0.8574382335
  @test gspin_triton[] ≈ 5.957924930

  # Test other physical constants
  @test e_charge[] ≈ 1.602176634e-19  # elementary charge in C
  @test c_light[] ≈ 2.99792458e8  # speed of light in m/s
  @test h_Planck[] ≈ 6.62607015e-34  # Planck constant in J*s
  @test h_bar_Planck[] ≈ 6.62607015e-34 / 2 / pi  # reduced Planck constant
  @test r_e[] ≈ 2.8179403205e-15  # classical electron radius in m
  @test eps_0_vac[] ≈ 8.8541878188e-12  # permittivity of free space in F/m
  @test mu_0_vac[] ≈ 1.25663706127e-6  # vacuum permeability in N/A^2
  @test RELEASE_YEAR[] == 2022
end

@testset "Getter Functions" begin
  # Create test species
  e = Species("electron")
  C = Species("12C")

  # Test nameof function
  @test nameof(e) == "electron"
  @test nameof(C) == "C"

  # Test chargeof function
  @test chargeof(e) == -1
  @test chargeof(C) == 0

  # Test massof function
  @test massof(e) ≈ 0.51099895069 # unit should be MeV/c^2
  @test massof(C) ≈ 12 # unit should be amu

  # Test spinof function
  @test spinof(e) == 0.5
  @test spinof(C) == 6.0

  # Test momentof function
  @test momentof(e) ≈ -9.2847646917e-24

  # Test isoof function
  @test isoof(C) == 12

end

end  # module

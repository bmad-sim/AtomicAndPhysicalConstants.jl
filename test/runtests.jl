module APCtest
using AtomicAndPhysicalConstants
using Test

@testset "Constant Access and Values" begin

  # Test exact values from CODATA 2022
  # Masses are stored in eV/c^2
  @test M_ELECTRON ≈ 0.51099895069e6  # electron mass in eV/c^2
  @test M_PROTON ≈ 9.382720894300001e8  # proton mass in eV/c^2
  @test M_NEUTRON ≈ 9.395654219399999e8  # neutron mass in eV/c^2
  @test M_MUON ≈ 1.056583755e8  # muon mass in eV/c^2
  @test M_DEUTERON ≈ 1.875612945e9  # deuteron mass in eV/c^2
  @test M_HELION ≈ 2.80839161112e9  # helion mass in eV/c^2

  # Test magnetic moments (in EV_PER_J/T)
  @test MU_ELECTRON ≈ -9.2847646917e-24 * EV_PER_J
  @test MU_PROTON ≈ 1.41060679545e-26 * EV_PER_J
  @test MU_NEUTRON ≈ -9.6623653e-27 * EV_PER_J
  @test MU_MUON ≈ -4.4904483e-26 * EV_PER_J
  @test MU_DEUTERON ≈ 4.330735087e-27 * EV_PER_J
  @test MU_TRITON ≈ 1.5046095178e-26 * EV_PER_J

  # Test dimensionless constants
  @test AVOGADRO ≈ 6.02214076e23
  @test FINE_STRUCTURE ≈ 0.0072973525643
  @test ANOMALY_ELECTRON ≈ 1.15965218046e-3
  @test ANOMALY_MUON ≈ 1.16592062e-3

  # Test g-factors
  @test G_ELECTRON ≈ -2.00231930436092
  @test G_PROTON ≈ 5.5856946893
  @test G_NEUTRON ≈ -3.82608552
  @test G_MUON ≈ -2.00233184123
  @test G_DEUTERON ≈ 0.8574382335
  @test G_TRITON ≈ 5.957924930

  # Test other physical constants
  @test E_CHARGE ≈ 1.602176634e-19  # elementary charge in C
  @test C_LIGHT ≈ 2.99792458e8  # speed of light in m/s
  @test H_PLANCK ≈ 4.135667696e-15  # Planck constant in J*s
  @test H_BAR ≈ 6.582119569e-16  # reduced Planck constant
  @test R_ELECTRON ≈ 2.8179403205e-15  # classical electron radius in m
  @test EPS_0 ≈ 8.8541878188e-12  # permittivity of free space in F/m
  @test MU_0 ≈ 1.25663706127e-6  # vacuum permeability in N/A^2
  @test RELEASE_YEAR == 2022
end

@testset "getfield tests" begin
  # Create test species
  e = Species("electron")
  C = Species("12C")
  nas = Species()

  # Test nameof function
  @test nameof(e) == "electron"
  @test nameof(C) == "C"

  # Test chargeof function
  @test chargeof(e) == -1
  @test chargeof(C) == 0

  # Test massof function
  @test massof(e) ≈ 0.51099895069e6 # unit should be eV/c^2
  @test massof(C, AMU=true) ≈ 12 # unit should be amu

  # Test spinof function
  @test spinof(e) == 0.5
  @test spinof(C) == 6.0

  @test gspin_of(e, signed=true) ≈ G_ELECTRON
  
  @test gyromagnetic_anomaly(e) ≈ ANOMALY_ELECTRON

  # Test momentof function
  @test momentof(e) ≈ -9.2847646917e-24 * EV_PER_J

  # Test isoof function
  @test iso_of(C) == 12
  @test isnullspecies(C) == false
  @test isnullspecies(e) == false
  @test isnullspecies(nas) == true


end

end  # module

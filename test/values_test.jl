# test/constant_test.jl

@testset "Constant Access and Values" begin

  # Test exact values from CODATA 2022
  # Masses are stored in eV/c^2
  @test M_ELECTRON ≈ 0.51099895069e6  # electron mass in eV/c^2
  @test M_PROTON ≈ 9.382720894300001e8  # proton mass in eV/c^2
  @test M_NEUTRON ≈ 9.395654219399999e8  # neutron mass in eV/c^2
  @test M_MUON ≈ 1.056583755e8  # muon mass in eV/c^2
  @test M_DEUTERON ≈ 1.875612945e9  # deuteron mass in eV/c^2
  @test M_HELION ≈ 2.80839161112e9  # helion mass in eV/c^2
  @test M_PION_0 ≈ 1.349768277676847e8
  @test M_PION_CHARGED ≈ 1.3957039098368132e8

  # Test magnetic moments (in EV_PER_J/T)
  @test MU_ELECTRON ≈ -9.2847646917e-24 * EV_PER_J
  @test MU_PROTON ≈ 1.41060679545e-26 * EV_PER_J
  @test MU_NEUTRON ≈ -9.6623653e-27 * EV_PER_J
  @test MU_MUON ≈ -4.4904483e-26 * EV_PER_J
  @test MU_DEUTERON ≈ 4.330735087e-27 * EV_PER_J
  @test MU_TRITON ≈ 1.5046095178e-26 * EV_PER_J
  @test MU_HELION ≈ -1.07461755198e-26 * EV_PER_J

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
  @test G_HELION ≈ -4.2552506995

  # Test other physical constants
  @test E_CHARGE ≈ 1.602176634e-19  # elementary charge in C
  @test C_LIGHT ≈ 2.99792458e8  # speed of light in m/s
  @test H_PLANCK ≈ 4.135667696e-15  # Planck constant in J*s
  @test H_BAR ≈ 6.582119569e-16  # reduced Planck constant
  @test R_ELECTRON ≈ 2.8179403205e-15  # classical electron radius in m
  @test R_PROTON ≈ 1.5346982640795807e-18
  @test CLASSICAL_RADIUS_FACTOR ≈ 1.4399645468825422e-15
  @test EPS_0 ≈ 5.5263493618e7  # permittivity of free space in 1/(eV*m)
  @test MU_0 ≈ 2.0133545370e-25  # vacuum permeability in eV*s^2/m
  @test isapprox(K_BOLTZMANN, 8.61733e-5, atol=2e-10)
  @test RELEASE_YEAR == 2022

  # Test conversion constants
  @test EV_PER_AMU ≈ 9.3149410372e8
  @test J_PER_EV ≈ 1.602176634e-19
  @test EV_PER_J ≈ 6.241509074e18
  @test G_PER_EV ≈ 1.7826619216279e-33
  @test KG_PER_AMU ≈ 1.6605390689200003e-27
  @test KG_PER_MEV_C2 ≈ 1.7826619216279e-30
  @test KG_PER_MEV_C2 ≈ G_PER_EV * 1e3
end



@testset "CODATA releases" begin
  # Every supported release year is present and self-consistent
  for (year, codata) in AtomicAndPhysicalConstants.CODATA_MAP
    @test codata.RELEASE_YEAR == parse(Int, year)
  end
  @test Set(keys(AtomicAndPhysicalConstants.CODATA_MAP)) ==
        Set(["2002", "2006", "2010", "2014", "2018", "2022"])
  @test isconst(AtomicAndPhysicalConstants, :CODATA_MAP)

  # Currently active release matches CODATA2022 (the default)
  @test RELEASE_YEAR == CODATA2022.RELEASE_YEAR
  @test M_ELECTRON == CODATA2022.M_ELECTRON

  # set_release: invalid year is rejected, valid years do not throw
  @test_throws ArgumentError set_release(year="9999")
  @test set_release(year="2014") === nothing
  @test set_release() === nothing  # reset to default
end

@testset "Kind enum" begin
  @test Kind.ATOM != Kind.HADRON != Kind.LEPTON != Kind.PHOTON != Kind.NULL
  @test kindof(Species("electron")) == Kind.LEPTON
  @test kindof(Species("proton")) == Kind.HADRON
  @test kindof(Species("photon")) == Kind.PHOTON
  @test kindof(Species("H")) == Kind.ATOM
  @test kindof(Species()) == Kind.NULL
end

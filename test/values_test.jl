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
  @test G_NEUTRON ≈ -3.82608552 * M_NEUTRON / M_PROTON
  @test G_MUON ≈ -2.00233184123
  @test G_DEUTERON ≈ 0.8574382335 * M_DEUTERON / M_PROTON
  @test G_TRITON ≈ 5.957924930 * M_TRITON / M_PROTON
  @test G_HELION ≈ -4.2552506995 * M_HELION / M_PROTON

  # Test other physical constants
  @test E_CHARGE ≈ 1.602176634e-19  # elementary charge in C
  @test C_LIGHT ≈ 2.99792458e8  # speed of light in m/s
  @test H_PLANCK ≈ 4.135667696e-15  # Planck constant in J*s
  @test H_BAR ≈ 6.582119569e-16  # reduced Planck constant
  @test R_ELECTRON ≈ 2.8179403205e-15  # classical electron radius in m
  @test R_PROTON ≈ 1.5346982640795807e-18
  @test CLASSICAL_RADIUS_FACTOR ≈ 1.4399645468825422e-9
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

  # Exactly the quantities NIST does not tabulate for a release are NaN
  # (docs/src/codata.md, "Quantities missing from a release")
  untabulated = Dict(
    "2002" => Set([:M_TRITON, :MU_HELION, :MU_TRITON,
                   :G_DEUTERON_NUCLEAR_MAGNETON, :G_HELION_NUCLEAR_MAGNETON,
                   :G_TRITON_NUCLEAR_MAGNETON]),
    "2006" => Set([:MU_HELION, :G_HELION_NUCLEAR_MAGNETON]))
  for (year, codata) in AtomicAndPhysicalConstants.CODATA_MAP
    nan = Set(f for f in fieldnames(typeof(codata)) if getfield(codata, f) isa Float64 && isnan(getfield(codata, f)))
    @test nan == get(untabulated, year, Set{Symbol}())
  end

  # Each release carries its own values, read from the NIST tables
  @test CODATA2002.ANOMALY_ELECTRON ≈ 1.1596521859e-3
  @test CODATA2002.E_CHARGE ≈ 1.60217653e-19
  @test CODATA2006.M_ELECTRON ≈ 0.510998910e6
  @test CODATA2014.M_HELION ≈ 2808.391586e6
  @test CODATA2014.M_DEUTERON ≈ 1875.612928e6
  @test CODATA2014.G_PER_AMU ≈ 1.660539040e-24
  @test CODATA2018.M_ELECTRON ≈ 0.51099895000e6

  # Pion masses come from the PDG edition of the same year (PDG fit values)
  pions = Dict(
    "2002" => (134.9766175723e6, 139.5701807883e6),
    "2006" => (134.9766175723e6, 139.5701807883e6),
    "2010" => (134.9766175723e6, 139.5701807883e6),
    "2014" => (134.9766175723e6, 139.5701807883e6),
    "2018" => (134.9770445889e6, 139.5706078049e6),
    "2022" => (134.9768277677e6, 139.5703909837e6))
  for (year, codata) in AtomicAndPhysicalConstants.CODATA_MAP
    @test codata.M_PION_0 ≈ pions[year][1]
    @test codata.M_PION_CHARGED ≈ pions[year][2]
  end

  # With no release preference set, the active release is the most recent one
  @test AtomicAndPhysicalConstants._LATEST_RELEASE ==
        string(maximum(parse.(Int, keys(AtomicAndPhysicalConstants.CODATA_MAP))))
  latest = AtomicAndPhysicalConstants.CODATA_MAP[AtomicAndPhysicalConstants._LATEST_RELEASE]
  @test RELEASE_YEAR == latest.RELEASE_YEAR
  @test M_ELECTRON == latest.M_ELECTRON

  # Exact constants are the exact value rounded once, not the truncated digits
  # NIST prints for them ("1.782 661 921... e-36")
  e, h, k, c = big"1.602176634e-19", big"6.62607015e-34", big"1.380649e-23", big"299792458"
  for (year, codata) in AtomicAndPhysicalConstants.CODATA_MAP
    if codata.RELEASE_YEAR >= 2018  # 2019 SI: e, h, c, and k are exact
      @test codata.H_PLANCK == Float64(h / e)
      @test codata.H_BAR == Float64(h / (2 * big(pi) * e))
      @test codata.K_BOLTZMANN == Float64(k / e)
      @test codata.EV_PER_J == Float64(1 / e)
      @test codata.G_PER_EV == Float64(1000 * e / c^2)
    else            # before: mu_0 = 4 pi 1e-7 and eps_0 = 1/(mu_0 c^2) are exact
      @test codata.MU_0 ≈ 4pi * 1e-7 * codata.E_CHARGE rtol = 4eps()
      @test codata.EPS_0 ≈ 1 / (4pi * 1e-7 * codata.C_LIGHT^2 * codata.E_CHARGE) rtol = 4eps()
    end
  end

  # set_release: invalid year is rejected, valid years do not throw.
  # set_release writes LocalPreferences.toml beside the active project, and may
  # list the package under [extras] in its Project.toml, so both files are put
  # back exactly as they were, or removed if they did not exist.
  project = Base.active_project()
  snapshot = Dict(f => (isfile(f) ? read(f) : nothing) for f in
    [project; [joinpath(dirname(project), n) for n in Base.preferences_names]])
  # The preference as written to the active project's preferences file, which
  # is where set_release writes; Preferences.load_preference would also see
  # settings inherited from environments further up the load path.
  function written_release()
    files = filter(isfile, [joinpath(dirname(project), n) for n in Base.preferences_names])
    isempty(files) && return nothing
    prefs = TOML.parsefile(last(files))
    return get(get(prefs, "AtomicAndPhysicalConstants", Dict()), "release", nothing)
  end
  try
    @test_throws ArgumentError set_release(year="9999")
    @test set_release(year="2014") === nothing
    @test written_release() == "2014"
    # no argument removes the setting, so the default (most recent) applies
    @test set_release() === nothing
    @test written_release() === nothing
  finally
    for (f, bytes) in snapshot
      bytes === nothing ? rm(f; force=true) : write(f, bytes)
    end
  end
end

@testset "Kind enum" begin
  @test Kind.ATOM != Kind.HADRON != Kind.LEPTON != Kind.PHOTON != Kind.NULL
  @test kindof(Species("electron")) == Kind.LEPTON
  @test kindof(Species("proton")) == Kind.HADRON
  @test kindof(Species("photon")) == Kind.PHOTON
  @test kindof(Species("H")) == Kind.ATOM
  @test kindof(Species()) == Kind.NULL
end

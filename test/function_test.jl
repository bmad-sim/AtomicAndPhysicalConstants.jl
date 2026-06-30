# test/function_test.jl


@testset "getfield tests" begin
  # Create test species
  e = Species("electron")
  C = Species("12C")
  nas = Species()

  # Test nameof function
  @test nameof(e) == "electron"
  @test nameof(C) == "#12C"

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

@testset "Getter functions: charge, mass, spin, moment" begin
  proton = Species("proton")
  e = Species("electron")
  H = Species("H")

  # chargeof: default e-multiples vs. Coulombs
  @test chargeof(proton) == 1.0
  @test chargeof(proton; C=false) == 1.0
  @test chargeof(proton; C=true) ≈ E_CHARGE
  @test chargeof(e; C=true) ≈ -E_CHARGE

  # massof: eV/c^2 vs AMU
  @test massof(proton) ≈ M_PROTON
  @test massof(H, AMU=true) ≈ 1.0079407540557772

  # spinof
  @test spinof(Species("photon")) == 1.0
  @test spinof(proton) == 0.5

  # gspin_of: signed vs abs
  @test gspin_of(e) ≈ abs(G_ELECTRON)
  @test gspin_of(e; signed=true) ≈ G_ELECTRON
  @test gspin_of(H) == 0.0  # atoms have no stored g-factor

  # momentof: subatomic vs atom/null (always Float64, never 0::Int)
  @test momentof(proton) ≈ MU_PROTON
  @test momentof(H) === 0.0
  @test momentof(Species()) === 0.0
end

@testset "gyromagnetic_anomaly" begin
  @test gyromagnetic_anomaly(Species("electron")) ≈ ANOMALY_ELECTRON
  @test gyromagnetic_anomaly(Species("muon")) ≈ ANOMALY_MUON
  @test gyromagnetic_anomaly(Species("proton")) ≈ (G_PROTON - 2.0) / 2.0

  # not defined for photons, atoms, or the null species -> NaN
  @test isnan(gyromagnetic_anomaly(Species("photon")))
  @test isnan(gyromagnetic_anomaly(Species("H")))
  @test isnan(gyromagnetic_anomaly(Species()))
end

@testset "nameof" begin
  @test nameof(Species("electron")) == "electron"
  @test nameof(Species("Fe")) == "Fe"
  @test nameof(Species("4He+2")) == "#4He+2"
  @test nameof(Species("Li+")) == "Li+1"
  @test nameof(Species("K-2")) == "K-2"
  @test nameof(Species("H")) == "H"

  # round-trips through the string constructor for charged/isotope/anti species
  for spec in ("H", "4He", "Li+3", "K-2", "Fe+10", "anti-H", "anti-4He")
    s = Species(spec)
    n = nameof(s)
    s2 = Species(n)
    @test nameof(s2) == n
    @test chargeof(s2) == chargeof(s)
    @test iso_of(s2) == iso_of(s)
  end
end

@testset "Helper functions" begin
  # chargeparse
  cp = AtomicAndPhysicalConstants.chargeparse
  @test cp("") == 0
  @test cp("+") == 1
  @test cp("++") == 2
  @test cp("+++") == 3
  @test cp("+5") == 5
  @test cp("-") == -1
  @test cp("--") == -2
  @test cp("---") == -3
  @test cp("-5") == -5
  @test_throws ErrorException cp("++++")   # repeated signs capped at 3
  @test_throws ErrorException cp("+abc")
  @test_throws ErrorException cp("abc")    # must start with +/-

  # find_superscript / normalize_superscripts round-trip
  fs = AtomicAndPhysicalConstants.find_superscript
  ns = AtomicAndPhysicalConstants.normalize_superscripts
  for n in (0, 4, 12, 118)
    @test ns(fs(n)) == string(n)
  end
  @test fs(123) == "¹²³"
  @test ns("⁴He") == "4He"
  @test ns("Li⁺") == "Li+"
  @test ns("Li⁻") == "Li-"

  # g_spin: not used to derive any of the real SUBATOMIC_SPECIES g-factors
  # (those are all stored as literals, including 0.0 for the spin-0 pions, to
  # avoid the 0/0 = NaN this formula produces for zero spin/charge/moment), so
  # we only check the properties that are guaranteed by its formula rather
  # than asserting it reproduces a specific particle's published g-factor.
  gs = AtomicAndPhysicalConstants.g_spin
  @test isnan(gs(M_PION_0, 0.0, 0.0, 0.0))   # 0/0 is mathematically still NaN
  @test gs(M_PROTON, 2.0, 0.5, 1.0) ≈ 2 * gs(M_PROTON, 1.0, 0.5, 1.0)  # linear in moment
  @test gs(M_PROTON, 1.0, 0.5, 1.0) ≈ -gs(M_PROTON, 1.0, 0.5, -1.0)    # odd in charge
end

@testset "Base.show" begin
  @test sprint(show, MIME("text/plain"), Species()) == "Species(Null)"

  out = sprint(show, MIME("text/plain"), Species("Li+3"))
  @test occursin("Species: Li", out)
  @test occursin("Charge: 3 e", out)  # displayed as an integer, not 3.0
  @test occursin("Kind: ATOM", out)

  out_iso = sprint(show, MIME("text/plain"), Species("anti-4He"))
  @test occursin("Atomic Number: -2", out_iso)  # does not crash for anti-atoms
end

# test/species_test.jl

@testset "Species construction: subatomic particles" begin
  # every entry in SUBATOMIC_SPECIES round-trips through Species(name)
  for (name, particle) in AtomicAndPhysicalConstants.SUBATOMIC_SPECIES
    s = Species(name)
    @test chargeof(s) == particle.charge
    @test massof(s) == particle.mass
    @test spinof(s) == particle.spin
    @test gspin_of(s; signed=true) == particle.gspin
    @test momentof(s) == particle.moment
    @test iso_of(s) == 0
    @test nameof(s) == name
  end

  @test kindof(Species("photon")) == Kind.PHOTON
  for name in ("electron", "positron", "muon", "anti-muon")
    @test kindof(Species(name)) == Kind.LEPTON
  end
  for name in ("proton", "anti-proton", "neutron", "anti-neutron",
               "pion0", "pion+", "pion-", "deuteron", "anti-deuteron",
               "triton", "anti-triton", "helion", "anti-helion")
    @test kindof(Species(name)) == Kind.HADRON
  end

  # helion / anti-helion are doubly charged, and the anti-particle only flips
  # the sign of the charge
  @test chargeof(Species("helion")) == 2
  @test chargeof(Species("anti-helion")) == -2
  @test massof(Species("anti-helion")) == massof(Species("helion")) == M_HELION
  @test gspin_of(Species("helion"); signed=true) == G_HELION

  # anti-neutron g-factor must match the neutron's, not the electron's
  @test AtomicAndPhysicalConstants.SUBATOMIC_SPECIES["anti-neutron"].gspin == G_NEUTRON
  @test gspin_of(Species("anti-neutron"); signed=true) == G_NEUTRON

  # pions are spin-0, so their g-factor is conventionally 0, not NaN
  for name in ("pion0", "pion+", "pion-")
    @test gspin_of(Species(name)) == 0.0
  end
end



@testset "Species construction: atomic species" begin
  H = Species("H")
  @test chargeof(H) == 0.0
  @test iso_of(H) == -1  # abundance average
  @test atomicnumberof(H) == 1
  @test massof(H, AMU=true) ≈ 1.0079407540557772

  # mass-number prefix notations are equivalent
  he4_hash = Species("#4He")
  he4_super = Species("⁴He")
  @test massof(he4_hash) == massof(he4_super)
  @test iso_of(he4_hash) == iso_of(he4_super) == 4
  # a bare ASCII mass number requires the `#` prefix
  @test_throws ErrorException Species("4He")

  # multi-letter symbols and high-Z elements
  Fe = Species("Fe")
  @test atomicnumberof(Fe) == 26
  Og = Species("Og")
  @test atomicnumberof(Og) == 118

  # isotope mass is exact (12C defines the amu scale)
  C12 = Species("#12C")
  @test massof(C12, AMU=true) ≈ 12.0
  @test spinof(C12) == 6.0  # 0.5 * iso

  # charge notations
  @test chargeof(Species("Li+3")) == 3.0
  @test chargeof(Species("Li+++")) == 3.0
  @test chargeof(Species("K-2")) == -2.0
  @test chargeof(Species("Fe+10")) == 10.0
  @test chargeof(Species("H+1")) == 1.0  # charge == Z is allowed
  @test chargeof(Species("H")) == 0.0

  # ionization changes mass by exactly one electron mass per unit charge
  @test massof(Species("H+1")) ≈ massof(Species("H")) - M_ELECTRON atol=1e-6

  # anti-atoms
  antiH = Species("anti-H")
  @test kindof(antiH) == Kind.ATOM
  @test nameof(antiH) == "anti-H"
  @test atomicnumberof(antiH) == -1  # negative Z distinguishes anti-atoms
  @test atomicnumberof(Species("anti-#4He")) == -2
end


@testset "Species construction: null species" begin
  for s in (Species(), Species("Null"), Species("null"), Species(""))
    @test isnullspecies(s)
    @test kindof(s) == Kind.NULL
    @test chargeof(s) == 0.0
    @test massof(s) == 0.0
  end
  @test !isnullspecies(Species("electron"))
  @test !isnullspecies(Species("H"))

  # the null species round-trips through its own canonical name
  @test nameof(Species()) == "Null"
  @test isnullspecies(Species(nameof(Species())))
end

@testset "Species construction: errors" begin
  @test_throws ErrorException Species("Xx")              # not a known species
  @test_throws ErrorException Species("#999H")            # invalid isotope
  @test_throws ErrorException Species("3He")              # ASCII mass number requires '#'
  @test_throws ErrorException Species("Li+-")              # ambiguous charge
  @test_throws ErrorException Species("H+2")               # charge exceeds Z
  @test_throws ErrorException Species("Li1")               # missing +/- specifier
  @test_throws ErrorException atomicnumberof(Species("electron"))  # non-atom
  @test_throws ErrorException Species("H").charge          # direct field access disabled
end

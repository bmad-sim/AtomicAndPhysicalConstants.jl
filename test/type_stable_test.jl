# test/type_stable_test.jl


@testset "Type stability" begin
  e = Species("electron")
  H = Species("H")

  @test (@inferred chargeof(e)) isa Float64
  @test (@inferred chargeof(e; C=true)) isa Float64
  @test (@inferred massof(e)) isa Float64
  @test (@inferred massof(e; AMU=true)) isa Float64
  @test (@inferred spinof(e)) isa Float64
  @test (@inferred gspin_of(e)) isa Float64
  @test (@inferred gyromagnetic_anomaly(e)) isa Float64
  @test (@inferred momentof(e)) isa Float64
  @test (@inferred momentof(H)) isa Float64  # must not be Union{Float64,Int}
  @test (@inferred iso_of(e)) isa Int
  @test (@inferred kindof(e)) isa AtomicAndPhysicalConstants.Kind.T
  @test (@inferred atomicnumberof(H)) isa Int
  @test (@inferred isnullspecies(e)) isa Bool
  @test (@inferred nameof(e)) isa String
  @test (@inferred Species("electron")) isa Species
  @test (@inferred Species("#4He")) isa Species
end


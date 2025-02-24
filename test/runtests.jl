using AtomicAndPhysicalConstants
using Test



@testset "AtomicAndPhysicalConstants.jl" begin
    # Write your tests here.
end

# test default APCdef settings
@APCdef

@testset "testAPCdef" begin
    #constants should be of type float in the right unit
    @test C_LIGHT ≈ 2.99792458e8
    @test H_PLANCK ≈ 4.135667696e-15
    @test H_BAR_PLANCK ≈ 6.582119568038699e-16
    @test R_E ≈ 2.8179403205e-15
    @test R_P ≈ 1.5346982640795807e-18
    @test E_CHARGE ≈ 1
    @test MU_0_VAC ≈ 1.25663706127e-6
    @test EPS_0_VAC ≈ 8.8541878188e-12
    @test CLASSICAL_RADIUS_FACTOR ≈ 1.4399645468825422e-15
    @test FINE_STRUCTURE ≈ 0.0072973525643
    @test N_AVOGADRO ≈ 6.02214076e23

    #test massof() and chargeof()
    H = Species("H")

    @test massof(H) ≈ 9.394018682512946e8
    @test chargeof(H) ≈ 0

    e = Species("electron")
    @test massof(e) ≈ 510998.95069
    @test chargeof(e) ≈ -1
end

@testset "testSpecies" begin
    #test '+' and '-' signs to charge
    @test chargeof(Species("H+")) ≈ 1
    @test chargeof(Species("Mg++")) ≈ 2
    @test chargeof(Species("Al+3")) ≈ 3
    @test chargeof(Species("Cl-")) ≈ -1
    @test chargeof(Species("O--")) ≈ -2
    @test chargeof(Species("N-3")) ≈ -3
end

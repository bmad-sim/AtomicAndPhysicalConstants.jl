using Test
using AtomicAndPhysicalConstants

@testset "APClite Tests" begin
    @testset "Constants" begin
        @test C_LIGHT ≈ 2.99792458e8
        @test H_PLANCK ≈ 6.62607015e-34
        @test M_ELECTRON ≈ 0.51099895069
        @test M_PROTON ≈ 938.27208816
        @test FINE_STRUCTURE ≈ 0.0072973525643
    end
    
    @testset "Species Creation" begin
        # Subatomic particles
        e = Species("electron")
        @test nameof(e) == "electron"
        @test e.charge == -1.0
        @test e.mass ≈ M_ELECTRON
        @test e.spin == 0.5
        @test e.kind == LEPTON
        
        p = Species("proton")
        @test nameof(p) == "proton"
        @test p.charge == 1.0
        @test p.mass ≈ M_PROTON
        @test p.kind == HADRON
        
        # Anti-particles
        anti_p = Species("anti-proton")
        @test nameof(anti_p) == "anti-proton"
        @test anti_p.charge == -1.0
        @test anti_p.mass ≈ M_PROTON
        
        # Photon
        photon = Species("photon")
        @test nameof(photon) == "photon"
        @test photon.charge == 0.0
        @test photon.mass == 0.0
        @test photon.kind == PHOTON
    end
    
    @testset "Atomic Species" begin
        # Hydrogen
        h = Species("H")
        @test nameof(h, basename=true) == "H"
        @test h.charge == 0.0
        @test h.kind == ATOM
        
        # Hydrogen ion
        h_plus = Species("H+")
        @test nameof(h_plus, basename=true) == "H"
        @test nameof(h_plus, basename=false) == "H+1"
        @test h_plus.charge == 1.0
        
        # Carbon
        c = Species("C")
        @test nameof(c, basename=true) == "C"
        @test c.kind == ATOM
        
        # Carbon isotope
        c12 = Species("C12")
        @test nameof(c12, basename=true) == "C"
        @test nameof(c12, basename=false) == "#12C"
        @test c12.iso == 12
    end
    
    @testset "Null Species" begin
        null_species = Species("")
        @test nameof(null_species) == "Null"
        @test null_species.kind == NULL
        
        null_species2 = Species("null")
        @test nameof(null_species2) == "Null"
    end
    
    @testset "Error Handling" begin
        @test_throws ErrorException Species("nonexistent")
        @test_throws ErrorException Species("H++-")  # Invalid charge format
    end
end

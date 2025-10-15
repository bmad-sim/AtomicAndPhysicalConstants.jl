using Test
using AtomicAndPhysicalConstants

@testset "APClite Tests" begin
    @testset "Constants" begin
        @test C_LIGHT ≈ 2.99792458e8
        @test H_PLANCK ≈ 6.62607015e-34
        @test M_ELECTRON ≈ 0.51099895069e6
        @test M_PROTON ≈ 938.27208816e6
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
        c12 = Species("12C")
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
    
    @testset "Isotope Format Parsing" begin
        # Test single digit isotopes
        c12 = Species("12C")
        @test c12.iso == 12
        @test nameof(c12, basename=true) == "C"
        @test nameof(c12, basename=false) == "#12C"
        
        # Test with # prefix
        c12_hash = Species("#12C")
        @test c12_hash.iso == 12
        @test nameof(c12_hash, basename=false) == "#12C"

        # Test no isotope number
        c = Species("C")
        @test c.iso == -1.0
        @test nameof(c, basename=true) == "C"
        @test nameof(c, basename=false) == "C"
    end
    
    @testset "Charge Format Parsing" begin
        # Test all positive charge formats
        c_plus = Species("C+")
        @test c_plus.charge == 1.0
        
        c_plus_plus = Species("C++")
        @test c_plus_plus.charge == 2.0
        
        c_plus_3 = Species("C+3")
        @test c_plus_3.charge == 3.0
        
        c_3_plus = Species("C3+")
        @test c_3_plus.charge == 3.0
        
        # Test all negative charge formats
        c_minus = Species("C-")
        @test c_minus.charge == -1.0
        
        c_minus_minus = Species("C--")
        @test c_minus_minus.charge == -2.0
        
        c_minus_2 = Species("C-2")
        @test c_minus_2.charge == -2.0
        
        c_2_minus = Species("C2-")
        @test c_2_minus.charge == -2.0
        
        # Test with isotopes
        c12_plus = Species("12C+")
        @test c12_plus.charge == 1.0
        @test c12_plus.iso == 12
        
        c12_3_plus = Species("12C3+")
        @test c12_3_plus.charge == 3.0
        @test c12_3_plus.iso == 12
        
        c12_minus_2 = Species("12C-2")
        @test c12_minus_2.charge == -2.0
        @test c12_minus_2.iso == 12
        
        # Test with # prefix isotopes
        c_hash_12_plus = Species("#12C+")
        @test c_hash_12_plus.charge == 1.0
        @test c_hash_12_plus.iso == 12
    end
    
    @testset "Error Handling" begin
        @test_throws ErrorException Species("nonexistent")
        @test_throws ErrorException Species("H++-")  # Invalid charge format (both + and -)
        @test_throws ErrorException Species("C12")   # Invalid format (isotope not on left)
        @test_throws ErrorException Species("Habc")  # Invalid characters after symbol
        @test_throws ErrorException Species("abcC")  # Invalid characters before symbol
        @test_throws ErrorException Species("H++")   # Unphysical charge (H can only be +1)
        @test_throws ErrorException Species("999C")  # Invalid isotope number
    end
end

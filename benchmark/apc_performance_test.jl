using AtomicAndPhysicalConstants
using BenchmarkTools

# Configure APC to expose Float constants and helper functions
@APCdef

println("=== AtomicAndPhysicalConstants Performance Benchmark (Float) ===")
println()

# Test 1: Accessing physical constants
println("1. Physical Constants Access:")
println("   Testing speed of accessing CODATA 2022 constants...")

const_benchmark = @benchmark begin
    c = APC.C_LIGHT
    h = APC.H_PLANCK
    e = APC.E_CHARGE
    fs = APC.FINE_STRUCTURE
    av = APC.N_AVOGADRO
    re = APC.R_E
    rp = APC.R_P
    eps = APC.EPS_0_VAC
    mu0 = APC.MU_0_VAC
end

println("   Constants access time: $(round(minimum(const_benchmark.times) / 1000, digits=3)) μs")
println()

# Test 2: Creating subatomic particles
println("2. Subatomic Particle Creation:")
println("   Testing speed of creating various subatomic particles...")

subatomic_benchmark = @benchmark begin
    e = Species("electron")
    p = Species("proton")
    n = Species("neutron")
    mu = Species("muon")
    pi0 = Species("pion0")
    pip = Species("pion+")
    pim = Species("pion-")
    d = Species("deuteron")
    photon = Species("photon")
end

println("   Subatomic particle creation time: $(round(minimum(subatomic_benchmark.times) / 1000, digits=3)) μs")
println()

# Test 3: Creating atomic species
println("3. Atomic Species Creation:")
println("   Testing speed of creating various atomic species...")

atomic_benchmark = @benchmark begin
    h = Species("H")
    he = Species("He")
    c = Species("C")
    o = Species("O")
    fe = Species("Fe")
    u = Species("U")
end

println("   Atomic species creation time: $(round(minimum(atomic_benchmark.times) / 1000, digits=3)) μs")
println()

# Test 4: Creating ions and isotopes
println("4. Ions and Isotopes Creation:")
println("   Testing speed of creating ions and isotopes...")

ion_benchmark = @benchmark begin
    h_plus = Species("H+")
    he_plus_plus = Species("He++")
    c_plus = Species("C+")
    o_minus = Species("O-")
    h1 = Species("H1")
    c12 = Species("C12")
    c13 = Species("C13")
    u235 = Species("U235")
    u238 = Species("U238")
end

println("   Ions and isotopes creation time: $(round(minimum(ion_benchmark.times) / 1000, digits=3)) μs")
println()

# Test 5: Accessing species properties
println("5. Species Property Access:")
println("   Testing speed of accessing species properties...")

e = Species("electron")
p = Species("proton")
h = Species("H")

property_benchmark = @benchmark begin
    charge_e = chargeof(e)
    mass_e = massof(e)
    spin_e = spinof(e)
    kind_e = kindof(e)
    
    charge_p = chargeof(p)
    mass_p = massof(p)
    spin_p = spinof(p)
    kind_p = kindof(p)
    
    charge_h = chargeof(h)
    mass_h = massof(h)
    kind_h = kindof(h)
    iso_h = isotopeof(h)
end

println("   Property access time: $(round(minimum(property_benchmark.times) / 1000, digits=3)) μs")
println()

# Test 6: Bulk operations
println("6. Bulk Operations:")
println("   Testing speed of creating many species at once...")

bulk_benchmark = @benchmark begin
    particles = [
        Species("electron"), Species("proton"), Species("neutron"),
        Species("muon"), Species("pion0"), Species("photon"),
        Species("H"), Species("He"), Species("C"), Species("O"),
        Species("H+"), Species("He++"), Species("C+"),
        Species("H1"), Species("C12"), Species("U235")
    ]
    
    # Access all properties
    for sp in particles
        chargeof(sp)
        massof(sp)
        kindof(sp)
    end
end

println("   Bulk operations time: $(round(minimum(bulk_benchmark.times) / 1000, digits=3)) μs")
println()

# Test 7: Memory usage
println("7. Memory Usage:")
println("   Testing memory allocation for species creation...")

memory_benchmark = @benchmark begin
    particles = Species[]
    for i in 1:1000
        push!(particles, Species("electron"))
    end
    particles
end

println("   Memory allocation for 1000 electrons: $(round(minimum(memory_benchmark.memory) / 1024, digits=2)) KB")
println()

# Test 8: Performance summary
println("8. Performance Summary:")
println("   - Constants access: $(round(minimum(const_benchmark.times) / 1000, digits=3)) μs")
println("   - Subatomic creation: $(round(minimum(subatomic_benchmark.times) / 1000, digits=3)) μs")
println("   - Atomic creation: $(round(minimum(atomic_benchmark.times) / 1000, digits=3)) μs")
println("   - Ion/isotope creation: $(round(minimum(ion_benchmark.times) / 1000, digits=3)) μs")
println("   - Property access: $(round(minimum(property_benchmark.times) / 1000, digits=3)) μs")
println("   - Bulk operations: $(round(minimum(bulk_benchmark.times) / 1000, digits=3)) μs")
println()



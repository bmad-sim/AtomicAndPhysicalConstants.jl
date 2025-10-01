using AtomicAndPhysicalConstants
using BenchmarkTools

println("=== APClite g_spin, gyromagnetic_anomaly, and g_factor Benchmarks ===")
println()

# Create test species
println("Setting up test species...")
predefined_species = [
    Species("electron"),
    Species("proton"), 
    Species("neutron"),
    Species("muon"),
    Species("deuteron")
]

# For calculated cases, we need particles not in G_FACTOR_MAP
# Let's create some hypothetical particles or use existing ones that would trigger calculation
calculated_species = [
    Species("positron"),  # Should trigger calculation path
    Species("pion+"),     # Should trigger calculation path  
    Species("pion-"),     # Should trigger calculation path
]

println("Test species created:")
println("  Predefined: $(length(predefined_species)) species")
println("  Calculated: $(length(calculated_species)) species")
println()

# Test 1: Predefined g_spin function calls
println("1. Predefined g_spin Function Performance:")
println("   Testing speed of g_spin for particles with predefined g-factors...")

predefined_g_spin_benchmark = @benchmark begin
    g_spin($(predefined_species[1]))  # electron
    g_spin($(predefined_species[2]))  # proton
    g_spin($(predefined_species[3]))  # neutron
    g_spin($(predefined_species[4]))  # muon
    g_spin($(predefined_species[5]))  # deuteron
end

println("   Predefined g_spin time: $(round(minimum(predefined_g_spin_benchmark.times) / 1000, digits=3)) μs")
println("   Average per call: $(round(minimum(predefined_g_spin_benchmark.times) / 1000 / length(predefined_species), digits=3)) μs")
println()

# Test 2: Calculated g_spin function calls
println("2. Calculated g_spin Function Performance:")
println("   Testing speed of g_spin for particles requiring calculation...")

calculated_g_spin_benchmark = @benchmark begin
    g_spin($(calculated_species[1]))  # positron
    g_spin($(calculated_species[2]))  # pion+
    g_spin($(calculated_species[3]))  # pion-
end

println("   Calculated g_spin time: $(round(minimum(calculated_g_spin_benchmark.times) / 1000, digits=3)) μs")
println("   Average per call: $(round(minimum(calculated_g_spin_benchmark.times) / 1000 / length(calculated_species), digits=3)) μs")
println()

# Test 3: Predefined gyromagnetic_anomaly function calls
println("3. Predefined gyromagnetic_anomaly Function Performance:")
println("   Testing speed of gyromagnetic_anomaly for particles with predefined values...")

predefined_anomaly_benchmark = @benchmark begin
    gyromagnetic_anomaly($(predefined_species[1]))  # electron
    gyromagnetic_anomaly($(predefined_species[2]))  # proton
    gyromagnetic_anomaly($(predefined_species[3]))  # neutron
    gyromagnetic_anomaly($(predefined_species[4]))  # muon
    gyromagnetic_anomaly($(predefined_species[5]))  # deuteron
end

println("   Predefined gyromagnetic_anomaly time: $(round(minimum(predefined_anomaly_benchmark.times) / 1000, digits=3)) μs")
println("   Average per call: $(round(minimum(predefined_anomaly_benchmark.times) / 1000 / length(predefined_species), digits=3)) μs")
println()

# Test 4: Calculated gyromagnetic_anomaly function calls
println("4. Calculated gyromagnetic_anomaly Function Performance:")
println("   Testing speed of gyromagnetic_anomaly for particles requiring calculation...")

calculated_anomaly_benchmark = @benchmark begin
    gyromagnetic_anomaly($(calculated_species[1]))  # positron
    gyromagnetic_anomaly($(calculated_species[2]))  # pion+
    gyromagnetic_anomaly($(calculated_species[3]))  # pion-
end

println("   Calculated gyromagnetic_anomaly time: $(round(minimum(calculated_anomaly_benchmark.times) / 1000, digits=3)) μs")
println("   Average per call: $(round(minimum(calculated_anomaly_benchmark.times) / 1000 / length(calculated_species), digits=3)) μs")
println()

# Test 5: Signed vs unsigned performance
println("5. Signed vs Unsigned Performance:")
println("   Testing performance difference between signed=true and signed=false...")

signed_benchmark = @benchmark begin
    g_spin($(predefined_species[1]); signed=true)   # electron
    g_spin($(predefined_species[2]); signed=true)   # proton
    g_spin($(predefined_species[3]); signed=true)   # neutron
end

unsigned_benchmark = @benchmark begin
    g_spin($(predefined_species[1]); signed=false)  # electron
    g_spin($(predefined_species[2]); signed=false)  # proton
    g_spin($(predefined_species[3]); signed=false)  # neutron
end

println("   Signed g_spin time: $(round(minimum(signed_benchmark.times) / 1000, digits=3)) μs")
println("   Unsigned g_spin time: $(round(minimum(unsigned_benchmark.times) / 1000, digits=3)) μs")
println("   Signed overhead: $(round(minimum(signed_benchmark.times) / minimum(unsigned_benchmark.times), digits=2))x")
println()

# Test 6: g_factor Field Access Performance
println("6. g_factor Field Access Performance:")
println("   Testing speed of direct species.g_factor field access...")

gfactor_predefined_benchmark = @benchmark begin
    $(predefined_species[1]).g_factor  # electron
    $(predefined_species[2]).g_factor  # proton
    $(predefined_species[3]).g_factor  # neutron
    $(predefined_species[4]).g_factor  # muon
    $(predefined_species[5]).g_factor  # deuteron
end

gfactor_calculated_benchmark = @benchmark begin
    $(calculated_species[1]).g_factor  # positron
    $(calculated_species[2]).g_factor  # pion+
    $(calculated_species[3]).g_factor  # pion-
end

println("   Predefined g_factor access time: $(round(minimum(gfactor_predefined_benchmark.times) / 1000, digits=3)) μs")
println("   Average per access (predefined): $(round(minimum(gfactor_predefined_benchmark.times) / 1000 / length(predefined_species), digits=3)) μs")
println("   Calculated g_factor access time: $(round(minimum(gfactor_calculated_benchmark.times) / 1000, digits=3)) μs")
println("   Average per access (calculated): $(round(minimum(gfactor_calculated_benchmark.times) / 1000 / length(calculated_species), digits=3)) μs")
println()

# Test 7: Individual particle performance
println("7. Individual Particle Performance:")
println("   Testing individual particle performance for detailed analysis...")

individual_benchmarks = Dict{String, Any}()

for (i, species) in enumerate(predefined_species)
    name = species.name
    individual_benchmarks[name] = @benchmark g_spin($species)
    println("   $name: $(round(minimum(individual_benchmarks[name].times) / 1000, digits=3)) μs")
end
println()

# Test 8: Memory allocation analysis
println("8. Memory Allocation Analysis:")
println("   Testing memory allocation for function calls...")

memory_benchmark = @benchmark begin
    for species in $predefined_species
        g_spin(species)
        gyromagnetic_anomaly(species)
        species.g_factor
    end
end

println("   Memory allocation for $(length(predefined_species)) species: $(round(minimum(memory_benchmark.memory), digits=0)) bytes")
println("   Average per species: $(round(minimum(memory_benchmark.memory) / length(predefined_species), digits=0)) bytes")
println()

# Test 9: Bulk operations
println("9. Bulk Operations Performance:")
println("   Testing performance of bulk g_spin, gyromagnetic_anomaly, and g_factor field access...")

bulk_benchmark = @benchmark begin
    results_g = Float64[]
    results_a = Float64[]
    results_gf = Float64[]
    
    for species in $predefined_species
        push!(results_g, g_spin(species))
        push!(results_a, gyromagnetic_anomaly(species))
        push!(results_gf, species.g_factor)
    end
    
    results_g, results_a, results_gf
end

println("   Bulk operations time: $(round(minimum(bulk_benchmark.times) / 1000, digits=3)) μs")
println("   Average per operation: $(round(minimum(bulk_benchmark.times) / 1000 / (3 * length(predefined_species)), digits=3)) μs")
println()

# Test 10: Error handling performance
println("10. Error Handling Performance:")
println("   Testing performance of error cases (photon)...")

photon = Species("photon")
error_benchmark = @benchmark begin
    try
        g_spin($photon)
    catch e
        # Expected error
    end
end

println("   Error handling time: $(round(minimum(error_benchmark.times) / 1000, digits=3)) μs")
println()

# Summary
println("=== Performance Summary ===")
println("Function Performance Comparison:")
println("  Predefined g_spin: $(round(minimum(predefined_g_spin_benchmark.times) / 1000 / length(predefined_species), digits=3)) μs/call")
println("  Calculated g_spin: $(round(minimum(calculated_g_spin_benchmark.times) / 1000 / length(calculated_species), digits=3)) μs/call")
println("  Predefined anomaly: $(round(minimum(predefined_anomaly_benchmark.times) / 1000 / length(predefined_species), digits=3)) μs/call")
println("  Calculated anomaly: $(round(minimum(calculated_anomaly_benchmark.times) / 1000 / length(calculated_species), digits=3)) μs/call")
println("  Field access g_factor (predefined): $(round(minimum(gfactor_predefined_benchmark.times) / 1000 / length(predefined_species), digits=3)) μs/access")
println("  Field access g_factor (calculated): $(round(minimum(gfactor_calculated_benchmark.times) / 1000 / length(calculated_species), digits=3)) μs/access")
println()

# Calculate speedup ratios
predefined_g_time = minimum(predefined_g_spin_benchmark.times) / length(predefined_species)
calculated_g_time = minimum(calculated_g_spin_benchmark.times) / length(calculated_species)
predefined_a_time = minimum(predefined_anomaly_benchmark.times) / length(predefined_species)
calculated_a_time = minimum(calculated_anomaly_benchmark.times) / length(calculated_species)

println("Speedup Ratios:")
println("  Predefined vs Calculated g_spin: $(round(calculated_g_time / predefined_g_time, digits=2))x slower")
println("  Predefined vs Calculated anomaly: $(round(calculated_a_time / predefined_a_time, digits=2))x slower")
println()

println("Benchmark completed successfully!")

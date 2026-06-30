using AtomicAndPhysicalConstants
using BenchmarkTools

println("=== AtomicAndPhysicalConstants gspin_of and gyromagnetic_anomaly Benchmarks ===")
println()

# Create test species
println("Setting up test species...")
test_species = [
    Species("electron"),
    Species("positron"),
    Species("proton"),
    Species("neutron"),
    Species("muon"),
    Species("deuteron"),
    Species("pion+"),
    Species("pion-"),
]

println("Test species created: $(length(test_species))")
println()

# Test 1: gspin_of function calls
# gspin_of is a direct field read (the g-factor is stored on the Species at
# construction time), so there is no separate "calculated" code path to compare.
println("1. gspin_of Function Performance:")
println("   Testing speed of gspin_of across particle types...")

gspin_benchmark = @benchmark begin
    for sp in $test_species
        gspin_of(sp)
    end
end

println("   gspin_of time (all species): $(round(minimum(gspin_benchmark.times) / 1000, digits=3)) μs")
println("   Average per call: $(round(minimum(gspin_benchmark.times) / 1000 / length(test_species), digits=3)) μs")
println()

# Test 2: gyromagnetic_anomaly function calls
println("2. gyromagnetic_anomaly Function Performance:")
println("   Testing speed of gyromagnetic_anomaly across particle types...")

anomaly_benchmark = @benchmark begin
    for sp in $test_species
        gyromagnetic_anomaly(sp)
    end
end

println("   gyromagnetic_anomaly time (all species): $(round(minimum(anomaly_benchmark.times) / 1000, digits=3)) μs")
println("   Average per call: $(round(minimum(anomaly_benchmark.times) / 1000 / length(test_species), digits=3)) μs")
println()

# Test 3: Signed vs unsigned performance
println("3. Signed vs Unsigned Performance:")
println("   Testing performance difference between signed=true and signed=false...")

signed_benchmark = @benchmark begin
    for sp in $test_species
        gspin_of(sp; signed=true)
    end
end

unsigned_benchmark = @benchmark begin
    for sp in $test_species
        gspin_of(sp; signed=false)
    end
end

println("   Signed gspin_of time: $(round(minimum(signed_benchmark.times) / 1000, digits=3)) μs")
println("   Unsigned gspin_of time: $(round(minimum(unsigned_benchmark.times) / 1000, digits=3)) μs")
println("   Signed overhead: $(round(minimum(signed_benchmark.times) / minimum(unsigned_benchmark.times), digits=2))x")
println()

# Test 4: Individual particle performance
println("4. Individual Particle Performance:")
println("   Testing individual particle performance for detailed analysis...")

individual_benchmarks = Dict{String, Any}()

for species in test_species
    name = nameof(species)
    individual_benchmarks[name] = @benchmark gspin_of($species)
    println("   $name: $(round(minimum(individual_benchmarks[name].times) / 1000, digits=3)) μs")
end
println()

# Test 5: Memory allocation analysis
println("5. Memory Allocation Analysis:")
println("   Testing memory allocation for function calls...")

memory_benchmark = @benchmark begin
    for species in $test_species
        gspin_of(species)
        gyromagnetic_anomaly(species)
    end
end

println("   Memory allocation for $(length(test_species)) species: $(round(minimum(memory_benchmark.memory), digits=0)) bytes")
println("   Average per species: $(round(minimum(memory_benchmark.memory) / length(test_species), digits=0)) bytes")
println()

# Test 6: Bulk operations
println("6. Bulk Operations Performance:")
println("   Testing performance of bulk gspin_of and gyromagnetic_anomaly calls...")

bulk_benchmark = @benchmark begin
    results_g = Float64[]
    results_a = Float64[]

    for species in $test_species
        push!(results_g, gspin_of(species))
        push!(results_a, gyromagnetic_anomaly(species))
    end

    results_g, results_a
end

println("   Bulk operations time: $(round(minimum(bulk_benchmark.times) / 1000, digits=3)) μs")
println("   Average per operation: $(round(minimum(bulk_benchmark.times) / 1000 / (2 * length(test_species)), digits=3)) μs")
println()

# Test 7: Non-lepton/hadron (NaN) handling performance
# gyromagnetic_anomaly returns NaN (not an error) for photons, atoms, and null
# species, since the anomaly is undefined for them.
println("7. NaN-path Performance:")
println("   Testing performance of the NaN-returning case (photon)...")

photon = Species("photon")
nan_benchmark = @benchmark gyromagnetic_anomaly($photon)

println("   gyromagnetic_anomaly(photon) time: $(round(minimum(nan_benchmark.times) / 1000, digits=3)) μs")
println()

# Summary
println("=== Performance Summary ===")
println("Function Performance Comparison:")
println("  gspin_of: $(round(minimum(gspin_benchmark.times) / 1000 / length(test_species), digits=3)) μs/call")
println("  gyromagnetic_anomaly: $(round(minimum(anomaly_benchmark.times) / 1000 / length(test_species), digits=3)) μs/call")
println("  Signed gspin_of: $(round(minimum(signed_benchmark.times) / 1000 / length(test_species), digits=3)) μs/call")
println("  Unsigned gspin_of: $(round(minimum(unsigned_benchmark.times) / 1000 / length(test_species), digits=3)) μs/call")
println()

println("Benchmark completed successfully!")
using APClite
using BenchmarkTools

println("=== APClite vs Baseline Performance Comparison ===")
println()

# Baseline: Simple struct creation
struct SimpleParticle
    name::String
    mass::Float64
    charge::Float64
end

println("1. Struct Creation Comparison:")
println("   APClite Species vs Simple Struct")

# APClite species creation
apclite_bench = @benchmark Species("electron")
println("   APClite Species(\"electron\"): $(round(median(apclite_bench.times) / 1000, digits=3)) μs")

# Simple struct creation
simple_bench = @benchmark SimpleParticle("electron", 0.511, -1.0)
println("   SimpleParticle(\"electron\", 0.511, -1.0): $(round(median(simple_bench.times) / 1000, digits=3)) μs")

overhead = median(apclite_bench.times) / median(simple_bench.times)
println("   APClite overhead: $(round(overhead, digits=2))x")
println()

# Baseline: Direct constant access
println("2. Constant Access Comparison:")
println("   APClite constants vs hardcoded values")

# APClite constants
apclite_const = @benchmark begin
    c = C_LIGHT
    h = H_PLANCK
    e = E_CHARGE
end
println("   APClite constants: $(round(median(apclite_const.times) / 1000, digits=4)) μs")

# Hardcoded values
hardcoded_bench = @benchmark begin
    c = 2.99792458e8
    h = 6.62607015e-34
    e = 1.602176634e-19
end
println("   Hardcoded values: $(round(median(hardcoded_bench.times) / 1000, digits=4)) μs")

const_overhead = median(apclite_const.times) / median(hardcoded_bench.times)
println("   APClite overhead: $(round(const_overhead, digits=2))x")
println()

# Baseline: Dictionary lookup
println("3. Species Lookup Comparison:")
println("   APClite Species() vs Dictionary lookup")

# Create a simple dictionary
particle_dict = Dict(
    "electron" => (mass=0.511, charge=-1.0, spin=0.5),
    "proton" => (mass=938.272, charge=1.0, spin=0.5),
    "neutron" => (mass=939.565, charge=0.0, spin=0.5)
)

# APClite species creation
apclite_species = @benchmark Species("electron")
println("   APClite Species(\"electron\"): $(round(median(apclite_species.times) / 1000, digits=3)) μs")

# Dictionary lookup
dict_bench = @benchmark particle_dict["electron"]
println("   Dictionary lookup: $(round(median(dict_bench.times) / 1000, digits=3)) μs")

lookup_overhead = median(apclite_species.times) / median(dict_bench.times)
println("   APClite overhead: $(round(lookup_overhead, digits=2))x")
println()

# Memory comparison
println("4. Memory Usage Comparison:")
println("   APClite Species vs Simple Struct")

# APClite memory
apclite_memory = @benchmark Species("electron")
println("   APClite Species: $(round(median(apclite_memory.memory), digits=0)) bytes")

# Simple struct memory
simple_memory = @benchmark SimpleParticle("electron", 0.511, -1.0)
println("   SimpleParticle: $(round(median(simple_memory.memory), digits=0)) bytes")

memory_overhead = median(apclite_memory.memory) / median(simple_memory.memory)
println("   APClite memory overhead: $(round(memory_overhead, digits=2))x")
println()

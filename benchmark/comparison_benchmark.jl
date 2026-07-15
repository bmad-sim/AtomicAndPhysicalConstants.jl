using AtomicAndPhysicalConstants
using BenchmarkTools

println("=== AtomicAndPhysicalConstants vs Baseline Performance Comparison ===")
println()

# Baseline: Simple struct creation
struct SimpleParticle
    name::String
    mass::Float64
    charge::Float64
end

println("1. Struct Creation Comparison:")
println("   AtomicAndPhysicalConstants Species vs Simple Struct")

# AtomicAndPhysicalConstants species creation
apc_bench = @benchmark Species("electron")
println("   AtomicAndPhysicalConstants Species(\"electron\"): $(round(median(apc_bench.times) / 1000, digits=3)) μs")

# Simple struct creation
simple_bench = @benchmark SimpleParticle("electron", 0.511, -1.0)
println("   SimpleParticle(\"electron\", 0.511, -1.0): $(round(median(simple_bench.times) / 1000, digits=3)) μs")

overhead = median(apc_bench.times) / median(simple_bench.times)
println("   AtomicAndPhysicalConstants overhead: $(round(overhead, digits=2))x")
println()

# Baseline: Direct constant access
println("2. Constant Access Comparison:")
println("   AtomicAndPhysicalConstants constants vs hardcoded values")

# AtomicAndPhysicalConstants constants
apc_const = @benchmark begin
    c = C_LIGHT
    h = H_PLANCK
    e = E_CHARGE
end
println("   AtomicAndPhysicalConstants constants: $(round(median(apc_const.times) / 1000, digits=4)) μs")

# Hardcoded values
hardcoded_bench = @benchmark begin
    c = 2.99792458e8
    h = 6.62607015e-34
    e = 1.602176634e-19
end
println("   Hardcoded values: $(round(median(hardcoded_bench.times) / 1000, digits=4)) μs")

const_overhead = median(apc_const.times) / median(hardcoded_bench.times)
println("   AtomicAndPhysicalConstants overhead: $(round(const_overhead, digits=2))x")
println()

# Baseline: Dictionary lookup
println("3. Species Lookup Comparison:")
println("   AtomicAndPhysicalConstants Species() vs Dictionary lookup")

# Create a simple dictionary
particle_dict = Dict(
    "electron" => (mass=0.511, charge=-1.0, spin=0.5),
    "proton" => (mass=938.272, charge=1.0, spin=0.5),
    "neutron" => (mass=939.565, charge=0.0, spin=0.5)
)

# AtomicAndPhysicalConstants species creation
apc_species = @benchmark Species("electron")
println("   AtomicAndPhysicalConstants Species(\"electron\"): $(round(median(apc_species.times) / 1000, digits=3)) μs")

# Dictionary lookup
dict_bench = @benchmark particle_dict["electron"]
println("   Dictionary lookup: $(round(median(dict_bench.times) / 1000, digits=3)) μs")

lookup_overhead = median(apc_species.times) / median(dict_bench.times)
println("   AtomicAndPhysicalConstants overhead: $(round(lookup_overhead, digits=2))x")
println()

# Memory comparison
println("4. Memory Usage Comparison:")
println("   AtomicAndPhysicalConstants Species vs Simple Struct")

# AtomicAndPhysicalConstants memory
apc_memory = @benchmark Species("electron")
println("   AtomicAndPhysicalConstants Species: $(round(median(apc_memory.memory), digits=0)) bytes")

# Simple struct memory
simple_memory = @benchmark SimpleParticle("electron", 0.511, -1.0)
println("   SimpleParticle: $(round(median(simple_memory.memory), digits=0)) bytes")

memory_overhead = median(apc_memory.memory) / median(simple_memory.memory)
println("   AtomicAndPhysicalConstants memory overhead: $(round(memory_overhead, digits=2))x")
println()

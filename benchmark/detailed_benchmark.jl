using AtomicAndPhysicalConstants
using BenchmarkTools

println("=== AtomicAndPhysicalConstants Detailed Performance Analysis ===")
println()

# Test individual constant access
println("Individual Constant Access Times:")
constants = [
    ("C_LIGHT", C_LIGHT),
    ("H_PLANCK", H_PLANCK),
    ("E_CHARGE", E_CHARGE),
    ("M_ELECTRON", M_ELECTRON),
    ("M_PROTON", M_PROTON),
    ("M_NEUTRON", M_NEUTRON),
    ("FINE_STRUCTURE", FINE_STRUCTURE),
    ("AVOGADRO", AVOGADRO),
    ("R_ELECTRON", R_ELECTRON),
    ("R_PROTON", R_PROTON),
    ("EPS_0", EPS_0),
    ("MU_0", MU_0)
]

for (name, value) in constants
    b = @benchmark $value
    println("   $name: $(round(minimum(b.times) / 1000, digits=4)) μs")
end
println()

# Test individual species creation
println("Individual Species Creation Times:")
species_names = [
    "electron", "proton", "neutron", "muon", "photon",
    "H", "He", "C", "O", "Fe", "U",
    "H+", "He++", "C+", "O-",
    "1H", "12C", "13C", "235U", "238U"
]

for name in species_names
    b = @benchmark Species($name)
    println("   Species(\"$name\"): $(round(minimum(b.times) / 1000, digits=3)) μs")
end
println()

# Test property access for different species types
println("Property Access Times by Species Type:")

# Subatomic particle
e = Species("electron")
subatomic_props = @benchmark begin
    nameof($e)
    chargeof($e)
    massof($e)
    spinof($e)
    kindof($e)
end
println("   Subatomic particle (electron): $(round(minimum(subatomic_props.times) / 1000, digits=3)) μs")

# Atomic species
h = Species("H")
atomic_props = @benchmark begin
    nameof($h)
    chargeof($h)
    massof($h)
    spinof($h)
    kindof($h)
    iso_of($h)
end
println("   Atomic species (H): $(round(minimum(atomic_props.times) / 1000, digits=3)) μs")

# Ion
h_plus = Species("H+")
ion_props = @benchmark begin
    nameof($h_plus)
    chargeof($h_plus)
    massof($h_plus)
    spinof($h_plus)
    kindof($h_plus)
    iso_of($h_plus)
end
println("   Ion (H+): $(round(minimum(ion_props.times) / 1000, digits=3)) μs")
println()

# Test scaling with number of species
println("Scaling Performance (Creating N Species):")
for n in [1, 10, 100, 1000]
    b = @benchmark begin
        particles = Species[]
        for i in 1:$n
            push!(particles, Species("electron"))
        end
        particles
    end
    per_species = minimum(b.times) / n / 1000
    println("   $n species: $(round(per_species, digits=3)) μs per species")
end
println()

# Test memory efficiency
println("Memory Efficiency:")
for n in [100, 1000, 10000]
    b = @benchmark begin
        particles = Species[]
        for i in 1:$n
            push!(particles, Species("electron"))
        end
        particles
    end
    memory_per_species = minimum(b.memory) / n
    println("   $n species: $(round(memory_per_species, digits=2)) bytes per species")
end
println()

# Test different species types for memory usage
println("Memory Usage by Species Type:")
species_types = [
    ("electron", Species("electron")),
    ("proton", Species("proton")),
    ("H", Species("H")),
    ("H+", Species("H+")),
    ("12C", Species("12C"))
]

for (name, species) in species_types
    b = @benchmark Species($name)
    println("   $name: $(round(minimum(b.memory), digits=0)) bytes")
end
println()


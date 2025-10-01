using AtomicAndPhysicalConstants
using BenchmarkTools

println("=== APClite Detailed Performance Analysis ===")
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
    "H1", "C12", "C13", "U235", "U238"
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
    $e.charge
    $e.mass
    $e.spin
    $e.kind
end
println("   Subatomic particle (electron): $(round(minimum(subatomic_props.times) / 1000, digits=3)) μs")

# Atomic species
h = Species("H")
atomic_props = @benchmark begin
    nameof($h)
    $h.charge
    $h.mass
    $h.spin
    $h.kind
    $h.iso
end
println("   Atomic species (H): $(round(minimum(atomic_props.times) / 1000, digits=3)) μs")

# Ion
h_plus = Species("H+")
ion_props = @benchmark begin
    nameof($h_plus)
    $h_plus.charge
    $h_plus.mass
    $h_plus.spin
    $h_plus.kind
    $h_plus.iso
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
    ("C12", Species("C12"))
]

for (name, species) in species_types
    b = @benchmark Species($name)
    println("   $name: $(round(minimum(b.memory), digits=0)) bytes")
end
println()


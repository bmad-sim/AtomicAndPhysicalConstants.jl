# Species

## Introduction

`Species` is a structure that stores information about a particle or atom, including its mass, charge, spin, magnetic moment, g-factor, and other properties.

## Creating a Species

Use the constructor `Species(name::String)` to create a species object:

```julia
julia> e = Species("electron")
julia> p = Species("proton")
julia> h = Species("H")
```

## Accessing Properties

The recommended way to access species properties is through helper functions:

```julia
julia> e = Species("electron")
julia> massof(e)        # 510998.95069 [eV/c²]
julia> chargeof(e)      # -1.0 [e]
julia> kindof(e)        # LEPTON
julia> atomicnumberof(e) # Mass number
julia> g_spin(e)        # g-factor (dimensionless)
julia> gyromagnetic_anomaly(e) # (g-2)/2
julia> isnullspecies(e) # Check if null species
```

### Available Helper Functions

- `massof(species)` - Returns mass in eV/c²
- `chargeof(species)` - Returns charge in units of elementary charge (e)
- `atomicnumberof(species)` - Returns mass number (isotope number)
- `kindof(species)` - Returns species type (ATOM, HADRON, LEPTON, PHOTON, NULL)
- `g_spin(species)` - Returns g-factor (dimensionless)
- `gyromagnetic_anomaly(species)` - Returns gyromagnetic anomaly (g-2)/2
- `isnullspecies(species)` - Returns true if species is null

### Direct Field Access (Alternative)

Properties can also be accessed directly as fields:

```julia
julia> e = Species("electron")
julia> e.mass           # 510998.95069 [eV/c²]
julia> e.charge         # -1.0 [e]
julia> e.spin           # 0.5 [ħ]
julia> e.moment         # Magnetic moment [J/T]
julia> e.g_factor       # g-factor (dimensionless)
julia> e.iso            # Mass number (0.0 for subatomic particles)
julia> e.kind           # LEPTON
julia> e.name           # "electron"
```

## Supported Species

### Subatomic Particles

The following subatomic particles are supported:

- `"electron"`, `"positron"` (or `"anti-electron"`)
- `"proton"`, `"anti-proton"`
- `"neutron"`, `"anti-neutron"`
- `"muon"`, `"anti-muon"`
- `"pion0"`, `"pion+"`, `"pion-"`
- `"deuteron"`, `"anti-deuteron"`
- `"photon"`

Example:
```julia
julia> e = Species("electron")
julia> anti_p = Species("anti-proton")
julia> pi_plus = Species("pion+")
```

### Atomic Species

All elements from H to Og are supported.

#### Basic Format

```julia
julia> Species("H")      # Hydrogen with natural isotope abundance
julia> Species("C")      # Carbon with natural isotope abundance
julia> Species("Fe")     # Iron with natural isotope abundance
```

#### Mass Number Format (optional)

Specify the mass number before the atomic symbol:
- Mass number directly: `"12C"`, `"235U"`
- With "#" prefix: `"#12C"`, `"#235U"`
- If not specified, uses the average mass of naturally occurring isotopes

```julia
julia> Species("12C")    # Carbon-12
julia> Species("#12C")   # Also Carbon-12
julia> Species("235U")   # Uranium-235
```

#### Charge Format (optional)

Specify charge after the atomic symbol:
- `"+"` - Single positive charge (e.g., `"C+"`)
- `"++"` - Double positive charge (e.g., `"C++"`)
- `"+n"` or `"n+"` - n positive charges (e.g., `"C+3"` or `"C3+"`)
- `"-"` - Single negative charge (e.g., `"C-"`)
- `"--"` - Double negative charge (e.g., `"C--"`)
- `"-n"` or `"n-"` - n negative charges (e.g., `"C-2"` or `"C2-"`)

```julia
julia> Species("C+")     # Singly ionized carbon
julia> Species("C++")    # Doubly ionized carbon
julia> Species("C+3")    # Triply ionized carbon
julia> Species("C3+")    # Also triply ionized carbon
julia> Species("O-")     # Oxygen with negative charge
```

#### Complete Examples

```julia
julia> Species("12C+")   # Carbon-12 with single positive charge
julia> Species("16O--")  # Oxygen-16 with double negative charge
julia> Species("56Fe+3") # Iron-56 with +3 charge
```

### Antiparticles and Anti-atoms

Prefix with `"anti-"` to create antiparticles or anti-atoms:

```julia
julia> Species("anti-proton")
julia> Species("anti-H")      # Anti-hydrogen
julia> Species("anti-12C+")   # Anti-carbon-12 ion
```

## Examples

```julia
using AtomicAndPhysicalConstants

# Create different types of species
electron = Species("electron")
proton = Species("proton")
hydrogen = Species("H")
carbon12 = Species("12C")
carbon_ion = Species("C+3")

# Access properties using helper functions (recommended)
println("Electron charge: ", chargeof(electron), " e")
println("Proton mass: ", massof(proton), " eV/c²")
println("Hydrogen mass: ", massof(hydrogen), " eV/c²")
println("Carbon-12 mass: ", massof(carbon12), " eV/c²")
println("Carbon-12 mass number: ", atomicnumberof(carbon12))
println("Carbon ion charge: ", chargeof(carbon_ion), " e")

# Check species types
println("Electron kind: ", kindof(electron))
println("Proton kind: ", kindof(proton))

# Get g-factor and anomaly
println("Electron g-factor: ", g_spin(electron))
println("Electron anomaly: ", gyromagnetic_anomaly(electron))

# Display species information
println(electron)
println(proton)
println(carbon_ion)
```

## Custom Species

You can create custom species by directly constructing them with all parameters:

```julia
using AtomicAndPhysicalConstants

# Direct construction
# name, charge [e], mass [eV/c²], spin [ħ], moment [J/T], g_factor, iso, kind
custom = Species("my-hadron", 1.0, 2.5e9, 0.5, 0.0, 2.0, 0.0, HADRON)
println(custom)
```

### Registering Custom Subatomic Species

For custom subatomic particles that you want to create by name:

```julia
using AtomicAndPhysicalConstants

# Register a custom subatomic species
AtomicAndPhysicalConstants.SUBATOMIC_SPECIES["X-"] = (
    charge=-1.0,
    mass=1e9,
    spin=0.5,
    moment=0.0,
    kind=HADRON,
)

# Now you can create it by name
xminus = Species("X-")
println(xminus)
```

### Registering Custom Atomic Elements

For custom elements with isotopes:

```julia
using AtomicAndPhysicalConstants

# Register a custom atomic element (with isotopes)
AtomicAndPhysicalConstants.ATOMIC_SPECIES["Xe"] = (
    Z=54,
    isotopes=Dict(129 => 120000.0, 132 => 122000.0, -1 => 121000.0),
)

# Create instances with isotope and charge information
xe129pp = Species("129Xe++")
println(xe129pp)
```

Note: The key `-1` in the isotopes dictionary represents the natural abundance average mass.

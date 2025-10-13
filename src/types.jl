"""
Types for APClite.jl

This module defines the core data structures used in APClite.
"""

# Kind enum for particle types
@enum Kind ATOM HADRON LEPTON PHOTON NULL

# Export the enum
export Kind

"""
    Species

A struct representing a particle or atom with its physical properties.

# Fields
- `name::String`: Name of the particle (e.g., "electron", "proton", "H")
- `charge::Float64`: Charge in units of elementary charge e
- `mass::Float64`: Mass in eV/c²
- `spin::Float64`: Spin in units of ħ
- `moment::Float64`: Magnetic moment in J/T
- `g_factor::Float64`: g-factor for the particle
- `iso::Float64`: Mass number for isotopes (0 for non-atomic particles)
- `kind::Kind`: Type of particle (ATOM, HADRON, LEPTON, PHOTON, NULL)
"""
struct Species
    name::String
    charge::Float64
    mass::Float64
    spin::Float64
    moment::Float64
    g_factor::Float64
    iso::Float64
    kind::Kind
end

# Default constructor for null species
Species() = Species("Null", 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL)

"""
    nameof(species::Species; basename::Bool=false) -> String

Get the name of the species. For atomic species, includes isotope and charge information unless basename=true.
"""
function Base.nameof(species::Species; basename::Bool=false)::String
    if species.kind == NULL
        return "Null"
    end
    
    bname = species.name
    
    # Full name for atoms
    if basename == false && species.kind == ATOM
        isostr = ""
        iso = Int(species.iso)
        chstr = ""
        ch = Int(species.charge)
        if iso != -1
            isostr = "#" * string(iso)
        end
        if ch > 0
            chstr = "+" * string(ch)
        elseif ch < 0
            chstr = string(ch)
        end
        return isostr * bname * chstr
    end

    # Default basename
    return bname
end

 

"""
    show(io::IO, species::Species)

Display a Species object in a readable format.
"""
function Base.show(io::IO, species::Species)
    if species.kind == NULL
        print(io, "Species(Null)")
    else
        print(io, "Species($(nameof(species)), charge=$(species.charge)e, mass=$(species.mass) eV/c², spin=$(species.spin)ħ)")
    end
end

"""
    show(io::IO, ::MIME"text/plain", species::Species)

Display a Species object in a detailed format.
"""
function Base.show(io::IO, ::MIME"text/plain", species::Species)
    if species.kind == NULL
        print(io, "Species(Null)")
    else
        println(io, "Species: $(nameof(species))")
        println(io, "  Charge: $(species.charge) e")
        println(io, "  Mass: $(species.mass) eV/c²")
        println(io, "  Spin: $(species.spin) ħ")
        println(io, "  Magnetic moment: $(species.moment) J/T")
        println(io, "  g-factor: $(species.g_factor)")
        if species.iso > 0
            println(io, "  Mass number: $(Int(species.iso))")
        end
        println(io, "  Kind: $(species.kind)")
    end
end

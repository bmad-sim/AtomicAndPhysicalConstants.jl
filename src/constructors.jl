"""
Species constructors for APClite.jl

This module provides constructors for creating Species objects from particle names.
"""

# Regular expression for anti-particles
const ANTI_REGEX = r"anti-|anti|Anti-|Anti"

"""
    Species(name::String)

Create a Species object from a particle name.

# Arguments
- `name::String`: Name of the particle (e.g., "electron", "proton", "H", "H+", "anti-proton")

# Examples
```julia
julia> e = Species("electron")
julia> p = Species("proton") 
julia> h = Species("H")
julia> h_ion = Species("H+")
julia> anti_p = Species("anti-proton")
```

# Supported formats
- Subatomic particles: "electron", "proton", "neutron", "muon", "pion+", "pion-", "pion0", "deuteron", "photon"
- Anti-particles: "anti-electron", "anti-proton", "anti-neutron", "anti-muon", "anti-deuteron"
- Atomic species: "H", "He", "C", "O", "Fe", "U", etc.
- Ions: "H+", "He++", "C+", "O-", etc.
- Isotopes: "H1", "C12", "U235", etc.
"""
function Species(name::String)
    # Handle null/empty names
    if name == "" || lowercase(name) == "null"
        return Species()
    end
    
    # Check for anti-particles
    is_anti = occursin(ANTI_REGEX, name)
    if is_anti
        # Remove anti- prefix for lookup
        clean_name = replace(name, ANTI_REGEX => "")
    else
        clean_name = name
    end

    # Check if it's a subatomic particle (exact match first)
    if haskey(SUBATOMIC_SPECIES, clean_name)
        pd = SUBATOMIC_SPECIES[clean_name]

        # Calculate g-factor
        if haskey(G_FACTOR_MAP, clean_name)
            g_factor = G_FACTOR_MAP[clean_name]
        else
            g_factor = 0.0
        end
        return Species(
            name,
            is_anti ? -pd.charge : pd.charge,
            pd.mass,
            pd.spin,
            is_anti ? -pd.moment : pd.moment,
            g_factor,
            0.0,
            pd.kind
        )
        end
    
    # Try to parse as atomic species, but catch errors
    try
        return parse_atomic_species(name)
    catch e
        error("Species '$name' not found in subatomic or atomic species database: $e")
    end
end


"""
    parse_atomic_name(name::String) -> Tuple{String, Int, Int}

Parse a bare atomic name into `(symbol, iso, charge)` without handling any anti- prefix.

Supported examples: "H", "H+", "C12", "U235++", "He-", "O2-".
"""
function parse_atomic_name(name::String)
    # Regex patterns (matching AtomicAndPhysicalConstants)
    rgas = r"[A-Z][a-z]|[A-Z]" # atomic symbol
    rgm = r"#[0-9][0-9][0-9]|#[0-9][0-9]|#[0-9]" # mass number with # prefix
    rgm_no_hash = r"[0-9][0-9][0-9]|[0-9][0-9]|[0-9]" # mass number without #
    rgcp = r"\+[0-9][0-9][0-9]|\+[0-9][0-9]|\+[0-9]|\+\+|\+" # positive charge
    rgcm = r"\-[0-9][0-9][0-9]|\-[0-9][0-9]|\-[0-9]|\-\-|\-" # negative charge

    remaining = name
    charge = 0
    iso = -1

    # Extract atomic symbol
    AS = match(rgas, remaining)
    if AS === nothing
        error("The specified particle name does not exist in this library.")
    end
    symbol = AS.match
    remaining = replace(remaining, symbol => "")

    # Parse isotope number
    isom = match(rgm, remaining)
    if isom !== nothing
        isostr = strip(isom.match, '#')
        iso_val = tryparse(Int, isostr)
        if iso_val === nothing
            error("Invalid isotope number format")
        end
        iso = iso_val
        remaining = replace(remaining, isom.match => "")
    else
        isom = match(rgm_no_hash, remaining)
        if isom !== nothing
            isostr = isom.match
            iso_val = tryparse(Int, isostr)
            if iso_val === nothing
                error("Invalid isotope number format")
            end
            iso = iso_val
            remaining = replace(remaining, isom.match => "")
        end
    end

    # Parse charge
    if count('+', remaining) != 0 && count('-', remaining) != 0
        error("You made a typo in \"$remaining\". You have both + and - in the name.")
    elseif occursin(rgcp, remaining)
        chstr = match(rgcp, remaining).match
        if chstr == "+"
            charge = 1
        elseif chstr == "++"
            charge = 2
        else
            chval = tryparse(Int, chstr)
            if chval === nothing
                error("Invalid charge format")
            end
            charge = chval
        end
        remaining = replace(remaining, chstr => "")
    elseif occursin(rgcm, remaining)
        chstr = match(rgcm, remaining).match
        if chstr == "-"
            charge = -1
        elseif chstr == "--"
            charge = -2
        else
            chval = tryparse(Int, chstr)
            if chval === nothing
                error("Invalid charge format")
            end
            charge = chval
        end
        remaining = replace(remaining, chstr => "")
    end

    # Check for remaining characters
    if remaining != ""
        error("You have entered too many characters: please try again.")
    end

    return (symbol, iso, charge)
end

"""
    parse_atomic_species(name::String) -> Species

Parse an atomic or anti-atomic species name and construct a `Species` object.

Handles atomic symbols, isotopes, charge states, and anti-atoms. 
Recognizes special names like "helion" and "triton". 
Checks for valid element, isotope, and charge, and computes the mass and spin accordingly.

# Arguments
- `name::String`: Name of the atomic or anti-atomic species (e.g., "H", "He++", "C12", "anti-He3", "triton")

# Returns
- `Species`: The constructed Species object
"""
function parse_atomic_species(name::String)
    anti_atom::Bool = false
    local_name = name

    # Handle anti-atoms
    if occursin(ANTI_REGEX, local_name)
        local_name = replace(local_name, ANTI_REGEX => "")
        anti_atom = true
    end

    if local_name == "helion"
        symbol = "He"
        iso = 3
        charge = 2
    elseif local_name == "triton"
        symbol = "H"
        iso = 3
        charge = 1
    elseif local_name== "deuteron"
        symbol = "H"
        iso = 2
        charge = 1
    else
        # Parse into components
        symbol, iso, charge = parse_atomic_name(local_name)
    end

    # Check if element exists in atomic species database
    if !haskey(ATOMIC_SPECIES, symbol)
        error("Element $symbol not found in atomic species database")
    end

    atom_data = ATOMIC_SPECIES[symbol]
    
    # Error handling for isotope availability
    if iso ∉ keys(atom_data.mass)
        error("The isotope you specified is not available.")
    end
    
    # Error handling for charge limits
    if charge > atom_data.Z
        error("You have specified a larger positive charge than the fully stripped $symbol atom has, which is unphysical.")
    end
    
    # Calculate mass
    mass = begin
        if anti_atom == false
            # Mass of the positively charged isotope in MeV/c²
            nmass = atom_data.mass[iso] * EV_PER_AMU / 1e6
            # Remove the electrons
            nmass - M_ELECTRON * charge
        else
            # Mass of the positively charged isotope in MeV/c²
            nmass = atom_data.mass[iso] * EV_PER_AMU / 1e6
            # Remove the positrons
            nmass + M_ELECTRON * charge
        end
    end
    
    # Calculate spin
    if iso == -1 # if it's the average, make an educated guess at the spin
        partonum = round(atom_data.mass[iso])
        if anti_atom == false
            spin = 0.5 * (partonum + (atom_data.Z - charge))
        else
            spin = 0.5 * (partonum + (atom_data.Z + charge))
        end
    else # otherwise, use the sum of proton and neutron spins
        spin = 0.5 * iso
    end
    
    # Calculate g-factor
    if symbol == "He" && iso == 3 && charge == 2
        g_factor = G_FACTOR_MAP["helion"] * M_HELION / (2 * M_PROTON)
    elseif symbol == "H" && iso == 3 && charge == 1
        g_factor = G_FACTOR_MAP["triton"] * M_TRITON / M_PROTON
    elseif symbol == "H" && iso == 2 && charge == 1
        g_factor = G_FACTOR_MAP["deuteron"] * M_DEUTERON / M_PROTON
    else
        g_factor = 0.0
    end

    # Return the object
    if anti_atom == false
        return Species(symbol, Float64(charge), mass, spin, 0.0, g_factor, Float64(iso), ATOM)
    else
        return Species("anti-" * symbol, Float64(charge), mass, spin, 0.0, g_factor, Float64(iso), ATOM)
    end
end






# ------------------------------------------------------------------------------------------------------------


"""
		atomicnumber(particle::Species)

Get the atomic number (positive nuclear charge) of a tracked particle.
"""
atomicnumber

function atomicnumber(particle::Species)
    if haskey(ATOMIC_SPECIES, particle.name)
        return ATOMIC_SPECIES[name].Z
    else
        print(f"{particle.name} is not an atom, and thus no atomic number.")
        return
    end
end;
export atomicnumber



# ------------------------------------------------------------------------------------------------------------
"""
		gyromagnetic_ratio(species::Species)

Compute and return the value of g_s for a particle in [1/(T*s)] == [C/kg]
For atomic particles, will currently return 0. Will be updated in a future patch
"""

function g_spin(species::Species)
    return 2 * species.mass * species.mu / (species.spin * species.charge)
end;
export g_spin


"""
		gyromagnetic_anomaly(species::Species)

Compute and deliver the gyromagnetic anomaly for a lepton given its g factor

# Arguments:
1. `gs::Float64': the g_factor for the particle
"""
gyromagnetic_anomaly

function gyromagnetic_anomaly(species::Species)
    gs = g_spin(species)
    return (gs - 2) / 2
end;
export gyromagnetic_anomaly


"""
		g_nucleon(gs::Float64, Z::Int, mass::Float64)

Compute and deliver the gyromagnetic anomaly for a baryon given its g factor


"""
g_nucleon

function g_nucleon(species::Species)
    Z = species.charge
    m = species.mass
    gs = g_spin(species)

    return gs * Z * __b_m_proton.val / m
end;
export g_nucleon


"""
		full_name(species::Species)

get the full name of a tracked species:
- if species is subatomic, gives the name in the SUBATOMIC_SPECIES dictionary
- if species is atomic, gives "mass number" * "atomic symbol" * "charge state", 
  *e.g.* #3He-1 for a Helion with 3 bound electrons
"""



function full_name(species::Species)
    if haskey(SUBATOMIC_SPECIES, species.name)
        return species.name
    else
        isostring = ""
        chargestring = ""
        if species.iso > 0
            isostring = "#" * f"{species.iso}"
        end
        if species.charge.val != 0
            if species.charge.val < 0
                chargestring = f"-{abs(species.charge.val)}"
            elseif species.charge.val > 0
                chargestring = f"-{abs(species.charge.val)}"

            end
        end
        return isostring * species.name * chargestring
    end
end;
export full_name



"""
    useCODATA(year::Int)

Sets the values of the base constants to those of a particular CODATA 
release. Valid only in the current scope."""
useCODATA

function useCODATA(year::Int)
    NIST_releases = [2002, 2006, 2010, 2014, 2018, 2022]
    if year ∈ NIST_releases
        include(f"src/{year}_constants.jl")
        include("src/subatomic_species.jl")
    else
        println("The available CODATA release years are:")
        for y in NIST_releasesexit()
            println(y)
        end
        error(f"The year requested isn't available, please select a valid year.")
    end
end

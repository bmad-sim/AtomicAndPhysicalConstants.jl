




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
- if species is atomic, gives "mass number"*"atomic symbol"*"charge state"
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
			if species.charge.val == 1
					chargestring = "+"
			elseif species.charge.val == -1
					chargestring = "-"
			elseif species.charge.val == 2
					chargestring = "++"
			elseif species.charge.val == -2
					chargestring = "--"
			elseif species.charge.val > 2
					chargestring = f"+{abs(species.charge.val)}"
			elseif species.charge < -2
					chargestring = f"-{abs(species.charge.val)}"
			end
		end
		return isostring * species.name * chargestring
	end
end;
export full_name


#####################################################################


"""
    massof(species::Species(), units=false)

retrieve the mass of a given species, with or without units.
Arguments:
1. species::Species   - the particle whose mass is to be retrieved
2. units::Bool        - whether or not to return a unitful quantity; 
                        default is false (no units)
"""
massof

function massof(species::Species; units::Bool=false)
  if species.kind == Kind.NULL
    error("The function 'massof' has requested the mass of an empty 
          species, which is meaningless.")
  elseif units==false
    return species.mass.val
  else
    return species.mass
  end
end; 
export massof


"""
    chargeof(species::Species(), units=false)

retrieve the charge of a given species, with or without units.
Arguments:
1. species::Species   - the particle whose charge is to be retrieved
2. units::Bool        - whether or not to return a unitful quantity; 
                        default is false (no units)
"""
chargeof

function chargeof(species::Species; units::Bool=false)
  if species.kind == Kind.NULL
    error("The function 'chargeof' has requested the mass of an empty 
          species, which is meaningless.")
  elseif units==false
    return species.charge.val
  else
    return species.mass
  end
  
end; 
export chargeof
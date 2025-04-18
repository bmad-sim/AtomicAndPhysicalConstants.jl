# ------------------------------------------------------------------------------------------------------------


"""
		atomicnumber(particle::Species)

Get the atomic number (positive nuclear charge) of a tracked particle.
"""
atomicnumber

function atomicnumber(particle::Species)
  if haskey(ATOMIC_SPECIES, particle.name)
    return ATOMIC_SPECIES[particle.name].Z
  else
    print(f"{particle.name} is not an atom, and thus no atomic number.")
    return
  end
end;




# ------------------------------------------------------------------------------------------------------------
"""
		gyromagnetic_ratio(species::Species)

Compute and return the value of g_s for a particle in [1/(T*s)] == [C/kg]
For atomic particles, will currently return 0. Will be updated in a future patch
"""

function g_spin(species::Species)
  return 2 * species.mass * species.mu / (species.spin * species.charge)
end;



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



"""
		full_name(species::Species)

get the full name of a tracked species:
- if species is subatomic, gives the name in the SUBATOMIC_SPECIES dictionary
- if species is atomic, gives "mass number" * "atomic symbol" * "charge state", 
  *e.g.* #3He-1 for a Helion with 3 bound electrons
"""
full_name



function full_name(species::Species)
  if haskey(SUBATOMIC_SPECIES, species.name)
    return species.name
  else
    isostring = ""
    chargestring = ""
    if species.iso > 0
      isostring = "#" * f"{convert(Int64, species.iso)}"
    end
    if species.charge.val != 0
      if species.charge.val < 0
        chargestring = f"-{convert(Int64, abs(species.charge.val))}"
      elseif species.charge.val > 0
        chargestring = f"+{convert(Int64, abs(species.charge.val))}"

      end
    end
    return isostring * species.name * chargestring
  end
end;




"""
    SUPERSCRIPT_MAP
    A dictionary mapping superscript characters to their corresponding integer values.
    This is used to convert superscript numbers in species names to their integer values.
"""
const SUPERSCRIPT_MAP = Dict{Char,Int64}(
  '⁰' => 0,
  '¹' => 1,
  '²' => 2,
  '³' => 3,
  '⁴' => 4,
  '⁵' => 5,
  '⁶' => 6,
  '⁷' => 7,
  '⁸' => 8,
  '⁹' => 9,
)

"""
    find_superscript(num::Int64)

## Description:
Convert an integer to its superscript representation.
This function takes an integer and returns a string containing the corresponding
superscript characters for each digit in the integer.
"""
function find_superscript(num::Int64)
  digs = reverse(digits(num))
  sup::String = ""
  for n ∈ digs
    for (k, v) in SUPERSCRIPT_MAP
      if n == v
        sup = sup * k
      end
    end
  end
  return sup
end
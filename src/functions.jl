# ------------------------------------------------------------------------------------------------------------

@doc """
    atomicnumber(particle::Species)

Get the atomic number (positive nuclear charge) of a tracked atom.
"""
atomicnumber

function atomicnumber(particle::Species)
  if haskey(ATOMIC_SPECIES, getfield(particle, :name))
    return ATOMIC_SPECIES[getfield(particle, :name)].Z
  else
    error("$(getfield(particle, :name)) is not an atom, and thus no atomic number.")
    return
  end
end;





# ------------------------------------------------------------------------------------------------------------
"""
    g_spin(species::Species)

Compute and return the value of g_s for a particle in [1/(T*s)] == [C/kg]
For atomic particles, will currently return 0. Will be updated in a future patch
"""
g_spin

function g_spin(species::Species; signed::Bool=false)

  vtypes = [Kind.LEPTON, Kind.HADRON]
  known = ["deuteron", "electron", "helion", "muon", "neutron", "proton", "triton"]

  if getfield(species, :kind) ∉ vtypes
    error("Only massive subatomic particles have available gyromagnetic factors in this package.")
  end
  if lowercase(getfield(species, :name)) ∈ known
    valname = Symbol("__b_gspin_"*getfield(species, :name))
    return abs(CODATA2022.eval(valname))
  else
    m_s = uconvert(u"MeV/c^2", getfield(species, :mass))
    mu_s = uconvert(u"m^2 * C / s", getfield(species, :moment))
    spin_s = getfield(species, :spin).val # since we store spin in units [ħ], we just want the half/integer
    if signed == true
      charge_s = uconvert(u"C", getfield(species, :charge))
    else
      charge_s = abs(uconvert(u"C", getfield(species, :charge)))
    end
    gs = uconvert(u"h_bar", 2 * m_s * mu_s / (spin_s * charge_s)).val
    return gs
  end
end;



"""
    gyromagnetic_anomaly(species::Species)

Compute and deliver the gyromagnetic anomaly for a lepton given its g factor

# Arguments:
1. `gs::Float64': the g_factor for the particle
"""
gyromagnetic_anomaly

function gyromagnetic_anomaly(species::Species; signed::Bool=false)

    vtypes = [Kind.LEPTON, Kind.HADRON]
    if getfield(species, :name) == "electron"
      return CODATA2022.__b_gyro_anom_electron
    elseif getfield(species, :name) == "muon"
      return CODATA2022.__b_gyro_anom_muon
    elseif getfield(species, :kind) ∉ vtypes
      error("Only subatomic particles have computable gyromagnetic anomalies in this package.")
    else
      if signed == true
        gs = g_spin(species; signed = true)
      else
        gs = g_spin(species)
      end
      return (gs - 2) / 2
    end

end;



"""
    g_nucleon(gs::Float64, Z::Int, mass::Float64)

Compute and deliver the gyromagnetic anomaly for a baryon given its g factor


"""
g_nucleon

function g_nucleon(species::Species)

  e = 1u"h_bar"
  m = getfield(species, :mass).val
  gs = g_spin(species)
  m_p = getfield(Species("proton"), :mass).val

  return gs * e * m_p / m
end;









@doc """
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

@doc """
    find_superscript(num::Int64)

## Description:
Convert an integer to its superscript representation.
This function takes an integer and returns a string containing the corresponding
superscript characters for each digit in the integer.
"""
find_superscript

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

@doc """
    to_openPMD(val::Unitful.Quantity)
## Description:
Convert a Unitful.Quantity to a format suitable for openPMD.
Returns a tuple where the first element is the value in SI units
and the second element is a 7-tuple of  powers of the 7 base measures
characterizing the record's unit in SI 
(length L, mass M, time T, electric current I, thermodynamic temperature theta, amount of substance N, luminous intensity J)
"""
to_openPMD

function to_openPMD(val::Unitful.Quantity)
  # convert the type to DynamicQuantities, which automatically converts to SI units
  # multiplying by 1.0 ensures that the value is converted to a float
  v = convert(DynamicQuantities.Quantity, val * 1.0)
  return (
    DynamicQuantities.ustrip(v),
    (
      DynamicQuantities.ulength(v),
      DynamicQuantities.umass(v),
      DynamicQuantities.utime(v),
      DynamicQuantities.ucurrent(v),
      DynamicQuantities.utemperature(v),
      DynamicQuantities.uamount(v),
      DynamicQuantities.uluminosity(v)
    )
  )
end

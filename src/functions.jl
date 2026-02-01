# AtomicAndPhysicalConstants/src/helpers.jl

#####################################################################
# functions that produce the gyromagnetic constants
#####################################################################
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
    if signed == false
      return abs(getfield(@__MODULE__, "gspin_" * lowercase(getfield(species, :name))))
    else
      return getfield(@__MODULE__, "gspin_" * lowercase(getfield(species, :name)))
    end
  else
    m_s = getfield(species, :mass) * g_per_eV * 1e3
    mu_s = getfield(species, :moment)
    spin_s = getfield(species, :spin) * h_bar_Planck
    if signed == false
      charge_s = abs(getfield(species, :charge) * e_charge)
    else
      charge_s = getfield(species, :charge) * e_charge
    end
    gs = m_s * mu_s / (charg_s * spin_s)
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
    if signed == false
      gs = g_spin(species)
    else
      gs = g_spin(species; signed=true)
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


#####################################################################
# species struct getter functions
#####################################################################


"""
    nameof(species::Species)

Returns the name of the species as a String.
"""
function Base.nameof(species::Species)
  return getfield(species, :name)
end

"""
    chargeof(species::Species)

Returns the charge of the species in units of elementary charge [e].
"""
function chargeof(species::Species; C::Bool=false, CODATAvals::CODATA_release=CODATA2022)
  if C == false
    return getfield(species, :charge)
  else
    return CODATAvals.e_coulomb * getfield(species, :charge)
  end
end

"""
    massof(species::Species)

Returns the mass of the species.
For atomic species, returns mass in atomic mass units (current_units.atomic_mass).
For subatomic species (baryons, leptons, etc.), returns mass in baryon mass units (current_units.baryon_mass).
"""
function massof(species::Species; AMU::Bool=false, CODATAvals::CODATA_release=CODATA2022)
  if AMU == false
    return getfield(species, :mass)
  else
    return getfield(species, :mass) / CODATAvals.eV_per_amu
  end
end

"""
    spinof(species::Species)

Returns the spin of the species in units of reduced Planck constant [ħ].
"""
function spinof(species::Species)
  return getfield(species, :spin)
end

"""
    momentof(species::Species)

Returns the magnetic moment of the species in magnetic moment units J/T.
"""
function momentof(species::Species)
  return getfield(species, :moment)
end

"""
    iso_of(species::Species)

Returns the isotope mass number of the species as an Int.
For atomic isotopes, this is the mass number: if taken as the abundance average, yields -1. 
For subatomic particles, yields 0.
"""
function iso_of(species::Species)
  return getfield(species, :iso)
end
#####################################################################
# Nuts and bolts functionality in more convenient packaging
#####################################################################

import Base: getproperty

function getproperty(obj::Species, field::Symbol)
  
  error("Do not use the 'base.getproperty' syntax to access fields 
  of Species objects: instead use the provided functions; 
  massof, chargeof, spinof, momentof, isotopeof, kindof, or nameof.")

end; export getproperty

@doc """
    SUPERSCRIPT_MAP
    A dictionary mapping superscript characters to their corresponding integer values.
    This is used to convert superscript numbers in species names to their integer values.
"""
const SUPERSCRIPT_MAP = Dict{Char,Int}(
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

function find_superscript(num::Int)
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

# function to_openPMD(val::Unitful.Quantity)
#   # convert the type to DynamicQuantities, which automatically converts to SI units
#   # multiplying by 1.0 ensures that the value is converted to a float
#   v = convert(DynamicQuantities.Quantity, val * 1.0)
#   return (
#     DynamicQuantities.ustrip(v),
#     (
#       DynamicQuantities.ulength(v),
#       DynamicQuantities.umass(v),
#       DynamicQuantities.utime(v),
#       DynamicQuantities.ucurrent(v),
#       DynamicQuantities.utemperature(v),
#       DynamicQuantities.uamount(v),
#       DynamicQuantities.uluminosity(v)
#     )
#   )
# end


function normalize_superscripts(str::String)
  buf = IOBuffer()
  for c in str
    if haskey(SUPERSCRIPT_MAP, c)
      print(buf, SUPERSCRIPT_MAP[c])  # write digit
    elseif c == '⁺' # superscript +
      print(buf, '+')  # write ASCII +
    elseif c == '⁻' # superscript -
      print(buf, '-')  # write ASCII -
    elseif c == ' ' # remove spaces
      continue
    else
      print(buf, c)  # preserve original char
    end
  end
  return String(take!(buf))
end


function chargeparse(c::String)

  if c == ""
    return 0
  elseif c[1] == '+'
    if c[end] == '+' && length(c) ≤ 3
      return Int(length(c))
    elseif occursin(mag_regEx, c)
      return parse(Int, c)
    else
      error("The given charge $c is not formatted correctly.")
    end
  elseif c[1] == '-'
    if c[end] == '-' && length(c) ≤ 3
      return -1*Int(length(c))
    elseif occursin(mag_regEx, c)
      return parse(Int, c)
    else
      error("The given charge $c is not formatted correctly.")
    end
  else
    error("Charge specifier must begin with '+' or '-'")
  end
end
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

function g_spin(mass, moment, spin, charge)

  m_s = mass * G_PER_EV / 1e3 # mass in kg
  mu_s = moment # magnetic moment in J/T
  spin_s = spin * H_BAR # spin in J*s

  charge_s = charge * E_CHARGE # charge in C

  # kg * ( J / T ) / (C * J * s) === kg / (T * C * s) === 1
  gs = m_s * mu_s / (charge_s * spin_s)
  return gs

end;






# """
#     g_nucleon(gs::Float64, Z::Int, mass::Float64)

# Compute and deliver the gyromagnetic anomaly for a baryon given its g factor


# """
# g_nucleon

# function g_nucleon(species::Species)

#   m = getfield(species, :mass)
#   gs = g_spin(species)
  

#   return gs * m_proton / m
# end


#####################################################################
# species struct getter functions
#####################################################################


@doc """
    nameof(species::Species)

Returns the name of the species as a String.
"""
function Base.nameof(species::Species)
  return getfield(species, :name)
end

@doc """
    chargeof(species::Species)

Returns the charge of the species in units of elementary charge [e].
"""
function chargeof(species::Species; C::Bool=false,)
  if C == false
    return getfield(species, :charge)
  else
    return E_CHARGE * getfield(species, :charge)
  end
end

@doc """
    massof(species::Species; AMU::Bool=false)

Returns the mass of the species.
For atomic species, returns mass in atomic mass units (current_units.atomic_mass).
For subatomic species (baryons, leptons, etc.), returns mass in baryon mass units (current_units.baryon_mass).
"""
function massof(species::Species; AMU::Bool=false)
  if AMU == false
    return getfield(species, :mass)
  else
    return getfield(species, :mass) / EV_PER_AMU
  end
end

@doc """
    spinof(species::Species)

Returns the spin of the species in units of reduced Planck constant [ħ].
"""
function spinof(species::Species)
  return getfield(species, :spin)
end

@doc """
    gspin_of(species::Species)

Returns the gyromagnetic factor of the species if it is known, otherwise 0.
"""
function gspin_of(species::Species; signed::Bool = false)
  if signed == false
    return abs(getfield(species, :gspin))
  else
    return getfield(species, :gspin)
  end
end


@doc """
    gyromagnetic_anomaly(species::Species)

Compute and deliver the gyromagnetic anomaly for a lepton
"""
gyromagnetic_anomaly

function gyromagnetic_anomaly(species::Species)
  # electron = ["electron", "positron"]
  # muon = [ "muon", "anti-muon"]
  # name = getfield(species, :name)
  # if name in electron && ANOMALY_ELECTRON != NaN
  #   return ANOMALY_ELECTRON 
  # elseif name in muon && ANOMALY_MUON != NaN
  #   return ANOMALY_MUON 
  # else
    return (gspin_of(species) - 2) / 2
  # end
end


@doc """
    momentof(species::Species)

Returns the magnetic moment of the species in magnetic moment units eV/T.
"""
momentof

momentof(species::Species) = getfield(species, :moment)


@doc """
    iso_of(species::Species)

Isotope mass number of the species as an Int.
For atomic isotopes, this is the mass number: if taken as the abundance average, yields -1. 
For subatomic particles, yields 0.
"""
iso_of

iso_of(species::Species) = getfield(species, :iso)

@doc """
    isnullspecies(species::Species)

Determine whether `species` is populated: `true` indicates a null species.
"""
isnullspecies

isnullspecies(species::Species) = getfield(species, :kind) == Kind.NULL

#####################################################################
# Nuts and bolts functionality in more convenient packaging
#####################################################################

@doc """
    set_release(; year = "2022")

sets the default value of global constants in AtomicAndPhysicalConstants to a particular CODATA release year.
The setting is persistent across Julia sessions.
Requires a restart of Julia to take effect.
"""
set_release

function set_release(;year::String = "2022")
  if !haskey(CODATA_MAP, year)
    throw(ArgumentError("You have provided an invalid release year: 
                         options are currently 
                         2002, 2006, 2010, 2014, 2018, or 2022."))
  end
  @set_preferences!("release" => year)
  @info("The default CODATA release is now $year. Restart your Julia session for this change to take effect.")
end




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


"""
    normalize_superscripts(str::String)

Turns a superscript string of digits `str` into a normal string of digits.
"""
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

"""
    chargeparse(c::String)

Turn a user defined string `c` representing atomic charge state into an integer charge state.
"""
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
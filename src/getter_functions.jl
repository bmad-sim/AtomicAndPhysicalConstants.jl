# AtomicAndPhysicalConstants/src/getter_functions.jl
# Getter functions for Species struct fields

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
function chargeof(species::Species; C::Bool = false, CODATAvals::CODATA_release = CODATA2022)
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
function massof(species::Species; AMU::Bool=false, CODATAvals::CODATA_release = CODATA2022)
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
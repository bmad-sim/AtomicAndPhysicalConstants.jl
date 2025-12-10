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
function chargeof(species::Species)
  return uconvert(current_units[].electric_charge, getfield(species, :charge) * u"e").val
end

"""
    massof(species::Species)

Returns the mass of the species.
For atomic species, returns mass in atomic mass units (current_units.atomic_mass).
For subatomic species (baryons, leptons, etc.), returns mass in baryon mass units (current_units.baryon_mass).
"""
function massof(species::Species)
  if getfield(species, :kind) == Kind.ATOM
    return uconvert(current_units[].atomic_mass, getfield(species, :mass) * u"eV/c^2").val
  else
    return uconvert(current_units[].baryon_mass, getfield(species, :mass) * u"eV/c^2").val
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

Returns the magnetic moment of the species in magnetic moment units (current_units.magnetic_moment).
"""
function momentof(species::Species)
  return uconvert(current_units[].magnetic_moment, getfield(species, :moment) * u"J/T").val
end

"""
    isoof(species::Species)

Returns the isotope mass number of the species as an Int.
For atomic isotopes, this is the mass number. For subatomic particles, returns 0.
"""
function isoof(species::Species)
  return getfield(species, :iso)
end
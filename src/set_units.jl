# Declare specific systems of units
#   for particle physics
"""
    ACCELERATOR
## ACCELERATOR units:
- `mass`: eV/c^2
- `length`: m
- `time`: s
- `energy`: eV
- `charge`: elementary charge
"""
ACCELERATOR

const ACCELERATOR = [
  u"eV/c^2",
  u"m",
  u"s",
  u"eV",
  u"e"]

#   MKS
"""
    MKS
## MKS units:
- `mass`: kg
- `length`: m
- `time`: s
- `energy`: J
- `charge`: C
"""
MKS

const MKS = [
  u"kg",
  u"m",
  u"s",
  u"J",
  u"C"]
#   quasi-CGS
"""
    CGS
## CGS units:
- `mass`: g
- `length`: cm
- `time`: s
- `energy`: J
- `charge`: C
"""
CGS

const CGS = [
  u"g",
  u"cm",
  u"s",
  u"J",
  u"C"]

"""
    setunits(unitsystem::UnitSystem=ACCELERATOR;
      mass_unit::Union{Unitful.FreeUnits,AbstractString}=unitsystem.mass,
      length_unit::Union{Unitful.FreeUnits,AbstractString}=unitsystem.length,
      time_unit::Union{Unitful.FreeUnits,AbstractString}=unitsystem.time,
      energy_unit::Union{Unitful.FreeUnits,AbstractString}=unitsystem.energy,
      charge_unit::Union{Unitful.FreeUnits,AbstractString}=unitsystem.charge,
      print_units::Bool = true
    )

## Description:
Return `nothing`.
Users can specify the unit system and modify units in the system by keyword parameters.
Sets global unit and store them in current units.
Prints current units at the end (optional).
    
## Default units:
- `mass`: eV/c^2
- `length`: m
- `time`: s
- `energy`: eV
- `charge`: elementary charge

## positional parameters:
- `unitsystem`   -- type: `UnitSystem`, specify the unit system, default to `PARTICLE_PHYSICS`, which sets units to 'Default units' (see above).
                                        The other options are `MKS`, and `CGS`. It provides a convient way to set all the units.

## keyword parameters
- `mass_unit`   -- type:`Union{Unitful.FreeUnits,AbstractString}`, unit for mass, default to the mass unit in `unitsystem`
- `length_unit` -- type:`Union{Unitful.FreeUnits,AbstractString}`, unit for length, default to the length unit in `unitsystem`
- `time_unit`   -- type:`Union{Unitful.FreeUnits,AbstractString}`, unit for time, default to the time unit in `unitsystem` 
- `energy_unit` -- type:`Union{Unitful.FreeUnits,AbstractString}`, unit for energy, default to the energy unit in `unitsystem`
- `charge_unit` -- type:`Union{Unitful.FreeUnits,AbstractString}`, unit for charge, default to the charge unit in `unitsystem`

## Note:
- unit for `Plancks' constant` is 'energy' * 'time'
- unit for `vacuum permeability` is N/A^2
- unit for `Permittivity of free space` is F/m
- unit for `Avogadro's number` is mol^-1
- unit for `classical radius` factor is 'length'*'mass'

"""
setunits

function setunits(unitsystem=ACCELERATOR;
  mass_unit::Unitful.FreeUnits=unitsystem[1],
  length_unit::Unitful.FreeUnits=unitsystem[2],
  time_unit::Unitful.FreeUnits=unitsystem[3],
  energy_unit::Unitful.FreeUnits=unitsystem[4],
  charge_unit::Unitful.FreeUnits=unitsystem[5],
)
  # check dimensions of units
  if dimension(mass_unit) != dimension(u"kg")
    throw(ErrorException("unit for mass does not have proper dimension"))
  end
  if dimension(length_unit) != dimension(u"m")
    throw(ErrorException("unit for length does not have proper dimension"))
  end
  if dimension(time_unit) != dimension(u"s")
    throw(ErrorException("unit for time does not have proper dimension"))
  end
  if dimension(energy_unit) != dimension(u"J")
    throw(ErrorException("unit for energy does not have proper dimension"))
  end
  if dimension(charge_unit) != dimension(u"C")
    throw(ErrorException("unit for charge does not have proper dimension"))
  end

  eval(:(c_light() = uconvert($length_unit / $time_unit, __b_c_light)))
  eval(:(h_planck() = uconvert($energy_unit * $time_unit, __b_h_planck)))
  eval(:(h_bar_planck() = uconvert($energy_unit * $time_unit, __b_h_bar_planck)))
  eval(:(r_e() = uconvert($length_unit, __b_r_e)))
  eval(:(r_p() = uconvert($length_unit, __b_r_p)))
  eval(:(e_charge() = uconvert($charge_unit, __b_e_charge)))
  eval(:(massof(species::Species) = uconvert($mass_unit, species.mass_in_eV * u"eV/c^2")))
  eval(:(chargeof(species::Species) = uconvert($charge_unit, species.charge * u"e")))
  return [mass_unit, length_unit, time_unit, energy_unit, charge_unit]

end

"""
    massof(
      species::Species,
      unit::Union{Unitful.FreeUnits,AbstractString}=current_units.mass
    )

## Description:
return mass of 'species' in current unit or unit of the user's choice

## parameters:
- `species`     -- type:`Species`, the species whose mass you want to know
- `unit`        -- type:`Union{Unitful.FreeUnits,AbstractString}`, default to the unit set from setunits(), the unit of the mass variable

"""
massof

function massof(species::Species, unit::Union{Unitful.FreeUnits,AbstractString})
  if unit isa AbstractString
    unit = uparse(unit)
  end
  if dimension(unit) != dimension(u"kg")
    error("mass unit doesn't have proper dimension")
  end
  return (species.mass_in_eV |> unit).val
end


"""
    chargeof(
      species::Species,
      unit::Union{Unitful.FreeUnits,AbstractString}=current_units.charge
    )

## Description:
return charge of 'species' in current unit or unit of the user's choice

## parameters:
- `species`     -- type:`Species`, the species whose charge you want to know
- `unit`        -- type:`Union{Unitful.FreeUnits,AbstractString}`, default to the unit set from setunits(), the unit of the charge variable

"""
chargeof

function chargeof(species::Species, unit::Union{Unitful.FreeUnits,AbstractString})
  if unit isa AbstractString
    unit = uparse(unit)
  end
  if dimension(unit) != dimension(u"C")
    throw(ErrorException("charge unit doesn't have proper dimension"))
  end
  return (species.charge |> unit).val
end




function c_light(unit::Unitful.FreeUnits)
  return __b_c_light |> unit
end

function h_planck(unit::Unitful.FreeUnits)
  return __b_h_planck |> unit
end


function h_bar_planck(unit::Unitful.FreeUnits)
  return __b_h_bar_planck |> unit
end


function r_e(unit::Unitful.FreeUnits)
  return __b_r_e |> unit
end

function r_p(unit::Unitful.FreeUnits)
  return __b_r_p |> unit
end

function e_charge(unit::Unitful.FreeUnits)
  return __b_e_charge |> unit
end


function mu_0_vac()
  return __b_mu_0_vac
end

function mu_0_vac(unit::Unitful.FreeUnits)
  return __b_mu_0_vac |> unit
end


function eps_0_vac()
  return __b_eps_0_vac
end

function eps_0_vac(unit::Unitful.FreeUnits)
  return __b_eps_0_vac |> unit
end

function classical_radius_factor()
  return __b_classical_radius_factor
end

function fine_structure()
  return __b_classical_radius_factor
end

function N_avogadro()
  return __b_N_avogadro
end
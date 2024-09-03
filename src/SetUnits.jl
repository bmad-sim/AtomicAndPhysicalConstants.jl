# include("PhysicalConstants.jl")
# include("ParticleTypes.jl")

"""
    Unit

    ### Description:
    > abstract type for storing units <

""" Unit

abstract type Unit end

# override printing of Units
Base.print(io::IO, unit::T) where {T<:Unit} =
  print(io, rpad(unit.name, 6),
            " where ",
            rpad(string(unit.conversion) * " " * unit.name, 25),
            " = 1 ")


"""
    scale

    ### Description:
    > return scaled units that has prefix 'prefix' and is scaled by 'factor' <

""" scale

function scale(unit::T, prefix::AbstractString, factor::Float64) where {T<:Unit}
  return T(prefix * unit.name, unit.conversion / factor)
end


"""
    Mass<:Unit

    ### Description:
    > immutable struct for storing mass units<
    > the basis for conversion is amu<

    ### Fields:
	- `name`                        -- type:AbstractString, name of the unit
	- `conversion`                  -- type:FLoat, 'conversion' unit = 1 eV/c^2

""" Mass

struct Mass <: Unit
  name::AbstractString
  conversion::Float64
end


"""
    Length<:Unit

    ### Description:
    > immutable struct for storing length units<
    > the basis for conversion is meter<

    ### Fields:
	- `name`                        -- type:AbstractString, name of the unit
	- `conversion`                  -- type:FLoat, 'conversion' unit = 1 meter

""" Length

struct Length <: Unit
  name::AbstractString
  conversion::Float64
end


"""
    Time_<:Unit

    ### Description:
    > immutable struct to be used for storing time units<
    > the basis for conversion is second<

    ### Fields:
	- `name`                        -- type:AbstractString, name of the unit
	- `conversion`                  -- type:FLoat, 'conversion' unit = 1 second

"""
Time_

struct Time_ <: Unit
  name::AbstractString
  conversion::Float64
end


"""
    Energy<:Unit

    ### Description:
    > immutable struct to be used for storing energy units<
    > the basis for conversion is electric volts<

    ### Fields:
	- `name`                        -- type:AbstractString, name of the unit
	- `conversion`                  -- type:FLoat, 'conversion' unit = 1 eV

""" Energy

struct Energy <: Unit
  name::AbstractString
  conversion::Float64
end


"""
    Charge<:Unit

    ### Description:
    > immutable struct to be used for storing charge units<
    > the basis for conversion is elementary charge<

    ### Fields:
	- `name`                        -- type:AbstractString, name of the unit
	- `conversion`                  -- type:FLoat, 'conversion' unit = 1 e

""" Charge

struct Charge <: Unit
  name::AbstractString
  conversion::Float64
end


"""
    printunits

    ### Description:
    > return nothing<
    > prints the units for each dimensions<
    > prints the units of constants with special dimenisions<

""" printunits

function printunits()
  if !@isdefined current_units
    throw(ErrorException("units are not set, call setunits() to initalize units and constants"))
  end
  # prints the units for each dimensions
  println("mass:\t",   current_units.mass,   "eV/c^2")
  println("length:\t", current_units.length, "m"     )
  println("time:\t",   current_units.time,   "s"     )
  println("energy:\t", current_units.energy, "eV"    )
  println("charge:\t", current_units.charge, "e"     )
  return
end


"""
    prefix

    ### Description:
    > dictionary that store how scaling factors relate to prefixs<

""" prefix

prefix::Dict{AbstractString,Float64} = Dict(
  "Q"  => 10^30,   # quetta
  "R"  => 10^27,   # ronna
  "Y"  => 10^24,   # yotta
  "Z"  => 10^21,   # zetta
  "E"  => 10^18,   # exa
  "P"  => 10^15,   # peta
  "T"  => 10^12,   # tera
  "G"  => 10^9,    # giga
  "M"  => 10^6,    # mega
  "k"  => 10^3,    # kilo
  "h"  => 10^2,    # hecto
  "da" => 10^1,    # deka
                   # ---
  "d"  => 10^-1,   # deci
  "c"  => 10^-2,   # centi
  "m"  => 10^-3,   # milli
  "u"  => 10^-6,   # micro
  "μ"  => 10^-6,   # micro
  "n"  => 10^-9,   # nano
  "p"  => 10^-12,  # pico
  "f"  => 10^-15,  # femto
  "a"  => 10^-18,  # atto
  "z"  => 10^-21,  # zepto
  "y"  => 10^-24,  # yocto
  "r"  => 10^-27,  # ronto
  "q"  => 10^-30   # quecto
)


UNIT::Dict{AbstractString,Unit} = Dict(
  "amu" => Mass("amu",  1 / __b_eV_per_amu),
  "eV / c ^ 2" => Mass("eV/c^2", 1.0),
  "g"   => Mass("g",    __b_kg_per_amu * 10^3 / __b_eV_per_amu),
  "kg"  => Mass("kg",   __b_kg_per_amu / __b_eV_per_amu),
  "C"   => Charge("C",  __b_e_charge),
  "e"   => Charge("e",  1.0),
  "m"   => Length("m",  1.0),
  "cm"  => Length("cm", 100.0),
  "A"   => Length("Å",  10^10),
  "s"   => Time_("s",   1.0),
  "min" => Time_("min", 1 / 60),
  "h"   => Time_("h",   1 / 3600),
  "J"   => Energy("J",  __b_e_charge),
  "eV"  => Energy("eV", 1.0)
)


"""
    function tounit(unit::Union{Symbol,Expr})

    ### Description:
    > return the correponding unit for the given symbol<

    ### parameters:
	- `unit`                        -- type: Symbol or Expr , name of the unit


""" tounit

function tounit(unit::Union{Symbol,Expr})
  name = string(unit)
  if haskey(UNIT, name)
    return UNIT[name]
  end
  for (key, value) in prefix
    if startswith(name, key)
      name_without_prefix = name[length(key)+1:end]
      if haskey(UNIT, name_without_prefix)
        return scale(UNIT[name_without_prefix], key, value)
      end
    end
  end
  throw(ArgumentError("unit \"" * name * "\" does not exist"))
end


"""
    UnitSystem

    ### Description:
    > immutable struct for storing unit systems<

    ### Fields:
	- `mass`                    -- type:Mass, stores the unit for mass
	- `length`                  -- type:Length, stores the unit for length
  - `time`                    -- type:Time, stores the unit for time
  - `energy`                  -- type:Energy, stores the unit for energy
  - `charge`                  -- type:Charge, stores the unit for charge


""" UnitSystem

struct UnitSystem
  mass::Mass
  length::Length
  time::Time_
  energy::Energy
  charge::Charge
end

PARTICLE_PHYSICS = UnitSystem(
  UNIT["eV / c ^ 2"],
  UNIT["m"],
  UNIT["s"],
  UNIT["eV"],
  UNIT["e"]
)
MKS = UnitSystem(
  UNIT["kg"],
  UNIT["m"],
  UNIT["s"],
  UNIT["J"],
  UNIT["C"]
)
CGS = UnitSystem(
  UNIT["g"],
  UNIT["cm"],
  UNIT["s"],
  UNIT["J"],
  UNIT["C"]
)


"""
    current_units :: UnitSystem

    ### Description:
    > a UnitSystem that stores currently using units<

    ### Note:
    it is initialized when setunits() is called

""" current_units


"""
    function setunits(unitsystem::Union{Symbol,Expr}=:default;
        mass::Union{Symbol,Expr}=:default,
        length::Union{Symbol,Expr}=:default,
        time::Union{Symbol,Expr}Symbol=:default,
        energy::Union{Symbol,Expr}=:default,
        charge::Union{Symbol,Expr}=:default,
    )

    ### Description:
    > return nothing<
    > users can specify the unit system and modify units in the system by keyword parameters<
    > sets global unit and store them in current units<

    ### default units
    mass: eV/c^2
    length: m
    time: s
    energy: eV
    charge: elementary charge

    ### positional parameters:
    - 'unitsystem'                  -- type:Symbol or Expr, specify the unit system, default to PARTICLE_PHYSICS{mass:eV/c^2,charge:e}
                                        , it provides a convient way to set all the units

    ### keyword parameters
	- `mass`                        -- type:Symbol or Expr, unit for mass, default to the mass unit in 'unitsystem'
	- `length`                      -- type:Symbol or Expr, unit for length, default to the length unit in 'unitsystem'
    - `time`                        -- type:Symbol or Expr, unit for time, default to the time unit in 'unitsystem'
    - `energy`                      -- type:Symbol or Expr, unit for energy, default to the energy unit in 'unitsystem'
    - `charge`                      -- type:Symbol or Expr, unit for charge, default to the charge unit in 'unitsystem'

    ### Note:
    - unit for Plancks' constant is 'energy' * 'time'
    - unit for vacuum permeability is N/A^2
    - unit for Permittivity of free space is F/m
    - unit for Avogadro's number is mol^-1
    - unit for classical radius factor is 'length'*'mass'

""" setunits

function setunits(unitsystem::Union{Symbol,Expr}=:default;
  mass::Union{Symbol,Expr}=:default,
  length::Union{Symbol,Expr}=:default,
  time::Union{Symbol,Expr}=:default,
  energy::Union{Symbol,Expr}=:default,
  charge::Union{Symbol,Expr}=:default,
)
  #stores unitsystem as a struct
  unit_system::UnitSystem = PARTICLE_PHYSICS
  if unitsystem == :MKS
    unit_system = MKS
  elseif unitsystem == :CGS
    unit_system = CGS
  elseif unitsystem == :ParticlePhysics || unitsystem == :default || unitsystem == :P
    unit_system = PARTICLE_PHYSICS
  else
    throw(ArgumentError("unit system \"" * string(unitsystem) * "\" does not exist"))
  end

  # get Unit struct from Symbol
  mass_unit::Mass = unit_system.mass
  if mass == :default
    mass_unit = unit_system.mass
  else
    mass_unit = tounit(mass)
  end

  length_unit::Length = unit_system.length
  if length == :default
    length_unit = unit_system.length
  else
    length_unit = tounit(length)
  end

  time_unit::Time_ = unit_system.time
  if time == :default
    time_unit = unit_system.time
  else
    time_unit = tounit(time)
  end

  energy_unit::Energy = unit_system.energy
  if energy == :default
    energy_unit = unit_system.energy
  else
    energy_unit = tounit(energy)
  end

  charge_unit::Charge = unit_system.charge
  if charge == :default
    charge_unit = unit_system.charge
  else
    charge_unit = tounit(charge)
  end

  # record what units is currently being used
  global current_units = UnitSystem(mass_unit, length_unit, time_unit, energy_unit, charge_unit)

  # convert all the variables with dimension mass
  global m_electron = mass_unit.conversion * __b_m_electron        # Electron Mass
  global m_proton = mass_unit.conversion * __b_m_proton            # Proton Mass
  global m_neutron = mass_unit.conversion * __b_m_neutron          # Neutron Mass
  global m_muon = mass_unit.conversion * __b_m_muon               # Muon Mass
  global m_helion = mass_unit.conversion * __b_m_helion            # Helion Mass He3 nucleus
  global m_deuteron = mass_unit.conversion * __b_m_deuteron        # Deuteron Mass
  global m_pion_0 = mass_unit.conversion * __b_m_pion_0            # Pion 0 Mass
  global m_pion_charged = mass_unit.conversion * __b_m_pion_charged    # Pion+- Mass

  # convert all the variables with dimension length
  global r_e = length_unit.conversion * __b_r_e                                    # classical electron radius

  # convert all the variables with dimension time

  # convert all the variables with dimension speed
  global c_light = __b_c_light * length_unit.conversion / time_unit.conversion      # speed of light

  # convert all the variables with dimension energy

  # convert all the variables with dimension charge
  global e_charge = 1 * charge_unit.conversion                                     # elementary charge

  # constants with special dimenisions
  # convert Planck's constant with dimension energy * time
  global h_planck = __b_h_planck * energy_unit.conversion * time_unit.conversion        # Planck's constant
  # convert Vacuum permeability with dimension force / (current)^2
  global mu_0_vac = __b_mu_0_vac
  # convert Vacuum permeability with dimension capacitance / distance
  global eps_0_vac = __b_eps_0_vac

  # convert anomous magnet moments dimension: unitless
  global gyromagnetic_anomaly_electron = __b_gyromagnetic_anomaly_electron           # anomalous mag. mom. of the electron
  global gyromagnetic_anomaly_muon = __b_gyromagnetic_anomaly_muon               #
  global gyromagnetic_anomaly_proton = __b_gyromagnetic_anomaly_proton             # μ_p/μ_N - 1
  global gyromagnetic_anomaly_deuteron = __b_gyromagnetic_anomaly_deuteron           # μ_{deuteron}/μ_N - 1
  global gyromagnetic_anomaly_neutron = __b_gyromagnetic_anomaly_neutron            # μ_{neutron}/μ_N - 1
  global gyromagnetic_anomaly_He3 = __b_gyromagnetic_anomaly_He3                # μ_{He3}/μ_N - 2

  # convert unitless variables
  global kg_per_amu = __b_kg_per_amu               # kg per standard atomic mass unit (dalton)
  global eV_per_amu = __b_eV_per_amu                  # eV per standard atomic mass unit (dalton)
  global N_avogadro = __b_N_avogadro                   # Number / mole  (exact)
  global fine_structure = __b_fine_structure                 # fine structure constant

  # values calculated from other constants
  global classical_radius_factor = r_e * m_electron                 # e^2 / (4 pi eps_0) = classical_radius * mass * c^2. Is same for all particles of charge +/- 1.
  global r_p = r_e * m_electron / m_proton      # proton radius
  global h_bar_planck = h_planck / 2pi                   # h_planck/twopi
  global kg_per_eV = kg_per_amu / eV_per_amu
  global eps_0_vac = 1 / (c_light^2 * mu_0_vac)       # Permeability of free space
  printunits()
  return
end


"""
    function massof(particle::Particle, unit::Union{Symbol,Expr}=:default)

    ### Description:
    > return mass of 'particle' in current unit or unit of the user's choice<

    ### parameters:
	  - 'particle`                        -- type:particle, the particle whose mass you want to know
    - `unit`                            -- type:Symbol or Expr, default to the unit set from setunits(), the unit of the mass variable

""" massof

function massof(particle::Particle, unit::Union{Symbol,Expr}=:default)
  if (unit == :default)
    if !@isdefined current_units
      throw(ErrorException("units are not set, call setunits() to initalize units and constants"))
    else
      return particle.mass * current_units.mass.conversion
    end
  else
    mass::Mass = tounit(unit)
    return particle.mass * mass.conversion
  end
end


"""
    function chargeof(particle::Particle, unit::Union{Symbol,Expr}=:default)

    ### Description:
    > return charge of 'particle' in current unit or unit of the user's choice<

    ### parameters:
	- 'particle`                  -- type:particle, the particle whose charge you want to know
    - `unit`                      -- type:Symbol or Expr, default to the unit set from setunits(), the unit of the charge variable

""" chargeof

function chargeof(particle::Particle, unit::Union{Symbol,Expr}=:default)
  if (unit == :default)
    if !@isdefined current_units
      throw(ErrorException("units are not set, call setunits() to initalize units and constants"))
    else
      return particle.charge * current_units.charge.conversion
    end
  else
    charge::Charge = tounit(unit)
    return particle.charge * charge.conversion
  end
end

export setunits, printunits
export massof, chargeof
export m_electron, m_proton, m_neutron, m_muon, m_helion, m_deuteron, m_pion_0, m_pion_charged
export c_light, r_e, e_charge, h_planck, mu_0_vac, eps_0_vac
export gyromagnetic_anomaly_electron, gyromagnetic_anomaly_proton, gyromagnetic_anomaly_muon
export gyromagnetic_anomaly_deuteron, gyromagnetic_anomaly_neutron, gyromagnetic_anomaly_He3
export kg_per_amu, eV_per_amu, N_avogadro, fine_structure, classical_radius_factor, r_p, h_bar_planck, kg_per_eV, eps_0_vac


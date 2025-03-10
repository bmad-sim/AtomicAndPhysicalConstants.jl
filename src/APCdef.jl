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

const ACCELERATOR = (
  u"eV/c^2",
  u"m",
  u"s",
  u"eV",
  u"e")

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

const MKS = (
  u"kg",
  u"m",
  u"s",
  u"J",
  u"C")
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

const CGS = (
  u"g",
  u"cm",
  u"s",
  u"J",
  u"C")

"""
    @APCdef(CODATA = 2022, unitsystem = ACCELERATOR, unitful = false)

## Description:
It defines the physical constants and getter functions for species mass and charge with the proper unit and data.

## positional parameters:
- `CODATA`       -- type: `Int`. Specify the year of the data source. Default to `2022``
- `unitsystem`   -- type: `UnitSystem`. Specify the unit system, default to `ACCELERATOR`, which sets units to 'Default units' (see above).
                                        The other options are `MKS`, and `CGS`. It provides a convient way to set all the units.
- `unitful`      -- type: `Bool`. If it is set to `true`, the constants will be a Unitful type. If it is set to `false`, it will be a `Float64`. Defualt to `false`.
                        
    
## Default units:
- `mass`: eV/c^2
- `length`: m
- `time`: s
- `energy`: eV
- `charge`: elementary charge

"""
macro APCdef(kwargs...)
  #defualt parameters
  unitful::Bool = false
  CODATA::Int64 = 2022
  unitsystem::NTuple{5,Unitful.FreeUnits} = ACCELERATOR
  name::Symbol = :APC

  # a dictionary that maps the name of the key word variables to their value
  kwargdict = Dict(map(t -> Pair(t.args...), kwargs))

  # obtain the keyword arguments
  if (haskey(kwargdict, :unitful) && kwargdict[:unitful])
    unitful = true
  end
  if (haskey(kwargdict, :CODATA))
    CODATA = kwargdict[:CODATA]
  end
  if (haskey(kwargdict, :unitsystem))
    unitsystem = eval(kwargdict[:unitsystem])
  end
  if (haskey(kwargdict, :name))
    if (kwargdict[:name] isa String)
      name = Symbol(kwargdict[:name])
    else
      name = eval(kwargdict[:name])
    end
  end

  # use the `CODATA` year data
  # useCODATA(CODATA)

  # extract the units from the unit system
  mass_unit::Unitful.FreeUnits = unitsystem[1]
  length_unit::Unitful.FreeUnits = unitsystem[2]
  time_unit::Unitful.FreeUnits = unitsystem[3]
  energy_unit::Unitful.FreeUnits = unitsystem[4]
  charge_unit::Unitful.FreeUnits = unitsystem[5]
  # check dimensions of units
  if dimension(mass_unit) != dimension(u"kg")
    error("unit for mass does not have proper dimension")
  end
  if dimension(length_unit) != dimension(u"m")
    error("unit for length does not have proper dimension")
  end
  if dimension(time_unit) != dimension(u"s")
    error("unit for time does not have proper dimension")
  end
  if dimension(energy_unit) != dimension(u"J")
    error("unit for energy does not have proper dimension")
  end
  if dimension(charge_unit) != dimension(u"C")
    error("unit for charge does not have proper dimension")
  end

  # this dictionary maps the dimension of the unit to the target unit that it should convert to
  conversion = Dict(
    dimension(u"kg") => mass_unit,
    dimension(u"m") => length_unit,
    dimension(u"s") => time_unit,
    dimension(u"J") => energy_unit,
    dimension(u"C") => charge_unit,
    dimension(u"m/s") => length_unit / time_unit,
    dimension(u"J*s") => energy_unit * time_unit,
    dimension(u"kg*m") => mass_unit * length_unit,
    dimension(u"m") => length_unit,
    dimension(u"C") => charge_unit,
  )

  # this vector contains the names of the constants in symbols
  constants::Vector{Symbol} = filter(x -> (
      startswith(string(x), "__b_") && # the name starts with __b_
      !occursin("_m_", string(x)) && # the name does not contain _m_, so that it is not a mass
      (!occursin("_mu_", string(x)) || occursin("__b_mu_0_vac", string(x)))  # the name does not contain _mu_, so that it is not a magnetic moment
    ), names(AtomicAndPhysicalConstants, all=true))

  if unitful #suppose the user demand unitful quantity

    constantsdict = Dict{Symbol,Union{Unitful.Quantity,Float64}}()

    for sym in constants
      value = eval(sym) # the value of the constant
      constantname = Symbol(uppercase(string(sym)[5:end])) # the name of the field by converting the name to upper case
      if haskey(conversion, dimension(value)) #if the dimension is one of the dimensions in the dictionary
        constantsdict[constantname] = uconvert(conversion[dimension(value)], value)
      else
        constantsdict[constantname] = value
      end
    end

    masstype = typeof(1.0 * mass_unit)
    chargetype = typeof(1.0 * charge_unit)
    return quote
      #massof and charge of
      function $(esc(:massof))(species::Species)::$masstype
        @assert species != Species() "Can't call massof() on a null Species object"
        return uconvert($mass_unit, species.mass)
      end
      function $(esc(:chargeof))(species::Species)::$chargetype
        @assert species != Species() "Can't call chargeof() on a null Species object"
        return uconvert($charge_unit, species.charge)
      end

      #added options for string input
      function $(esc(:massof))(speciesname::String)::$masstype
        species = Species(speciesname)
        return uconvert($mass_unit, species.mass)
      end
      function $(esc(:chargeof))(speciesname::String)::$chargetype
        species = Species(speciesname)
        return uconvert($charge_unit, species.charge)
      end
      $(esc(name)) = NamedTuple{Tuple(keys($constantsdict))}(values($constantsdict))
    end
  else #if the user does not want unitful
    constantsdict = Dict{Symbol,Float64}()

    for sym in constants
      value = eval(sym) # the value of the constant
      constantname = Symbol(uppercase(string(sym)[5:end])) # the name of the field by converting the name to upper case
      if haskey(conversion, dimension(value)) #if the dimension is one of the dimensions in the dictionary
        constantsdict[constantname] = uconvert(conversion[dimension(value)], value).val
      elseif value isa Float64
        constantsdict[constantname] = value # If the value does not have unit, such as Avogadro's number
      else
        constantsdict[constantname] = value.val
      end
    end

    return quote
      #massof and charge of
      function $(esc(:massof))(species::Species)::Float64
        @assert species != Species() "Can't call massof() on a null Species object"
        return uconvert($mass_unit, species.mass).val
      end
      function $(esc(:chargeof))(species::Species)::Float64
        @assert species != Species() "Can't call chargeof() on a null Species object"
        return uconvert($charge_unit, species.charge).val
      end

      #added options for string input
      function $(esc(:massof))(speciesname::String)::Float64
        species = Species(speciesname)
        return uconvert($mass_unit, species.mass).val
      end
      function $(esc(:chargeof))(speciesname::String)::Float64
        species = Species(speciesname)
        return uconvert($charge_unit, species.charge).val
      end
      $(esc(name)) = NamedTuple{Tuple(keys($constantsdict))}(values($constantsdict))

    end
  end
end


"""
    massof(
      species::Species,
    )

## Description:
return mass of 'species' in current unit.

## parameters:
- `species`     -- type:`Species`, the species whose mass you want to know
"""
massof


"""
    chargeof(
      species::Species,
    )

## Description:
return charge of 'species' in current unit.

## parameters:
- `species`     -- type:`Species`, the species whose charge you want to know

"""
chargeof
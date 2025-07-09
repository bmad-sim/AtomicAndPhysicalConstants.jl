# Declare specific systems of units

#---------------------------------------------------------------------------------------------------
#   for particle physics
"""
    ACCELERATOR
## ACCELERATOR units:
- `mass`: eV/c^2
- `length`: m
- `time`: s
- `energy`: eV
- `charge`: elementary charge
- `spin`: h_bar (ħ)
"""
ACCELERATOR

const ACCELERATOR = (
  u"eV/c^2",
  u"m",
  u"s",
  u"eV",
  u"e",
  u"h_bar")

#---------------------------------------------------------------------------------------------------
#   MKS

"""
    MKS
## MKS units:
- `mass`: kg
- `length`: m
- `time`: s
- `energy`: J
- `charge`: C
- `spin`: h_bar (ħ)
"""
MKS

const MKS = (
  u"kg",
  u"m",
  u"s",
  u"J",
  u"C",
  u"h_bar")

#---------------------------------------------------------------------------------------------------
# CGS

"""
    CGS
## CGS units:
- `mass`: g
- `length`: cm
- `time`: s
- `energy`: J
- `charge`: C
- `spin`: h_bar (ħ)
"""
CGS

const CGS = (
  u"g",
  u"cm",
  u"s",
  u"J",
  u"C",
  u"h_bar")

#---------------------------------------------------------------------------------------------------
# @APCdef

"""
    @APCdef(unitsystem = ACCELERATOR, unittype = Float, name = :APC)

## Description:
It defines the physical constants and getter functions for species mass and charge with the proper unit and data.

## keyword parameters:
- `unitsystem`   -- type: 5-Tuple of `Unitful` units. Specify the unit system, default to `ACCELERATOR`, which sets units to 'Default units' (see below).
                                        The other options are `MKS`, and `CGS`. It provides a convient way to set all the units.
- `unittype`     -- Sets the return type of the constants and the getter functions. It can be `Float`, `Unitful`, or `DynamicQuantities`. Default to `Float`.
- `name`         -- Sets the name of the module that contains the constants and getter functions. Default to `APC`.
- `tupleflag`    -- type: `Bool`, whether to return the constants in a tuple or not. Default to `true`. If set to `false`, it will return the constants as individual variables.
    
## Note
- @APCdef can be called only once in a module.

## Default units:
- `mass`: eV/c^2
- `length`: m
- `time`: s
- `energy`: eV
- `charge`: elementary charge
- `spin`: h_bar (ħ)
"""
macro APCdef(kwargs...)

  # check whether @APCdef has been called by checking whether massof is in the namespace
  if names(Main, all=true) |> x -> :massof in x
    @error "You may only call @APCdef once"
    return
  end

  # Defualt parameters
  unittype::Symbol = :Float
  unitsystem::NTuple{6,Unitful.FreeUnits} = ACCELERATOR
  name::Symbol = :APC
  tupleflag::Bool = true # whether return the constants in a tuple or not


  # initialize wrapper
  wrapper::String = String(name)


  # a dictionary that maps the name of the key word variables to their value
  kwargdict = Dict(map(t -> Pair(t.args...), kwargs))

  # obtain the keyword arguments
  for k in keys(kwargdict)
    if k == :unittype
      unittype = kwargdict[:unittype]
    elseif k == :unitsystem
      unitsystem = eval(kwargdict[:unitsystem])
    elseif k == :name
      if kwargdict[:name] isa String
        name = Symbol(kwargdict[:name])
      else
        name = kwargdict[:name]
      end
      wrapper = String(name)
    elseif k == :tupleflag
      if kwargdict[:tupleflag] isa Bool
        tupleflag = kwargdict[:tupleflag]
      else
        @error "tupleflag should be a boolean value"
        return
      end
    else
      @error "$k is not a proper keyword argument for @APCdef, the only options are `unittype`, `unitsystem`, `name`"
      return
    end
  end

  # extract the units from the unit system
  mass_unit::Unitful.FreeUnits = unitsystem[1]
  length_unit::Unitful.FreeUnits = unitsystem[2]
  time_unit::Unitful.FreeUnits = unitsystem[3]
  energy_unit::Unitful.FreeUnits = unitsystem[4]
  charge_unit::Unitful.FreeUnits = unitsystem[5]
  spin_unit::Unitful.FreeUnits = unitsystem[6]

  # check dimensions of units?
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
  if dimension(spin_unit) != dimension(u"h_bar")
    error("unit for spin does not have proper dimension")
  end

  # spin_unit::Unitful.FreeUnits = energy_unit * time_unit # spin unit is energy * time, which is the same as h_bar
  # doing it that way is faster, but the unit scaling is not the same. thus if you're using unittype = Float, you don't 
  # get half/integers for the spin

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
    dimension(u"h_bar") => spin_unit,
  )
  unit_names::Dict{Symbol,Unitful.FreeUnits} = Dict(
    :mass => mass_unit,
    :length => length_unit,
    :time => time_unit,
    :energy => energy_unit,
    :charge => charge_unit,
    :velocity => length_unit / time_unit,
    :action => energy_unit * time_unit,
    :spin => spin_unit
  )
  # this vector contains the names of the all the constants in the module in symbols
  constants::Vector{Symbol} = filter(x -> (
    startswith(string(x), "__b_") && # the name starts with __b_
    !occursin("_m_", string(x)) && # the name does not contain _m_, so that it is not a mass
    (!occursin("_mu_", string(x)) || occursin("__b_mu_0_vac", string(x)))  # the name does not contain _mu_, so that it is not a magnetic moment
  ), names(parentmodule(@__MODULE__).@__MODULE__, all=true))

  constantdict_type::Type = Dict{Symbol,Union{Unitful.Quantity,Float64,DynamicQuantities.Quantity{Float64,DynamicQuantities.Dimensions{DynamicQuantities.FixedRational{Int32,25200}}}}}

  # create a dictionary that contains all the constants in the module
  # convert the constants to the proper unit
  constantsdict::constantdict_type = Dict()
  for sym in constants
    value = getfield(parentmodule(@__MODULE__).@__MODULE__, sym) # the value of the constant
    constantname = Symbol(uppercase(string(sym)[5:end])) # the name of the field by converting the name to upper case
    if haskey(conversion, dimension(value)) #if the dimension is one of the dimensions in the dictionary
      constantsdict[constantname] = uconvert(conversion[dimension(value)], value) # convert them to proper unit
    else
      constantsdict[constantname] = value
    end
  end

  # convert the constantsdict to the proper type based on the unittype

  if unittype == :Unitful #suppose the user demand unitful quantity

  # no need to convert the constantsdict_unitful, since it is already in Unitful.Quantity type

  elseif unittype == :Float #if the user wants Float quantity
    constantsdict_float::constantdict_type = Dict()

    for (constantname, value) in constantsdict
      if value isa Float64
        constantsdict_float[constantname] = value # If the value does not have unit, such as Avogadro's number
      else
        constantsdict_float[constantname] = value.val
      end
    end
    constantsdict = constantsdict_float

  elseif unittype == :DynamicQuantities #if the user wants DynamicQuantities

    @warn "DynamicQuantities will only return units in SI units"

    constantsdict_dynamicquantities::constantdict_type = Dict()

    for (constantname, value) in constantsdict
      if value isa Float64
        constantsdict_dynamicquantities[constantname] = value # If the value does not have unit, such as Avogadro's number
      else
        constantsdict_dynamicquantities[constantname] = convert(DynamicQuantities.Quantity, value) # directly convert to DynamicQuantities
      end
    end
    constantsdict = constantsdict_dynamicquantities
  else
    error("`unittype` should be one of Float, Unitful, DynamicQuantities")
  end

  # whether to return the constants in a tuple or not
  tuple_statement = begin
    if tupleflag
      quote
        $(esc(name)) = NamedTuple{Tuple(keys($constantsdict))}(values($constantsdict))
      end
    else
      Expr(:block, [:($(esc(key)) = $(value)) for (key, value) in constantsdict]...)
    end
  end

  return quote

    $(esc(:APCconsts)) = $wrapper

    $(esc(:UNITS)) = NamedTuple{Tuple(keys($unit_names))}(values($unit_names))

    $(generate_particle_property_functions(unittype, mass_unit, charge_unit, spin_unit))

    $(tuple_statement)
  end

end


function generate_particle_property_functions(unittype, mass_unit, charge_unit, spin_unit)
  # assert that the unittype is one of Float, Unitful, DynamicQuantities
  @assert unittype in [:Float, :Unitful, :DynamicQuantities] "unittype should be one of Float, Unitful, DynamicQuantities"
  # assert that the mass_unit, charge_unit, spin_unit are of proper dimension
  if dimension(mass_unit) != dimension(u"kg")
    error("unit for mass does not have proper dimension")
  end
  if dimension(charge_unit) != dimension(u"C")
    error("unit for charge does not have proper dimension")
  end
  if dimension(spin_unit) != dimension(u"h_bar")
    error("unit for charge does not have proper dimension")
  end

  # name of the return type
  typename = begin
    if unittype == :Float
      :Float64
    elseif unittype == :Unitful
      :(Unitful.Quantity)
    elseif unittype == :DynamicQuantities
      :(DynamicQuantities.Quantity)
    end
  end

  # return statement of the function
  return_statement = (unit, field) -> begin
    if unittype == :Float
      return quote
        return uconvert($unit, getfield(species, Symbol($field))).val
      end
    elseif unittype == :Unitful
      return quote
        return uconvert($unit, getfield(species, Symbol($field)))
      end
    elseif unittype == :DynamicQuantities
      return quote
        return convert(DynamicQuantities.Quantity, uconvert($unit, getfield(species, Symbol($field))))
      end
    end
  end
  return quote
    function $(esc(:spinof))(species::Species)::$(typename)
      @assert getfield(species, :kind) != Kind.NULL "Can't call spinof() on a null Species object."
      @assert getfield(species, :kind) != Kind.ATOM "The spin projection of a whole atom is ambiguous."
      $(return_statement(spin_unit, "spin"))
    end
    function $(esc(:spinof))(speciesname::String)::$(typename)
      species = Species(speciesname)
      @assert getfield(species, :kind) != Kind.NULL "Can't call spinof() on a null Species object."
      @assert getfield(species, :kind) != Kind.ATOM "The spin projection of a whole atom is ambiguous."
      $(return_statement(spin_unit, "spin"))
    end
    function $(esc(:massof))(species::Species)::$(typename)
      @assert getfield(species, :kind) != Kind.NULL "Can't call massof() on a null Species object."
      $(return_statement(mass_unit, "mass"))
    end
    function $(esc(:massof))(speciesname::String)::$(typename)
      species = Species(speciesname)
      @assert getfield(species, :kind) != Kind.NULL "Can't call massof() on a null Species object."
      $(return_statement(mass_unit, "mass"))
    end
    function $(esc(:chargeof))(species::Species)::$(typename)
      @assert getfield(species, :kind) != Kind.NULL "Can't call chargeof() on a null Species object."
      $(return_statement(charge_unit, "charge"))
    end
    function $(esc(:chargeof))(speciesname::String)::$(typename)
      species = Species(speciesname)
      @assert getfield(species, :kind) != Kind.NULL "Can't call chargeof() on a null Species object."
      $(return_statement(charge_unit, "charge"))
    end
    function $(esc(:nameof))(species::Species; basename::Bool=false)::String
      @assert getfield(species, :kind) != Kind.NULL "Can't call nameof() on a null Species object"
      bname = getfield(species, :name)
      isostr = ""
      iso = Int(getfield(species, :iso))
      chstr = ""
      ch = Int(getfield(species, :charge).val)
      ptypes = [Kind.HADRON, Kind.LEPTON, Kind.PHOTON]
      if getfield(species, :kind) ∈ ptypes
        return bname
      elseif getfield(species, :kind) == Kind.ATOM
        if basename == true
          return bname
        else
          if iso != -1
            isostr = "#" * string(iso)
          end
          if ch > 0
            chstr = "+" * string(ch)
          elseif ch < 0
            chstr = string(ch)
          end
          return isostr * bname * chstr
        end
      end
    end
  end
end

#---------------------------------------------------------------------------------------------------
# massof

"""
    massof(
      species::Species,
    )

    massof(
      speciesname::String,
    )

## Description:
return mass of 'species' in current unit, or return the mass of the species with 'speciesname' in current unit.

## parameters:
- `species`     -- type:`Species`, the species whose mass you want to know
- `speciesname` -- type:`String`, the name of the species whose mass you want to know
"""
massof

#---------------------------------------------------------------------------------------------------
# chargeof

"""
    chargeof(
      species::Species,
    )
    chargeof(
      speciesname::String,
    )

## Description:
return charge of 'species' in current unit, or return the charge of the species with 'speciesname' in current unit.

## parameters:
- `species`     -- type:`Species`, the species whose charge you want to know
- `speciesname` -- type:`String`, the name of the species whose charge you want to know

"""
chargeof

#---------------------------------------------------------------------------------------------------
# spinof

"""
    spinof(
      species::Species,
    )
    spinof(
      speciesname::String,
    )

## Description:
return spin of 'species' in current unit, or return the charspinge of the species with 'speciesname' in current unit.

## parameters:
- `species`     -- type:`Species`, the species whose spin you want to know
- `speciesname` -- type:`String`, the name of the species whose spin you want to know

"""
spinof

#---------------------------------------------------------------------------------------------------
# nameof

"""
  nameof(
    species::Species;
    basename::Bool = false
  )


## Description:
yields the name of the species as a string; in the case of a 
subatomic particle you get the exact name; in the case of an atom 
the default behavior is to return the full name, eg "#235U" for 
Uranium 235, but if the kwarg 'basename' is set to 'true' nameof 
would return just "U"

## parameters:
- `species`     --  type:`Species`, the species whose name you want to know
- `basename` -- type:`Bool`, whether to include the isotope number and charge state of an atom.

"""
nameof


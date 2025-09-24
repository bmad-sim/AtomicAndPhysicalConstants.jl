using Pkg
srcdir = dirname(pathof(AtomicAndPhysicalConstants))

# Declare specific systems of units

#---------------------------------------------------------------------------------------------------
#   for particle physics

@doc """
    ACCELERATOR
## ACCELERATOR units:
- `mass`: eV/c^2
- `length`: m
- `time`: s
- `energy`: eV
- `charge`: elementary charge
- `magnetic field`: T
- `spin`: h_bar (ħ)
"""
const ACCELERATOR = (
  u"eV/c^2",
  u"m",
  u"s",
  u"eV",
  u"e",
  u"T",
  u"h_bar")

#---------------------------------------------------------------------------------------------------
#   MKS

@doc """
    MKS
## MKS units:
- `mass`: kg
- `length`: m
- `time`: s
- `energy`: J
- `charge`: C
- `magnetic field`: T
- `spin`: h_bar (ħ)
"""
const MKS = (
  u"kg",
  u"m",
  u"s",
  u"J",
  u"C",
  u"T",
  u"h_bar")

#---------------------------------------------------------------------------------------------------
# CGS

@doc """
    CGS
## CGS units:
- `mass`: g
- `length`: cm
- `time`: s
- `energy`: J
- `charge`: C
- `magnetic field`: Gauss
- `spin`: h_bar (ħ)
"""
const CGS = (
  u"g",
  u"cm",
  u"s",
  u"J",
  u"C",
  u"Gauss",
  u"h_bar")

#---------------------------------------------------------------------------------------------------
# @APCdef

"""
    @APCdef(unitsystem = ACCELERATOR, unittype = Float, name = :APC, year = 2022)

## Description:
It defines the physical constants and getter functions for species mass and charge with the proper unit and data.

## Output:
It creates four getter functions:
- `massof()`
- `chargeof()`
- `spinof()`
- `nameof()`

If `tupleflag = true` then it creates a name tuple with all the physical constants.

If `tupleflag = false` then it creates the constants as individual variables.
  
## keyword parameters:
- `unitsystem`   -- type: 5-Tuple of `Unitful` units. Specify the unit system, default to `ACCELERATOR`, which sets units to 'Default units' (see below).
                                        The other options are `MKS`, and `CGS`. It provides a convient way to set all the units.
- `unittype`     -- Sets the return type of the constants and the getter functions. It can be `Float`, `Unitful`, or `DynamicQuantities`. Default to `Float`.
- `name`         -- Sets the name of the module that contains the constants and getter functions. Default to `APC`.
- `tupleflag`    -- type: `Bool`, whether to return the constants in a tuple or not. Default to `true`. If set to `false`, it will return the constants as individual variables.
- `year`         -- chooses which CODATA release year to set constants from. Options are 2002, 2006, 2010, 2014, 2018, and 2022. Default is 2022.
    
## Note
- @APCdef can be called only once in a module.

## Default units:
- `mass`: eV/c^2
- `length`: m
- `time`: s
- `energy`: eV
- `charge`: elementary charge
- `magnetic field`: T
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
  unitsystem::NTuple{7,Unitful.FreeUnits} = ACCELERATOR
  name::Symbol = :APC
  tupleflag::Bool = true # whether return the constants in a tuple or not
  year::Int32 = 2022 # default release year

  # list of available release years: update as more come out
  years::Vector{Int32} = [2002, 2006, 2010, 2014, 2018, 2022]


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
      name = kwargdict[:name]
      wrapper = String(name)
    elseif k == :tupleflag
      if kwargdict[:tupleflag] isa Bool
        tupleflag = kwargdict[:tupleflag]
      else
        @error "tupleflag should be a boolean value"
        return
      end
    elseif k == :year
      if kwargdict[:year] ∈ years
        year = kwargdict[:year]
      else
        @error "$(kwargdict[:year]) isn't an available CODATA release: using the 2022 release instead"
      end
    else
      @error "$k is not a proper keyword argument for @APCdef, the only options are `unittype`, `unitsystem`, `name`, `year`"
      return
    end
  end


  # set the release year for the CODATA constants
  release::CODATA = CODATA2022

  if year == 2002
    release = CODATA2002
  elseif year == 2006
    release = CODATA2006
  elseif year == 2010
    release = CODATA2010
  elseif year == 2014
    release = CODATA2014
  elseif year == 2018
    release = CODATA2018
  end

  # set the base values for subatomic particles
  # inside the APC module, so it doesn't pollute

  # Core.eval(AtomicAndPhysicalConstants, :(SUBATOMIC_SPECIES = subatomic_species($release)))  

  


  # extract the units from the unit system
  mass_unit::Unitful.FreeUnits = unitsystem[1]
  length_unit::Unitful.FreeUnits = unitsystem[2]
  time_unit::Unitful.FreeUnits = unitsystem[3]
  energy_unit::Unitful.FreeUnits = unitsystem[4]
  charge_unit::Unitful.FreeUnits = unitsystem[5]
  field_unit::Unitful.FreeUnits = unitsystem[6]
  spin_unit::Unitful.FreeUnits = unitsystem[7]

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
  if dimension(field_unit) != dimension(u"T")
    error("unit for magnetic field does not have proper dimension")
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
    dimension(u"J/T") => energy_unit / field_unit
  )
  unit_names::Dict{Symbol,Unitful.FreeUnits} = Dict(
    :mass => mass_unit,
    :length => length_unit,
    :time => time_unit,
    :energy => energy_unit,
    :charge => charge_unit,
    :velocity => length_unit / time_unit,
    :action => energy_unit * time_unit,
    :mag_mom => energy_unit / field_unit,
    :spin => spin_unit
  )
  # this vector contains the names of the all the constants in the module in symbols
  constants::NTuple{16, Symbol} = filter(x -> (
    startswith(string(x), "__b_") && # the name starts with __b_
    !occursin("_m_", string(x)) && # the name does not contain _m_, so that it is not a mass
    (!occursin("_mu_", string(x)) || occursin("__b_mu_0_vac", string(x))) && # the name does not contain _mu_, so that it is not a magnetic moment
    !occursin("_gspin_", string(x)) && 
    !occursin("_gyro_", string(x)) # make sure the name doesn't include _gspin_, so constants generated from spin functions aren't included
  ), fieldnames(CODATA))

  constantdict_type::Type = Dict{Symbol,Union{Unitful.Quantity,Float64,Int32,DynamicQuantities.Quantity{Float64,DynamicQuantities.Dimensions{DynamicQuantities.FixedRational{Int32,25200}}}}}

  # create a dictionary that contains all the constants in the module
  # convert the constants to the proper unit
  constantsdict::constantdict_type = Dict()
  for sym in constants
    value = getfield(release, sym) # the value of the constant
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
      if value isa Float64 || value isa Int32
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
        const $(esc(name)) = NamedTuple{Tuple(keys($constantsdict))}(values($constantsdict))
      end
    else
      Expr(:block, [:(const $(esc(key)) = $(value)) for (key, value) in constantsdict]...)
    end
  end

  

  return quote
    

    const $(esc(:APCconsts)) = $wrapper

    const $(esc(:UNITS)) = NamedTuple{Tuple(keys($unit_names))}(values($unit_names))

    $(generate_constructor(release))

    $(generate_particle_property_functions(unittype, mass_unit, charge_unit, spin_unit, energy_unit, field_unit))

    
    
    $(tuple_statement)

  end

end

function generate_constructor(release::AtomicAndPhysicalConstants.CODATA)
  return_species = (release) -> begin
    return quote
      return AtomicAndPhysicalConstants.Species(speciesname, $release)
    end 
  end
  
  return quote
    function $(esc(:Species))(speciesname::String)::$(AtomicAndPhysicalConstants.Species)
      $(return_species(release))
    end
  end
end


function generate_particle_property_functions(unittype, mass_unit, charge_unit, spin_unit, energy_unit, field_unit)
  # require that the unittype is one of Float, Unitful, DynamicQuantities
  unittype in [:Float, :Unitful, :DynamicQuantities] || error("unittype should be one of Float, Unitful, DynamicQuantities")
  # require that the mass_unit, charge_unit, spin_unit are of proper dimension
  if dimension(mass_unit) != dimension(u"kg")
    error("unit for mass does not have proper dimension")
  end
  if dimension(charge_unit) != dimension(u"C")
    error("unit for charge does not have proper dimension")
  end
  if dimension(spin_unit) != dimension(u"h_bar")
    error("unit for charge does not have proper dimension")
  end
  if dimension(energy_unit / field_unit) != dimension(u"J/T")
    error("unit for magnetic moment does not have proper dimension")
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
    function $(esc(:massof))(species::AtomicAndPhysicalConstants.Species)::$(typename)
      getfield(species, :kind) != Kind.NULL || error("Can't call massof() on a null Species object.")
      $(return_statement(mass_unit, "mass"))
    end
    function $(esc(:massof))(speciesname::String)::$(typename)
      species = Species(speciesname)
      getfield(species, :kind) != Kind.NULL || error("Can't call massof() on a null Species object.")
      $(return_statement(mass_unit, "mass"))
    end
    function $(esc(:chargeof))(species::AtomicAndPhysicalConstants.Species)::$(typename)
      getfield(species, :kind) != Kind.NULL || error("Can't call chargeof() on a null Species object.")
      $(return_statement(charge_unit, "charge"))
    end
    function $(esc(:chargeof))(speciesname::String)::$(typename)
      species = Species(speciesname)
      getfield(species, :kind) != Kind.NULL || error("Can't call chargeof() on a null Species object.")
      $(return_statement(charge_unit, "charge"))
    end
    function $(esc(:spinof))(species::AtomicAndPhysicalConstants.Species)::$(typename)
      getfield(species, :kind) != Kind.NULL || error("Can't call spinof() on a null Species object.")
      getfield(species, :kind) != Kind.ATOM || error("The spin projection of a whole atom is ambiguous.")
      $(return_statement(spin_unit, "spin"))
    end
    function $(esc(:spinof))(speciesname::String)::$(typename)
      species = Species(speciesname)
      getfield(species, :kind) != Kind.NULL || error("Can't call spinof() on a null Species object.")
      getfield(species, :kind) != Kind.ATOM || error("The spin projection of a whole atom is ambiguous.")
      $(return_statement(spin_unit, "spin"))
    end
    function $(esc(:momentof))(species::AtomicAndPhysicalConstants.Species)::$(typename)
      getfield(species, :kind) != Kind.NULL || error("Can't call momentof() on a null Species object.")
      $(return_statement(energy_unit/field_unit, "magnetic moment"))
    end
    function $(esc(:momentof))(speciesname::String)::$(typename)
      species = Species(speciesname)
      getfield(species, :kind) != Kind.NULL || error("Can't call momentof() on a null Species object.")
      $(return_statement(energy_unit/field_unit, "magnetic moment"))
    end
    function $(esc(:isotopeof))(species::AtomicAndPhysicalConstants.Species)::$(typename)
      getfield(species, :kind) != Kind.NULL || error("Can't call isotopeof() on a null Species object.")
      getfield(species, :kind) == Kind.ATOM || error("This function only returns atomic isotope numbers.")
      $getfield(species, :iso)
    end
    function $(esc(:isotopeof))(speciesname::String)::$(typename)
      species = Species(speciesname)
      getfield(species, :kind) != Kind.NULL || error("Can't call isotopeof() on a null Species object.")
      getfield(species, :kind) == Kind.ATOM || error("This function only returns atomic isotope numbers.")
      $getfield(species, :iso)
    end
    function $(esc(:kindof))(species::AtomicAndPhysicalConstants.Species)::$(Enum{Int32})
      return getfield(species, :kind)
    end
    function $(esc(:kindof))(speciesname::String)::$(Enum{Int32})
      species = Species(speciesname)
      return getfield(species, :kind)
    end
    function $(esc(:nameof))(species::AtomicAndPhysicalConstants.Species; basename::Bool=false)::String
      getfield(species, :kind) != Kind.NULL || error("Can't call nameof() on a null Species object")
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
      species::AtomicAndPhysicalConstants.Species,
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
      species::AtomicAndPhysicalConstants.Species,
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
      species::AtomicAndPhysicalConstants.Species,
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
    species::AtomicAndPhysicalConstants.Species;
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


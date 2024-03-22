
include("PhysicalConstants.jl")


#speed of light
const C = 299792458.0

"""
unit named with 'name',
convert to standard international unit system unit with 'conversion', 1 unit = 'conversion' SI unit
Example, eV = Unit("eV",1.783*10^-36)
"""
struct Unit
    name::AbstractString
    conversion::Float64
end


"""
scale functions that turns unit to kilo-unit, mega-unit, etc
"""
#kilo
function k(unit::Unit)
    return Unit("k"*unit.name,unit.conversion*10^3)
end
#mega
function M(unit::Unit)
    return Unit("M"*unit.name,unit.conversion*10^6)
end
#giga
function G(unit::Unit)
    return Unit("G"*unit.name,unit.conversion*10^9)
end
#tera
function T(unit::Unit)
    return Unit("T"*unit.name,unit.conversion*10^9)
end
#mili
function m(unit::Unit)
    return Unit("m"*unit.name,unit.conversion*10^-3)
end
#micro
function mu(unit::Unit)
    return Unit("mu "*unit.name,unit.conversion*10^-6)
end
#nano
function n(unit::Unit)
    return Unit("n"*unit.name,unit.conversion*10^-9)
end

"""
multiply unit with number gives conversion for you new units
Example: electric_volt = Unit("eV",e_charge*Joule), it is saying that 1eV = 1.6*10^-19 J
"""
Base.:*(conversion::Float64, unit::Unit) = conversion*unit.conversion
"""
The unit system, users can change some of the fields based on a set unit system
"""
mutable struct UnitSystem
    mass::Unit
    length::Unit
    time::Unit
    momentum::Unit
    angular_momentum::Unit
    energy::Unit
    charge::Unit
    magnetic_field::Unit
end

"""
units for MKS unit system, 
kilogram, second, meter, kilogram_meter_per_second, Joule, Coulomb, Tesla, Kelvin
"""
gram = Unit("g",10^-3)
second = Unit("s",1)
meter = Unit("m",1)
gram_meter_per_second = Unit("g*m/s",10^-3)
gram_meter2_per_second = Unit("g*m^2/s",10^-3)
Joule = Unit("J",1)
Coulomb = Unit("C",1)
Tesla = Unit("T",1)

MKS = UnitSystem(k(gram),meter,second,k(gram_meter_per_second),k(gram_meter2_per_second),Joule,Coulomb,Tesla)


"""
particle physics units, the units used in this package
"""
eV_per_c2 = Unit("eV/c^2",e_charge/C^2*k(gram))
amu = Unit("amu",kg_per_amu*k(gram))
eV = Unit("eV",e_charge*Joule)
elementary_charge = Unit("e",e_charge*Coulomb)
h_bar = Unit("h_bar",h_bar_planck*k(gram_meter2_per_second))

# If you want to replace eV_per_c2 with amu, just write ParticlePhysics.mass = amu
ParticlePhysics = UnitSystem(eV_per_c2,meter,second,k(gram_meter_per_second),h_bar,eV,elementary_charge,Tesla)



function set_units(unit_system::UnitSystem)
    
end

export set_units, meter
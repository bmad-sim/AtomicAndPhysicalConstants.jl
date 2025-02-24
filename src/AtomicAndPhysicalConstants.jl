module AtomicAndPhysicalConstants

using PyFormattedStrings
using Dates
using HTTP
using JSON
using EnumX
using Reexport
@reexport using Unitful

include("units_definition.jl")
include("types.jl")
include("2002_constants.jl")
include("2006_constants.jl")
include("2010_constants.jl")
include("2014_constants.jl")
include("2018_constants.jl")
include("2022_constants.jl")
include("constructors.jl")
include("isotopes.jl")
include("update_pion_mass.jl")
include("update_constants.jl")
include("update_isos.jl")
include("functions.jl")
include("APCdef.jl")

export @APCdef
export CODATA2002, CODATA2006, CODATA2010, CODATA2014, CODATA2018, CODATA2022
export ACCELERATOR, MKS, CGS
export SubatomicSpecies
export AtomicSpecies
# export SUBATOMIC_SPECIES
export ATOMIC_SPECIES
export useCODATA
export @u_str, NewUnits

end

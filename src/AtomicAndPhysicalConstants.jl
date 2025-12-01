module AtomicAndPhysicalConstants

using Reexport
using EnumX
using Dates
using HTTP
using JSON
using Unitful

# kind enum stores the kind of particle
# NULL is for null species (placeholder species)
@enumx Kind ATOM HADRON LEPTON PHOTON NULL

include("helpers.jl")
include("defaults.jl")
include("constants_struct.jl")
include("species.jl")
include("types.jl")
include("apc_units.jl")
include("2002_constants.jl")
include("2006_constants.jl")
include("2010_constants.jl")
include("2014_constants.jl")
include("2018_constants.jl")
include("2022_constants.jl")
include("subatomic_species.jl")
include("setconst.jl")
# include("constructors.jl")
# include("isotopes.jl")
# include("functions.jl")

# include("APCdef.jl")
# include("showconst.jl")
# include("docstrings.jl")

# export @APCdef

# export ACCELERATOR, MKS, CGS
# export NewUnits
# export showconst
# export full_name, atomicnumber, g_spin, gyromagnetic_anomaly, g_nucleon, to_openPMD
# export Kind
# export ATOM, HADRON, LEPTON, PHOTON, NULL
# export SpeciesN

# import ..AtomicAndPhysicalConstants: Species, SubatomicSpecies, AtomicSpecies, Kind


end
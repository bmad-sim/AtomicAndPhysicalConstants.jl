module AtomicAndPhysicalConstants

export PreRelease
# export CODATA2002, CODATA2006, CODATA2010, CODATA2014, CODATA2018, CODATA2022
using Reexport
using EnumX
using Dates
using HTTP
using JSON
using Unitful
import DynamicQuantities

include("units_definition.jl")
using .NewUnits
@reexport using Unitful

include("constants_struct.jl")
include("prerelease.jl")
include("types.jl")
include("2002_constants.jl")
include("2006_constants.jl")
include("2010_constants.jl")
include("2014_constants.jl")
include("2018_constants.jl")
include("2022_constants.jl")
include("constructors.jl")
include("isotopes.jl")
include("subatomic_species.jl")
include("functions.jl")

include("APCdef.jl")
include("showconst.jl")
include("docstrings.jl")

# global APCflag::Bool = false
# export APCflag;

@reexport using .PreRelease
# @reexport using .CODATA2022

export @APCdef
export ACCELERATOR, MKS, CGS
# export Species
export SubatomicSpecies
export AtomicSpecies
# export SUBATOMIC_SPECIES
# export ATOMIC_SPECIES
# export useCODATAm
export NewUnits
export showconst
export full_name, atomicnumber, g_spin, gyromagnetic_anomaly, g_nucleon, to_openPMD
export Kind
export ATOM, HADRON, LEPTON, PHOTON, NULL
export SpeciesN

import ..AtomicAndPhysicalConstants: Species, SubatomicSpecies, AtomicSpecies, Kind


end
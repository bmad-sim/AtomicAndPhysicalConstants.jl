module AtomicAndPhysicalConstants

using Reexport
using EnumX
using Dates
using HTTP
using JSON

# kind enum stores the kind of particle
# NULL is for null species (placeholder species)
@enumx Kind ATOM HADRON LEPTON PHOTON NULL
# precompile regEx
const anti_regEx = r"anti\-|anti"
const mag_regEx = r"[0-9]|[0-9][0-9]|[0-9][0-9][0-9]"

include("types.jl")
include("CODATA2002.jl")
include("CODATA2006.jl")
include("CODATA2010.jl")
include("CODATA2014.jl")
include("CODATA2018.jl")
include("CODATA2022.jl")

release::CODATA_release = CODATA2022

include("functions.jl")
# include("constants.jl")
# include("species_data.jl")
include("constructors.jl")

# export the const pointers to values
export M_ELECTRON, M_PROTON, M_NEUTRON, M_MUON, M_HELION, M_DEUTERON
export M_PION_0, M_PION_CHARGED

export MU_DEUTERON, MU_ELECTRON, MU_HELION, MU_MUON, MU_NEUTRON, MU_PROTON, MU_TRITON

export N_AVOGADRO, FINE_STRUCTURE
export GYRO_ANOM_ELECTRON, GYRO_ANOM_MUON
export GSPIN_DEUTERON, GSPIN_ELECTRON, GSPIN_HELION, GSPIN_MUON, GSPIN_NEUTRON, GSPIN_PROTON, GSPIN_TRITON

export E_CHARGE, R_E, R_P, C_LIGHT, H_PLANCK, H_BAR_PLANCK, CLASSICAL_RADIUS_FACTOR, EPS_0_VAC, MU_0_VAC, RELEASE_YEAR

export CODATA2002, CODATA2006, CODATA2010, CODATA2014, CODATA2018, CODATA2022
# export the pointer to subatomic species dict
export SUBATOMIC_SPECIES
# export the atomic species dict
export ATOMIC_SPECIES

export Species

export chargeof, massof, spinof, momentof, iso_of
end
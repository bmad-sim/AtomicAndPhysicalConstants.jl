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
# precompile regEx
const anti_regEx = r"Anti\-|anti\-|Anti|anti"

include("defaults.jl")
include("CODATAstruct.jl")
include("2002_constants.jl")
include("2006_constants.jl")
include("2010_constants.jl")
include("2014_constants.jl")
include("2018_constants.jl")
include("2022_constants.jl")
include("ptypes.jl")
include("helpers.jl")
include("apc_units.jl")
include("atomic_species.jl")
include("subatomic_species.jl")
include("species.jl")
include("setconst.jl")
include("gyro_vals.jl")

# export the const pointers to values
export m_electron, m_proton, m_neutron, m_muon, m_helion, m_deuteron
export m_pion_0, m_pion_charged

export mu_deuteron, mu_electron, mu_helion, mu_muon, mu_neutron, mu_proton, mu_triton

export N_avogadro, fine_structure
export gyro_anom_electron, gyro_anom_muon
export gspin_deuteron, gspin_electron, gspin_helion, gspin_muon, gspin_neutron, gspin_proton, gspin_triton

export e_charge, r_e, r_p, c_light, h_planck, h_bar_planck, eps_0_vac, mu_0_vac, RELEASE_YEAR

# export the pointer to subatomic species dict
export SUBATOMIC_SPECIES
# export the atomic species dict
export ATOMIC_SPECIES

export Species

export setconst
end
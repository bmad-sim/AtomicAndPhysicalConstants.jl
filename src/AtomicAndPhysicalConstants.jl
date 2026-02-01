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
include("constants.jl")
include("helpers.jl")
include("species_data.jl")
include("constructors.jl")
# include("gyro_vals.jl")
include("getter_functions.jl")

# export the const pointers to values
export m_electron, m_proton, m_neutron, m_muon, m_helion, m_deuteron
export m_pion_0, m_pion_charged

export mu_deuteron, mu_electron, mu_helion, mu_muon, mu_neutron, mu_proton, mu_triton

export N_Avogadro, fine_structure
export gyro_anom_electron, gyro_anom_muon
export gspin_deuteron, gspin_electron, gspin_helion, gspin_muon, gspin_neutron, gspin_proton, gspin_triton

export e_charge, r_e, r_p, c_light, h_Planck, h_bar_Planck, classical_radius_factor, eps_0_vac, mu_0_vac, RELEASE_YEAR

export CODATA2002, CODATA2006, CODATA2010, CODATA2014, CODATA2018, CODATA2022
# export the pointer to subatomic species dict
export SUBATOMIC_SPECIES
# export the atomic species dict
export ATOMIC_SPECIES

export Species

export chargeof, massof, spinof, momentof, iso_of
end
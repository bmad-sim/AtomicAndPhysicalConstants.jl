module AtomicAndPhysicalConstants

using PyFormattedStrings
using Dates
using HTTP
using JSON
using Reexport
@reexport using Unitful

include("units_definition.jl")
include("constants.jl")
include("species_initialize.jl")
include("atomic_isotopes.jl")
include("subatomic_species.jl")
include("update_pion_mass.jl")
include("update_constants.jl")
include("update_iso_masses.jl")
include("particle_functions.jl")
include("set_units.jl")

export setunits
export ACCELERATOR, MKS, CGS
export massof, chargeof
export C_LIGHT, H_PLANCK, H_BAR_PLANCK, R_E, R_P, E_CHARGE, MU_0_VAC, EPS_0_VAC, CLASSICAL_RADIUS_FACTOR, FINE_STRUCTURE, N_AVOGADRO
export SubatomicSpecies
export AtomicSpecies
export SUBATOMIC_SPECIES
export ATOMIC_SPECIES
export setCODATA
export @u_str, NewUnits

#export anom_mag_moment_electron, anom_mag_moment_muon, anom_mag_moment_proton, anom_mag_moment_deuteron, anom_mag_moment_neutron, anom_mag_moment_He3

end
"""
APClite.jl - A lightweight version of AtomicAndPhysicalConstants.jl

This package provides atomic and physical constants as plain Float64 values
without Unitful dependencies. It includes a simplified Species struct for
representing particles and atoms.

Key features:
- Latest CODATA 2022 physical constants as plain floats
- Simplified Species struct for particles and atoms
- No macros or complex unit systems
- Fast compile times and minimal dependencies
"""

module AtomicAndPhysicalConstants

# Include all modules
include("types.jl")
include("constants.jl")
include("constructors.jl")
include("species_data.jl")
include("functions.jl")

# Export main types and functions
export Species
export Kind, ATOM, HADRON, LEPTON, PHOTON, NULL

# Physical and fundamental constants
export C_LIGHT, H_PLANCK, H_BAR, E_CHARGE
export FINE_STRUCTURE, AVOGADRO
export R_ELECTRON, R_PROTON, EPS_0, MU_0

# Mass constants
export M_ELECTRON, M_PROTON, M_NEUTRON, M_MUON, M_PION_0, M_PION_CHARGED, M_DEUTERON, M_HELION

# Magnetic moments
export MU_ELECTRON, MU_PROTON, MU_NEUTRON, MU_MUON, MU_DEUTERON, MU_HELION, MU_TRITON

# g-factors and anomalies
export ANOMALY_ELECTRON, ANOMALY_MUON
export G_ELECTRON, G_PROTON, G_NEUTRON, G_MUON, G_DEUTERON, G_HELION, G_TRITON

# Unit conversions
export KG_PER_AMU, EV_PER_AMU, J_PER_EV

# Functions
export massof, chargeof, atomicnumberof, kindof, g_spin, gyromagnetic_anomaly, isnullspecies

end # module

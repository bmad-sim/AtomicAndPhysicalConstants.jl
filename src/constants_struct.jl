# AtomicAndPhysicalConstants/src/constants_struct.jl




# @doc"""
# CODATA is a type which contains all the relevant constants from our package;
# each release year is a different struct object with name "CODATAYYYY" where 
# YYYY is the year of the release.
# """ CODATA

Base.@kwdef struct CODATA
#####################################################################
# constants with dimension [mass]
#####################################################################

__b_m_electron::Float64
# Electron Mass [MeV]/c^2
__b_m_proton::Float64
# Proton Mass [MeV]/c^2
__b_m_neutron::Float64
# Neutron Mass [MeV]/c^2
__b_m_muon::Float64
# Muon Mass [MeV]/c^2
__b_m_helion::Float64
# Helion Mass He3 nucleus [MeV]/c^2
__b_m_deuteron::Float64
# Deuteron Mass [MeV]/c^2

# constants mysteriously missing from the release
# picked up from PDG
__b_m_pion_0::Float64
# uncharged pion mass [eV]/c^2
__b_m_pion_charged::Float64
# charged pion mass [eV]/c^2


#####################################################################
# constants with dimension [magnetic moment]
#####################################################################

__b_mu_deuteron::Float64
# deuteron magnetic moment in [J/T]
__b_mu_electron::Float64
# electron magnetic moment in [J/T]
__b_mu_helion::Float64
# helion magnetic moment in [J/T]
__b_mu_muon::Float64
# muon magnetic moment in [J/T]
__b_mu_neutron::Float64
# neutron magnetic moment in [J/T]
__b_mu_proton::Float64
# proton magnetic moment in [J/T]
__b_mu_triton::Float64
# triton magnetic moment in [J/T]


#####################################################################
# dimensionless constants
#####################################################################

__b_N_avogadro::Float64 
# Avogadro's constant: Number / mole (exact)
__b_fine_structure::Float64 
# fine structure constant

__b_gyro_anom_electron::Float64 
# electron magnetic moment anomaly
__b_gyro_anom_muon::Float64
# muon magnetic moment anomaly

__b_gspin_deuteron::Float64
# deuteron g factor 
__b_gspin_electron::Float64 
# electron g factor 
__b_gspin_helion::Float64 
# helion g factor 
__b_gspin_muon::Float64 
# muon g factor 
__b_gspin_neutron::Float64 
# neutron g factor 
__b_gspin_proton::Float64 
# proton g factor 
__b_gspin_triton::Float64 
# triton g factor




#####################################################################
# constants with miscelaneous dimension
#####################################################################

__b_e_charge::Float64
# elementary charge [C]
__b_r_e::Float64
# classical electron radius [m]
__b_r_p::Float64
# classical proton radius [m]
__b_c_light::Float64
# speed of light [m/s]
__b_h_planck::Float64
# Planck's constant [J*s]
__b_h_bar_planck::Float64
# h_planck/twopi [J*s]
__b_classical_radius_factor::Float64
# e^2 / (4 pi eps_0) = classical_radius*mass*c^2.
# Is same for all particles of charge +/- 1.

__b_eps_0_vac::Float64
# Permittivity of free space in [F/m]
__b_mu_0_vac::Float64
# Vacuum permeability in [N/A^2] (newtons per ampere squared)

__b_RELEASE_YEAR::Int32
# release year for posterity
end
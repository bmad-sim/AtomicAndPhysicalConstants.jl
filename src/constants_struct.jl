# AtomicAndPhysicalConstants/src/constants_struct.jl




# @doc"""
# CODATA is a type which contains all the relevant constants from our package;
# each release year is a different struct object with name "CODATAYYYY" where 
# YYYY is the year of the release.
# """ CODATA

@kwdef struct CODATA_release

#######################################
# constants with dimension [mass]
#######################################


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


#######################################
# constants with dimension [magnetic moment]
#######################################


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


#######################################
# dimensionless constants
#######################################


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


#######################################
# constants with miscellaneous dimension
#######################################


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



@kwdef struct conversion_consts
  g_per_amu::Float64
  eV_per_amu::Float64
  J_per_eV::Float64
  e_coulomb::Float64
  g_per_eV::Float64
end

# @kwdef struct CODATA_vals

# #######################################
# # constants with dimension [mass]
# #######################################


# M_ELECTRON::Float64
# # Electron Mass
# M_PROTON::Float64
# # Proton Mass
# M_NEUTRON::Float64
# # Neutron Mass
# M_MUON::Float64
# # Muon Mass
# M_HELION::Float64
# # Helion Mass He3 nucleus
# M_DEUTERON::Float64
# # Deuteron Mass
# M_PION_0::Float64
# # uncharged pion mass
# M_PION_CHARGED::Float64
# # charged pion mass


# #######################################
# # constants with dimension [magnetic moment]
# #######################################


# MU_DEUTERON::Float64
# # deuteron magnetic moment
# MU_ELECTRON::Float64
# # electron magnetic moment
# MU_HELION::Float64
# # helion magnetic moment
# MU_MUON::Float64
# # muon magnetic moment
# MU_NEUTRON::Float64
# # neutron magnetic moment
# MU_PROTON::Float64
# # proton magnetic moment
# MU_TRITON::Float64
# # triton magnetic moment


# #######################################
# # dimensionless constants
# #######################################


# N_AVOGADRO::Float64 
# # Avogadro's constant: Number / mole (exact)
# FINE_STRUCTURE::Float64 
# # fine structure constant

# GYRO_ANOM_ELECTRON::Float64 
# # electron magnetic moment anomaly
# GYRO_ANOM_MUON::Float64
# # muon magnetic moment anomaly

# GSPIN_DEUTERON::Float64
# # deuteron g factor 
# GSPIN_ELECTRON::Float64 
# # electron g factor 
# GSPIN_HELION::Float64 
# # helion g factor 
# GSPIN_MUON::Float64 
# # muon g factor 
# GSPIN_NEUTRON::Float64 
# # neutron g factor 
# GSPIN_PROTON::Float64 
# # proton g factor 
# GSPIN_TRITON::Float64 
# # triton g factor


# #######################################
# # constants with miscellaneous dimension
# #######################################


# E_CHARGE::Float64
# # elementary charge
# R_E::Float64
# # classical electron radius
# R_P::Float64
# # classical proton radius
# C_LIGHT::Float64
# # speed of light
# H_PLANCK::Float64
# # Planck's constant
# H_BAR_PLANCK::Float64
# # h_planck/twopi
# CLASSICAL_RADIUS_FACTOR::Float64
# # e^2 / (4 pi eps_0) = classical_radius*mass*c^2.
# # Is same for all particles of charge +/- 1.

# EPS_0_VAC::Float64
# # Permittivity of free space
# MU_0_VAC::Float64
# # Vacuum permeability

# RELEASE_YEAR::Int32
# # release year for posterity


# end
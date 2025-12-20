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


m_electron::Float64
# Electron Mass [MeV]/c^2
m_proton::Float64
# Proton Mass [MeV]/c^2
m_neutron::Float64
# Neutron Mass [MeV]/c^2
m_muon::Float64
# Muon Mass [MeV]/c^2
m_helion::Float64
# Helion Mass He3 nucleus [MeV]/c^2
m_deuteron::Float64
# Deuteron Mass [MeV]/c^2

# constants mysteriously missing from the release
# picked up from PDG
m_pion_0::Float64
# uncharged pion mass [eV]/c^2
m_pion_charged::Float64
# charged pion mass [eV]/c^2


#######################################
# constants with dimension [magnetic moment]
#######################################


mu_deuteron::Float64
# deuteron magnetic moment in [J/T]
mu_electron::Float64
# electron magnetic moment in [J/T]
mu_helion::Float64
# helion magnetic moment in [J/T]
mu_muon::Float64
# muon magnetic moment in [J/T]
mu_neutron::Float64
# neutron magnetic moment in [J/T]
mu_proton::Float64
# proton magnetic moment in [J/T]
mu_triton::Float64
# triton magnetic moment in [J/T]


#######################################
# dimensionless constants
#######################################


N_avogadro::Float64 
# Avogadro's constant: Number / mole (exact)
fine_structure::Float64 
# fine structure constant

gyro_anom_electron::Float64 
# electron magnetic moment anomaly
gyro_anom_muon::Float64
# muon magnetic moment anomaly

gspin_deuteron::Float64
# deuteron g factor 
gspin_electron::Float64 
# electron g factor 
gspin_helion::Float64 
# helion g factor 
gspin_muon::Float64 
# muon g factor 
gspin_neutron::Float64 
# neutron g factor 
gspin_proton::Float64 
# proton g factor 
gspin_triton::Float64 
# triton g factor


#######################################
# constants with miscellaneous dimension
#######################################

e_charge::Float64
# elementary charge [C]
r_e::Float64
# classical electron radius [m]
r_p::Float64
# classical proton radius [m]
c_light::Float64
# speed of light [m/s]
h_planck::Float64
# Planck's constant [J*s]
h_bar_planck::Float64
# h_planck/twopi [J*s]
classical_radius_factor::Float64
# e^2 / (4 pi eps_0) = classical_radius*mass*c^2.
# Is same for all particles of charge +/- 1.

eps_0_vac::Float64
# Permittivity of free space in [F/m]
mu_0_vac::Float64
# Vacuum permeability in [N/A^2] (newtons per ampere squared)


#######################################
# conversion_consts
#######################################

g_per_amu::Float64
# grams per dalton
eV_per_amu::Float64
# electronvolts/c^2 per dalton
J_per_eV::Float64
# Joules per electronvolt
e_coulomb::Float64
# elementary charge in Coulombs
g_per_eV::Float64
# grams per electronvolt/c^2


RELEASE_YEAR::Int32
# release year for posterity
end




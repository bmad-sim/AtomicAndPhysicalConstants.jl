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


m_electron::Float32
# Electron Mass [MeV]/c^2
m_proton::Float32
# Proton Mass [MeV]/c^2
m_neutron::Float32
# Neutron Mass [MeV]/c^2
m_muon::Float32
# Muon Mass [MeV]/c^2
m_helion::Float32
# Helion Mass He3 nucleus [MeV]/c^2
m_deuteron::Float32
# Deuteron Mass [MeV]/c^2

# constants mysteriously missing from the release
# picked up from PDG
m_pion_0::Float32
# uncharged pion mass [eV]/c^2
m_pion_charged::Float32
# charged pion mass [eV]/c^2


#######################################
# constants with dimension [magnetic moment]
#######################################


mu_deuteron::Float32
# deuteron magnetic moment in [J/T]
mu_electron::Float32
# electron magnetic moment in [J/T]
mu_helion::Float32
# helion magnetic moment in [J/T]
mu_muon::Float32
# muon magnetic moment in [J/T]
mu_neutron::Float32
# neutron magnetic moment in [J/T]
mu_proton::Float32
# proton magnetic moment in [J/T]
mu_triton::Float32
# triton magnetic moment in [J/T]


#######################################
# dimensionless constants
#######################################


N_avogadro::Float32 
# Avogadro's constant: Number / mole (exact)
fine_structure::Float32 
# fine structure constant

gyro_anom_electron::Float32 
# electron magnetic moment anomaly
gyro_anom_muon::Float32
# muon magnetic moment anomaly

gspin_deuteron::Float32
# deuteron g factor 
gspin_electron::Float32 
# electron g factor 
gspin_helion::Float32 
# helion g factor 
gspin_muon::Float32 
# muon g factor 
gspin_neutron::Float32 
# neutron g factor 
gspin_proton::Float32 
# proton g factor 
gspin_triton::Float32 
# triton g factor


#######################################
# constants with miscellaneous dimension
#######################################

e_charge::Float32
# elementary charge [C]
r_e::Float32
# classical electron radius [m]
r_p::Float32
# classical proton radius [m]
c_light::Float32
# speed of light [m/s]
h_planck::Float32
# Planck's constant [J*s]
h_bar_planck::Float32
# h_planck/twopi [J*s]
classical_radius_factor::Float32
# e^2 / (4 pi eps_0) = classical_radius*mass*c^2.
# Is same for all particles of charge +/- 1.

eps_0_vac::Float32
# Permittivity of free space in [F/m]
mu_0_vac::Float32
# Vacuum permeability in [N/A^2] (newtons per ampere squared)


#######################################
# conversion_consts
#######################################

g_per_amu::Float32
# grams per dalton
eV_per_amu::Float32
# electronvolts/c^2 per dalton
J_per_eV::Float32
# Joules per electronvolt
e_coulomb::Float32
# elementary charge in Coulombs
g_per_eV::Float32
# grams per electronvolt/c^2


RELEASE_YEAR::Int32
# release year for posterity
end




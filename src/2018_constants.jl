# AtomicAndPhysicalConstants/src/2018_constants.jl
# Constants pulled from the NIST table of
# the 2018 CODATA release



#####################################################################
# Physical constants
#####################################################################


CODATA2018 = CODATA_release(

#######################################
# constants with dimension [mass]
#######################################


m_electron = 0.51099895069,
# Electron Mass [MeV]/c^2
m_proton = 9.382720894300001e2,
# Proton Mass [MeV]/c^2
m_neutron = 9.395654219399999e2,
# Neutron Mass [MeV]/c^2
m_muon = 1.056583755e2,
# Muon Mass [MeV]/c^2
m_helion = 2.80839161112e3,
# Helion Mass He3 nucleus [MeV]/c^2
m_deuteron = 1.875612945e3,
# Deuteron Mass [MeV]/c^2

# constants mysteriously missing from the release
# picked up from PDG
m_pion_0 = 1.349768277676847e2,
# uncharged pion mass [eV]/c^2
m_pion_charged = 1.3957039098368132e2,
# charged pion mass [eV]/c^2


#######################################
# constants with dimension [magnetic moment]
#######################################


mu_deuteron = 4.330735087e-27,
# deuteron magnetic moment in [J/T]
mu_electron = -9.2847646917e-24,
# electron magnetic moment in [J/T]
mu_helion = -1.07461755198e-26,
# helion magnetic moment in [J/T]
mu_muon = -4.4904483e-26,
# muon magnetic moment in [J/T]
mu_neutron = -9.6623653e-27,
# neutron magnetic moment in [J/T]
mu_proton = 1.41060679545e-26,
# proton magnetic moment in [J/T]
mu_triton = 1.5046095178e-26,
# triton magnetic moment in [J/T]


#######################################
# dimensionless constants
#######################################


N_avogadro = 6.02214076e23,
# Avogadro's constant: Number / mole (exact)
fine_structure = 0.0072973525643,
# fine structure constant

gyro_anom_electron = 1.15965218128e-3,
# electron magnetic moment anomaly
gyro_anom_muon = 1.16592089e-3,
# muon magnetic moment anomaly

gspin_deuteron = 0.857438233,
# deuteron g factor 
gspin_electron = -2.00231930436256,
# electron g factor 
gspin_helion = -4.255250615,
# helion g factor 
gspin_muon = -2.0023318418,
# muon g factor 
gspin_neutron = -3.8260854,
# neutron g factor 
gspin_proton = 5.5856946893,
# proton g factor 
gspin_triton = 5.957924931,
# triton g factor


#######################################
# constants with miscellaneous dimension
#######################################


e_charge = 1.602176634e-19,
# elementary charge [C]
r_e = 2.8179403205e-15,
# classical electron radius [m]
r_p = 2.8179403205e-15 * 0.51099895069 / (9.382720894300001e2), # r_e * m_electron / m_proton,
# classical proton radius [m]
c_light = 2.99792458e8,
# speed of light [m/s]
h_planck = 6.62607015e-34,
# Planck's constant [J*s]
h_bar_planck = 6.62607015e-34 / 2 / pi,
# h_planck/twopi [eV*s]
classical_radius_factor = 2.8179403205e-15 * 0.51099895069, # r_e * m_electron,
# e^2 / (4 pi eps_0)::typeof() = classical_radius * mass * c^2.
# Is same for all particles of charge +/- 1.

eps_0_vac = 8.8541878188e-12,
# Permittivity of free space in [F/m]
mu_0_vac = 1.25663706127e-6,
# Vacuum permeability in [N/A^2] (newtons per ampere squared)


g_per_amu=1.66053906892e-24,
# grams per standard atomic mass unit (dalton)

eV_per_amu=9.3149410372e8,
# eV/c^2 per standard atomic mass unit (dalton)

J_per_eV=1.602176634e-19,
# Joules per eV

e_coulomb=1.602176634e-19,
# elementary charge in coulombs per elementary charge

g_per_eV=1.782661921e-33,
# grams per eV/c^2

RELEASE_YEAR = 2018


)

#---------------------------------------------------------------------------------------------------

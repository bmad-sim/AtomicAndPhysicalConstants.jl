# AtomicAndPhysicalConstants/src/2018_constants.jl
# Constants pulled from the NIST table of
# the 2018 CODATA release



#####################################################################
# Physical constants
#####################################################################


const CODATA2018 = CODATA_release(

#######################################
# constants with dimension [mass]
#######################################


M_ELECTRON = 0.51099895069e6,
# Electron Mass [eV]/c^2
M_PROTON = 9.382720894300001e8,
# Proton Mass [eV]/c^2
M_NEUTRON = 9.395654219399999e8,
# Neutron Mass [eV]/c^2
M_MUON = 1.056583755e8,
# Muon Mass [eV]/c^2
M_HELION = 2.80839161112e9,
# Helion Mass He3 nucleus [eV]/c^2
M_DEUTERON = 1.875612945e9,
# Deuteron Mass [eV]/c^2

# constants mysteriously missing from the release
# picked up from PDG
M_PION_0 = 1.349768277676847e8,
# uncharged pion mass [eV]/c^2
M_PION_CHARGED = 1.3957039098368132e8,
# charged pion mass [eV]/c^2


#######################################
# constants with dimension [magnetic moment]
#######################################


MU_DEUTERON = 4.330735087e-27,
# deuteron magnetic moment in [J/T]
MU_ELECTRON = -9.2847646917e-24,
# electron magnetic moment in [J/T]
MU_HELION = -1.07461755198e-26,
# helion magnetic moment in [J/T]
MU_MUON = -4.4904483e-26,
# muon magnetic moment in [J/T]
MU_NEUTRON = -9.6623653e-27,
# neutron magnetic moment in [J/T]
MU_PROTON = 1.41060679545e-26,
# proton magnetic moment in [J/T]
MU_TRITON = 1.5046095178e-26,
# triton magnetic moment in [J/T]


#######################################
# dimensionless constants
#######################################


AVOGADRO = 6.02214076e23,
# Avogadro's constant: Number / mole (exact)
FINE_STRUCTURE = 0.0072973525643,
# fine structure constant

ANOMALY_ELECTRON = 1.15965218128e-3,
# electron magnetic moment anomaly
ANOMALY_MUON = 1.16592089e-3,
# muon magnetic moment anomaly

G_DEUTERON = 0.857438233,
# deuteron g factor 
G_ELECTRON = -2.00231930436256,
# electron g factor 
G_HELION = -4.255250615,
# helion g factor 
G_MUON = -2.0023318418,
# muon g factor 
G_NEUTRON = -3.8260854,
# neutron g factor 
G_PROTON = 5.5856946893,
# proton g factor 
G_TRITON = 5.957924931,
# triton g factor


#######################################
# constants with miscellaneous dimension
#######################################


E_CHARGE = 1.602176634e-19,
# elementary charge [C]
R_ELECTRON = 2.8179403205e-15,
# classical electron radius [m]
R_PROTON = 2.8179403205e-15 * 0.51099895069 / (9.382720894300001e2), # R_ELECTRON * m_electron / m_proton,
# classical proton radius [m]
C_LIGHT = 2.99792458e8,
# speed of light [m/s]
H_PLANCK = 6.62607015e-34,
# Planck's constant [J*s]
H_BAR = 6.62607015e-34 / 2 / pi,
# h_planck/twopi [eV*s]
CLASSICAL_RADIUS_FACTOR = 2.8179403205e-15 * 0.51099895069, # R_ELECTRON * m_electron,
# e^2 / (4 pi eps_0)::typeof() = classical_radius * mass * c^2.
# Is same for all particles of charge +/- 1.

EPS_0 = 8.8541878188e-12,
# Permittivity of free space in [F/m]
MU_0 = 1.25663706127e-6,
# Vacuum permeability in [N/A^2] (newtons per ampere squared)


G_PER_AMU=1.66053906892e-24,
# grams per standard atomic mass unit (dalton)

EV_PER_AMU=9.3149410372e8,
# eV/c^2 per standard atomic mass unit (dalton)

J_PER_EV=1.602176634e-19,
# Joules per eV

G_PER_EV=1.782661921e-33,
# grams per eV/c^2

RELEASE_YEAR = 2018


)

#---------------------------------------------------------------------------------------------------

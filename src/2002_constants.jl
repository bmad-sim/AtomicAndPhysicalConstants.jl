# AtomicAndPhysicalConstants/src/2002_constants.jl
# Constants pulled from the NIST table of
# the 2002 CODATA release


#####################################################################
# unit conversion constants
#####################################################################


global convert_2022::conversion_consts(

g_per_amu =  1.66053906892e-24,
# grams per standard atomic mass unit (dalton)

eV_per_amu = 9.3149410372e8,
# eV/c^2 per standard atomic mass unit (dalton)

J_per_eV = 1.602176634e-19,
# Joules per eV

e_coulomb = 1.602176634e-19,
# elementary charge in coulombs per elementary charge

eV_per_g = 1.7826618115e-33
# eV/c^2 per gram
)


#####################################################################
# Physical constants
#####################################################################


CODATA2002 = CODATA(

#######################################
# constants with dimension [mass]
#######################################


__b_m_electron::Float64 = 0.51099895069,
# Electron Mass [MeV]/c^2
__b_m_proton = 9.382720894300001e2,
# Proton Mass [MeV]/c^2
__b_m_neutron = 9.395654219399999e2,
# Neutron Mass [MeV]/c^2
__b_m_muon = 1.056583755e2,
# Muon Mass [MeV]/c^2
__b_m_helion = 2.80839161112e3,
# Helion Mass He3 nucleus [MeV]/c^2
__b_m_deuteron = 1.875612945e3,
# Deuteron Mass [MeV]/c^2

# constants mysteriously missing from the release
# picked up from PDG
__b_m_pion_0 = 1.349768277676847e2,
# uncharged pion mass [eV]/c^2
__b_m_pion_charged = 1.3957039098368132e2,
# charged pion mass [eV]/c^2


#######################################
# constants with dimension [magnetic moment]
#######################################

__b_mu_deuteron = 4.330735087e-27,
# deuteron magnetic moment in [J/T]
__b_mu_electron = -9.2847646917e-24,
# electron magnetic moment in [J/T]
__b_mu_helion = -1.07461755198e-26,
# helion magnetic moment in [J/T]
__b_mu_muon = -4.4904483e-26,
# muon magnetic moment in [J/T]
__b_mu_neutron = -9.6623653e-27,
# neutron magnetic moment in [J/T]
__b_mu_proton = 1.41060679545e-26,
# proton magnetic moment in [J/T]
__b_mu_triton = 1.5046095178e-26,
# triton magnetic moment in [J/T]


#######################################
# dimensionless constants
#######################################


__b_N_avogadro = 6.02214076e23,
# Avogadro's constant: Number / mole (exact)
__b_fine_structure = 0.0072973525643,
# fine structure constant


__b_gspin_electron = -2.0023193043718,
# electron g factor 
__b_gspin_muon =  -2.0023318396,
# muon g factor 
__b_gspin_neutron = -3.82608546,
# neutron g factor 
__b_gspin_proton = 5.585694701,
# proton g factor 

# the following dimensionless constants were not included in CODATA2002
__b_gyro_anom_electron = NaN,
__b_gyro_anom_muon = NaN,
__b_gspin_deuteron = NaN,
__b_gspin_helion = NaN,
__b_gspin_triton = NaN,


#######################################
# constants with miscellaneous dimension
#######################################


__b_e_charge = 1.602176634e-19,
# elementary charge [C]
__b_r_e = 2.8179403205e-15,
# classical electron radius [m]
__b_r_p = 2.8179403205e-15 * 0.51099895069 / (9.382720894300001e2), #__b_r_e * __b_m_electron / __b_m_proton,
# classical proton radius [m]
__b_c_light = 2.99792458e8,
# speed of light [m/s]
__b_h_planck = 6.62607015e-34,
# Planck's constant [J*s]
__b_h_bar_planck = 6.62607015e-34 / 2 / pi,
# h_planck/twopi [eV*s]
__b_classical_radius_factor = 2.8179403205e-15 * 0.51099895069, # __b_r_e * __b_m_electron,
# e^2 / (4 pi eps_0)::typeof() = classical_radius * mass * c^2.
# Is same for all particles of charge +/- 1.

__b_eps_0_vac= 8.8541878188e-12,
# Permittivity of free space in [F/m]
__b_mu_0_vac = 1.25663706127e-6,
# Vacuum permeability in [N/A^2] (newtons per ampere squared)

__b_RELEASE_YEAR = 2002


)

#---------------------------------------------------------------------------------------------------

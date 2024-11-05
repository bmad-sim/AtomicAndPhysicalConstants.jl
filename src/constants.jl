	# AtomicAndPhysicalConstants/src/2022_constants.jl
	# Constants pulled from the NIST table of
	# the 2022 CODATA release



#####################################################################
# constants with dimensions of mass, expressed in MeV/c^2
#####################################################################

const __b_m_electron = 0.51099895069 * u"MeV/c^2"
                             # Electron Mass [MeV]/c^2
const __b_m_proton = 9.382720894300001e2 * u"MeV/c^2"
                             # Proton Mass [MeV]/c^2
const __b_m_neutron = 9.395654219399999e2 * u"MeV/c^2"
                             # Neutron Mass [MeV]/c^2
const __b_m_muon = 1.056583755e2 * u"MeV/c^2"
                             # Muon Mass [MeV]/c^2
const __b_m_helion = 2.80839161112e3 * u"MeV/c^2"
                             # Helion Mass He3 nucleus [MeV]/c^2
const __b_m_deuteron = 1.875612945e3 * u"MeV/c^2"
                             # Deuteron Mass [MeV]/c^2
  # constants mysteriously missing from the release
                             # picked up from PDG
const __b_m_pion_0 = 1.349768277676847e2 * u"MeV/c^2"
														 # uncharged pion mass [MeV]/c^2
const __b_m_pion_charged = 1.3957039098368132e2 * u"MeV/c^2"
														 # charged pion mass [MeV]/c^2



#####################################################################
# constants with dimensions of magnetic moment, expressed in J/T
#####################################################################

const __b_mu_deuteron = 6.9386025644353565e-46 * u"J/T"
                             # deuteron magnetic moment in [J/T]
const __b_mu_electron = -9.2847646917e-24 * u"J/T"
                             # electron magnetic moment in [J/T]
const __b_mu_helion = -1.07461755198e-26 * u"J/T"
                             # helion magnetic moment in [J/T]
const __b_mu_muon = -4.4904483e-26 * u"J/T"
                             # muon magnetic moment in [J/T]
const __b_mu_neutron = -9.6623653e-27 * u"J/T"
                             # neutron magnetic moment in [J/T]
const __b_mu_proton = 1.41060679545e-26 * u"J/T"
                             # proton magnetic moment in [J/T]
const __b_mu_triton = 1.5046095178e-26 * u"J/T"
                             # triton magnetic moment in [J/T]




#####################################################################
# constants of miscellaneous dimension
#####################################################################

const __b_r_e = 2.8179403205e-15 * u"m"
                             # classical electron radius [m]
const __b_c_light = 2.99792458e8 * u"m/s"
                             # speed of light [m/s]
const __b_h_planck = 4.135667696e-15 * u"eV/Hz"
                             # Planck's constant [eV*s]
const __b_eps_0_vac = 8.8541878188e-12 * u"F/m"
                             # Permittivity of free space in [F/m]
const __b_mu_0_vac = 1.25663706127e-6 * u"N/A^2"
                             # Vacuum permeability in [N/A^2] (newtons per ampere squared)








#####################################################################
# constants to convert between units of like dimension
#####################################################################


const __b_kg_per_amu = 1.66053906892e-27 * u"kg/amu"
                             # kg per standard atomic mass unit (dalton)
const __b_eV_per_amu = 9.3149410372e8 * u"(eV/c^2)/amu"
                             # eV per standard atomic mass unit (dalton)
const __b_J_per_eV = 1.602176634e-19 * u"J/eV"
                             # Joules per eV
const __b_e_charge = 1.602176634e-19 * u"C"
                             # elementary charge [C]




#####################################################################
# unitless constants
#####################################################################

const __b_N_avogadro = 6.02214076e23
                             # Avogadro's constant: Number / mole (exact)
const __b_fine_structure = 0.0072973525643
                             # fine structure constant


#####################################################################
# values calculated from other constants in this collection
#####################################################################

const __b_classical_radius_factor = __b_r_e * __b_m_electron;
                             # e^2 / (4 pi eps_0) = classical_radius * mass * c^2.
                             # Is same for all particles of charge +/- 1.
const __b_r_p = __b_r_e * __b_m_electron / __b_m_proton;
                             # proton radius [m]
const __b_h_bar_planck = __b_h_planck / 2pi;
                             # h_planck/twopi [eV*s]



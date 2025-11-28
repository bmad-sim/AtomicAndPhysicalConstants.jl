# AtomicAndPhysicalConstants/src/defaults.jl

#######################################
# constants with dimension [mass]
#######################################

const m_electron = Ref(0.51099895069e6)
# Electron Mass [eV]/c^2
const m_proton = Ref(9.382720894300001e8)
# Proton Mass [eV]/c^2
const m_neutron = Ref(9.395654219399999e8)
# Neutron Mass [eV]/c^2
const m_muon = Ref(1.056583755e8)
# Muon Mass [eV]/c^2
const m_helion = Ref(2.80839161112e9)
# Helion Mass He3 nucleus [eV]/c^2
const m_deuteron = Ref(1.875612945e9)
# Deuteron Mass [MeV]/c^2

# constants mysteriously missing from the release
# picked up from PDG
const m_pion_0 = Ref(1.349768277676847e8)
# uncharged pion mass [eV]/c^2
const m_pion_charged = Ref(1.3957039098368132e8)
# charged pion mass [eV]/c^2


#######################################
# constants with dimension [magnetic moment]
#######################################


const mu_deuteron = Ref(4.330735087e-27)
# deuteron magnetic moment in [J/T]
const mu_electron = Ref(-9.2847646917e-24)
# electron magnetic moment in [J/T]
const mu_helion = Ref(-1.07461755198e-26)
# helion magnetic moment in [J/T],
const mu_muon = Ref(-4.4904483e-26)
# muon magnetic moment in [J/T]
const mu_neutron = Ref(-9.6623653e-27)
# neutron magnetic moment in [J/T]
const mu_proton = Ref(1.41060679545e-26)
# proton magnetic moment in [J/T]
const mu_triton = Ref(1.5046095178e-26)
# triton magnetic moment in [J/T]


#######################################
# dimensionless constants
#######################################


const N_avogadro = Ref(6.02214076e23)
# Avogadro's constant: Number / mole (exact)
const fine_structure = Ref(0.0072973525643)
# fine structure constant

const gyro_anom_electron = Ref(1.15965218046e-3)
# electron magnetic moment anomaly
const gyro_anom_muon = Ref(1.16592062e-3)
# muon magnetic moment anomaly

const gspin_deuteron = Ref(0.8574382335)
# deuteron g factor 
const gspin_electron = Ref(-2.00231930436092)
# electron g factor 
const gspin_helion = Ref(-4.2552506995)
# helion g factor 
const gspin_muon = Ref(-2.00233184123)
# muon g factor 
const gspin_neutron = Ref(-3.82608552)
# neutron g factor 
const gspin_proton = Ref(5.5856946893)
# proton g factor 
const gspin_triton = Ref(5.957924930)
# triton g factor


#######################################
# constants with miscellaneous dimension
#######################################


const e_charge = Ref(1.602176634e-19)
# elementary charge [C]
const r_e = Ref(2.8179403205e-15)
# classical electron radius [m],
const r_p = Ref(2.8179403205e-15 * 0.51099895069 / 9.382720894300001e2) #r_e * m_electron / m_proton,
# classical proton radius [m]
const c_light = Ref(2.99792458e8)
# speed of light [m/s]
const h_planck = Ref(6.62607015e-34)
# Planck's constant [J*s]
const h_bar_planck = Ref(6.62607015e-34 / 2 / pi)
# h_planck/twopi [eV*s]
const classical_radius_factor = Ref(2.8179403205e-15 * 0.51099895069) # r_e * m_electron,
# e^2 / (4 pi eps_0) = classical_radius * mass * c^2.
# Is same for all particles of charge +/- 1.

const eps_0_vac = Ref(8.8541878188e-12)
# Permittivity of free space in [F/m]
const mu_0_vac = Ref(1.25663706127e-6)
# Vacuum permeability in [N/A^2] (newtons per ampere squared)

const RELEASE_YEAR = Ref(2022)

# AtomicAndPhysicalConstants/src/defaults.jl
const release = @load_preference("release", "2022")
#######################################
# constants with dimension [mass]
#######################################

const M_ELECTRON::Float64 = get(CODATA_MAP, release, CODATA2022).M_ELECTRON
# Electron Mass [eV]/c^2
const M_PROTON::Float64 = get(CODATA_MAP, release, CODATA2022).M_PROTON
# Proton Mass [eV]/c^2
const M_NEUTRON::Float64 = get(CODATA_MAP, release, CODATA2022).M_NEUTRON
# Neutron Mass [eV]/c^2
const M_MUON::Float64 = get(CODATA_MAP, release, CODATA2022).M_MUON
# Muon Mass [eV]/c^2
const M_HELION::Float64 = get(CODATA_MAP, release, CODATA2022).M_HELION
# Helion Mass He3 nucleus [eV]/c^2
const M_DEUTERON::Float64 = get(CODATA_MAP, release, CODATA2022).M_DEUTERON
# Deuteron Mass [MeV]/c^2

# constants mysteriously missing from the release
# picked up from PDG
const M_PION_0::Float64 = get(CODATA_MAP, release, CODATA2022).M_PION_0
# uncharged pion mass [eV]/c^2
const M_PION_CHARGED::Float64 = get(CODATA_MAP, release, CODATA2022).M_PION_CHARGED
# charged pion mass [eV]/c^2


#######################################
# constants with dimension [magnetic moment]
#######################################


const MU_DEUTERON::Float64 = get(CODATA_MAP, release, CODATA2022).MU_DEUTERON
# deuteron magnetic moment in [J/T]
const MU_ELECTRON::Float64 = get(CODATA_MAP, release, CODATA2022).MU_ELECTRON
# electron magnetic moment in [J/T]
const MU_HELION::Float64 = get(CODATA_MAP, release, CODATA2022).MU_HELION
# helion magnetic moment in [J/T],
const MU_MUON::Float64 = get(CODATA_MAP, release, CODATA2022).MU_MUON
# muon magnetic moment in [J/T]
const MU_NEUTRON::Float64 = get(CODATA_MAP, release, CODATA2022).MU_NEUTRON
# neutron magnetic moment in [J/T]
const MU_PROTON::Float64 = get(CODATA_MAP, release, CODATA2022).MU_PROTON
# proton magnetic moment in [J/T]
const MU_TRITON::Float64 = get(CODATA_MAP, release, CODATA2022).MU_TRITON
# triton magnetic moment in [J/T]


#######################################
# dimensionless constants
#######################################


const AVOGADRO::Float64 = get(CODATA_MAP, release, CODATA2022).AVOGADRO
# Avogadro's constant: Number / mole (exact)
const FINE_STRUCTURE::Float64 = get(CODATA_MAP, release, CODATA2022).FINE_STRUCTURE
# fine structure constant

const ANOMALY_ELECTRON::Float64 = get(CODATA_MAP, release, CODATA2022).ANOMALY_ELECTRON
# electron magnetic moment anomaly
const ANOMALY_MUON::Float64 = get(CODATA_MAP, release, CODATA2022).ANOMALY_MUON
# muon magnetic moment anomaly

const G_DEUTERON::Float64 = get(CODATA_MAP, release, CODATA2022).G_DEUTERON
# deuteron g factor 
const G_ELECTRON::Float64 = get(CODATA_MAP, release, CODATA2022).G_ELECTRON
# electron g factor 
const G_HELION::Float64 = get(CODATA_MAP, release, CODATA2022).G_HELION
# helion g factor 
const G_MUON::Float64 = get(CODATA_MAP, release, CODATA2022).G_MUON
# muon g factor 
const G_NEUTRON::Float64 = get(CODATA_MAP, release, CODATA2022).G_NEUTRON
# neutron g factor 
const G_PROTON::Float64 = get(CODATA_MAP, release, CODATA2022).G_PROTON
# proton g factor 
const G_TRITON::Float64 = get(CODATA_MAP, release, CODATA2022).G_TRITON
# triton g factor


#######################################
# constants with miscellaneous dimension
#######################################


const E_CHARGE::Float64 = get(CODATA_MAP, release, CODATA2022).E_CHARGE
# elementary charge [C]
const R_ELECTRON::Float64 = get(CODATA_MAP, release, CODATA2022).R_ELECTRON
# classical electron radius [m],
const R_PROTON::Float64 = get(CODATA_MAP, release, CODATA2022).R_PROTON #R_ELECTRON * m_electron / m_proton,
# classical proton radius [m]
const C_LIGHT::Float64 = get(CODATA_MAP, release, CODATA2022).C_LIGHT
# speed of light [m/s]
const H_PLANCK::Float64 = get(CODATA_MAP, release, CODATA2022).H_PLANCK
# Planck's constant [J*s]
const H_BAR::Float64 = get(CODATA_MAP, release, CODATA2022).H_BAR
# h_planck/twopi [eV*s]
const CLASSICAL_RADIUS_FACTOR::Float64 = get(CODATA_MAP, release, CODATA2022).CLASSICAL_RADIUS_FACTOR # R_ELECTRON * m_electron,
# e^2 / (4 pi eps_0)::Float64 = classical_radius * mass * c^2.
# Is same for all particles of charge +/- 1.

const EPS_0::Float64 = get(CODATA_MAP, release, CODATA2022).EPS_0
# Permittivity of free space in [F/m]
const MU_0::Float64 = get(CODATA_MAP, release, CODATA2022).MU_0
# Vacuum permeability in [N/A^2] (newtons per ampere squared)

const G_PER_AMU::Float64 = get(CODATA_MAP, release, CODATA2022).G_PER_AMU
# grams per standard atomic mass unit (dalton)

const EV_PER_AMU::Float64 = get(CODATA_MAP, release, CODATA2022).EV_PER_AMU
# eV/c^2 per standard atomic mass unit (dalton)

const J_PER_EV::Float64 = get(CODATA_MAP, release, CODATA2022).J_PER_EV
# Joules per eV

const G_PER_EV::Float64 = get(CODATA_MAP, release, CODATA2022).G_PER_EV
# grams per eV/c^2

const RELEASE_YEAR::Int = get(CODATA_MAP, release, CODATA2022).RELEASE_YEAR

# kg per MeV/c²
const KG_PER_MEV_C2::Float64 = G_PER_EV * 1e-3

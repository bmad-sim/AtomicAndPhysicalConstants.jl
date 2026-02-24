# AtomicAndPhysicalConstants/src/defaults.jl
"""
release::String - The release year of the currently selected CODATA values.
"""
const release::String = @load_preference("release", "2022")
#######################################
# constants with dimension [mass]
#######################################

"""
M_ELECTRON::Float32 - Mass of the electron in eV/c^2 from the selected CODATA release.
"""
const M_ELECTRON::Float32 = get(CODATA_MAP, release, CODATA2022).M_ELECTRON

"""
M_PROTON::Float32 - Mass of the proton in eV/c^2 from the selected CODATA release.
"""
const M_PROTON::Float32 = get(CODATA_MAP, release, CODATA2022).M_PROTON

"""
M_NEUTRON::Float32 - Mass of the neutron in eV/c^2 from the selected CODATA release.
"""
const M_NEUTRON::Float32 = get(CODATA_MAP, release, CODATA2022).M_NEUTRON

"""
M_MUON::Float32 - Mass of the muon in eV/c^2 from the selected CODATA release.
"""
const M_MUON::Float32 = get(CODATA_MAP, release, CODATA2022).M_MUON
# Muon Mass [eV]/c^2
"""
M_HELION::Float32 - Mass of the helion in eV/c^2 from the selected CODATA release.
"""
const M_HELION::Float32 = get(CODATA_MAP, release, CODATA2022).M_HELION
# Helion Mass He3 nucleus [eV]/c^2
"""
M_DEUTERON::Float32 - Mass of the deuteron in eV/c^2 from the selected CODATA release.
"""
const M_DEUTERON::Float32 = get(CODATA_MAP, release, CODATA2022).M_DEUTERON
# Deuteron Mass [MeV]/c^2

# constants mysteriously missing from the release
# picked up from PDG
"""
M_PION_0::Float32 - Mass of the neutral pion in eV/c^2 scraped from the particle data group.
"""
const M_PION_0::Float32 = get(CODATA_MAP, release, CODATA2022).M_PION_0
# uncharged pion mass [eV]/c^2
"""
M_PION_CHARGED::Float32 - Mass of a charged pion in eV/c^2 scraped from the particle data group.
"""
const M_PION_CHARGED::Float32 = get(CODATA_MAP, release, CODATA2022).M_PION_CHARGED
# charged pion mass [eV]/c^2


#######################################
"""
EV_PER_J::Float32 - eV per Joule in the selected CODATA release.
"""
const EV_PER_J::Float32 = get(CODATA_MAP, release, CODATA2022).EV_PER_J
# Joules per eV

# constants with dimension [magnetic moment]
#######################################


"""
MU_DEUTERON::Float32 - Magnetic moment of the deuteron in eV/T (converted) from the selected CODATA release.
"""
const MU_DEUTERON::Float32 = EV_PER_J*get(CODATA_MAP, release, CODATA2022).MU_DEUTERON
# deuteron magnetic moment in [J/T]
"""
MU_ELECTRON::Float32 - Magnetic moment of the electron in eV/T (converted) from the selected CODATA release.
"""
const MU_ELECTRON::Float32 = EV_PER_J*get(CODATA_MAP, release, CODATA2022).MU_ELECTRON
# electron magnetic moment in [J/T]
"""
MU_HELION::Float32 - Magnetic moment of the helion in eV/T (converted) from the selected CODATA release.
"""
const MU_HELION::Float32 = EV_PER_J*get(CODATA_MAP, release, CODATA2022).MU_HELION
# helion magnetic moment in [J/T],
"""
MU_MUON::Float32 - Magnetic moment of the muon in eV/T (converted) from the selected CODATA release.
"""
const MU_MUON::Float32 = EV_PER_J*get(CODATA_MAP, release, CODATA2022).MU_MUON
# muon magnetic moment in [J/T]
"""
MU_NEUTRON::Float32 - Magnetic moment of the neutron in eV/T (converted) from the selected CODATA release.
"""
const MU_NEUTRON::Float32 = EV_PER_J*get(CODATA_MAP, release, CODATA2022).MU_NEUTRON
# neutron magnetic moment in [J/T]
"""
MU_PROTON::Float32 - Magnetic moment of the proton in eV/T (converted) from the selected CODATA release.
"""
const MU_PROTON::Float32 = EV_PER_J*get(CODATA_MAP, release, CODATA2022).MU_PROTON
# proton magnetic moment in [J/T]
"""
MU_TRITON::Float32 - Magnetic moment of the triton in eV/T (converted) from the selected CODATA release.
"""
const MU_TRITON::Float32 = EV_PER_J*get(CODATA_MAP, release, CODATA2022).MU_TRITON
# triton magnetic moment in [J/T]


#######################################
# dimensionless constants
#######################################


"""
AVOGADRO::Float32 - Avogadro's constant number/mol (exact)
"""
const AVOGADRO::Float32 = get(CODATA_MAP, release, CODATA2022).AVOGADRO
# Avogadro's constant: Number / mole (exact)
"""
FINE_STRUCTURE::Float32 - Finse structure constant from the selected CODATA release.
"""
const FINE_STRUCTURE::Float32 = get(CODATA_MAP, release, CODATA2022).FINE_STRUCTURE
# fine structure constant

"""
ANOMALY_ELECTRON::Float32 - The electron gyromagnetic anomaly per the selected CODATA release.
"""
const ANOMALY_ELECTRON::Float32 = get(CODATA_MAP, release, CODATA2022).ANOMALY_ELECTRON
# electron magnetic moment anomaly
"""
ANOMALY_MUON::Float32 - The muon gyromagnetic anomaly per the selected CODATA release.
"""
const ANOMALY_MUON::Float32 = get(CODATA_MAP, release, CODATA2022).ANOMALY_MUON
# muon magnetic moment anomaly

"""
G_DEUTERON::Float32 - The deuteron spin g-factor per the selected CODATA release.
"""
const G_DEUTERON::Float32 = get(CODATA_MAP, release, CODATA2022).G_DEUTERON
# deuteron g factor 
"""
G_ELECTRON::Float32 - The electron spin g-factor per the selected CODATA release.
"""
const G_ELECTRON::Float32 = get(CODATA_MAP, release, CODATA2022).G_ELECTRON
# electron g factor 
"""
G_HELION::Float32 - The helion spin g-factor per the selected CODATA release.
"""
const G_HELION::Float32 = get(CODATA_MAP, release, CODATA2022).G_HELION
# helion g factor 
"""
G_MUON::Float32 - The muon spin g-factor per the selected CODATA release.
"""
const G_MUON::Float32 = get(CODATA_MAP, release, CODATA2022).G_MUON
# muon g factor 
"""
G_NEUTRON::Float32 - The neutron spin g-factor per the selected CODATA release.
"""
const G_NEUTRON::Float32 = get(CODATA_MAP, release, CODATA2022).G_NEUTRON
# neutron g factor 
"""
G_PROTON::Float32 - The proton spin g-factor per the selected CODATA release.
"""
const G_PROTON::Float32 = get(CODATA_MAP, release, CODATA2022).G_PROTON
# proton g factor 
"""
G_TRITON::Float32 - The triton spin g-factor per the selected CODATA release.
"""
const G_TRITON::Float32 = get(CODATA_MAP, release, CODATA2022).G_TRITON
# triton g factor


#######################################
# constants with miscellaneous dimension
#######################################


"""
E_CHARGE::Float32 - magnitude of charge on the electron in C per the selected CODATA release.
"""
const E_CHARGE::Float32 = get(CODATA_MAP, release, CODATA2022).E_CHARGE
# elementary charge [C]
"""
R_ELECTRON::Float32 - Classical electron radius in m per the selected CODATA release.
"""
const R_ELECTRON::Float32 = get(CODATA_MAP, release, CODATA2022).R_ELECTRON
# classical electron radius [m],
"""
R_PROTON::Float32 - Classical proton radius in m per the selected CODATA release.
"""
const R_PROTON::Float32 = get(CODATA_MAP, release, CODATA2022).R_PROTON #R_ELECTRON * m_electron / m_proton,
# classical proton radius [m]
"""
C_LIGHT::Float32 - Speed of light in m/s per the selected CODATA release.
"""
const C_LIGHT::Float32 = get(CODATA_MAP, release, CODATA2022).C_LIGHT
# speed of light [m/s]
"""
H_PLANCK::Float32 - Planck's constant (h) in eV*s per the selected CODATA release.
"""
const H_PLANCK::Float32 = get(CODATA_MAP, release, CODATA2022).H_PLANCK
# Planck's constant [J*s]
"""
H_BAR::Float32 - Planck's reduced constant (ħ) in eV*s per the selected CODATA release.
"""
const H_BAR::Float32 = get(CODATA_MAP, release, CODATA2022).H_BAR
# h_planck/twopi [eV*s]
"""
CLASSICAL_RADIUS_FACTOR::Float32 - Classical radius factor per the selected CODATA release.
"""
const CLASSICAL_RADIUS_FACTOR::Float32 = get(CODATA_MAP, release, CODATA2022).CLASSICAL_RADIUS_FACTOR # R_ELECTRON * m_electron,
# e^2 / (4 pi eps_0)::Float32 = classical_radius * mass * c^2.
# Is same for all particles of charge +/- 1.

"""
EPS_0::Float32 - Permittivity of free space in F/m per the selected CODATA release.
"""
const EPS_0::Float32 = get(CODATA_MAP, release, CODATA2022).EPS_0
# Permittivity of free space in [F/m]
"""
MU_0::Float32 - Vacuum permeability in N/A^2 per the selected CODATA release.
"""
const MU_0::Float32 = get(CODATA_MAP, release, CODATA2022).MU_0
# Vacuum permeability in [N/A^2] (newtons per ampere squared)

"""
KG_PER_AMU::Float32 - Kilograms per Dalton conversion in the selected CODATA release.
"""
const KG_PER_AMU::Float32 = get(CODATA_MAP, release, CODATA2022).G_PER_AMU * 1e-3
# grams per standard atomic mass unit (dalton)

"""
EV_PER_AMU::Float32 - eV/c^2 per Dalton conversion in the selected CODATA release.
"""
const EV_PER_AMU::Float32 = get(CODATA_MAP, release, CODATA2022).EV_PER_AMU
# eV/c^2 per standard atomic mass unit (dalton)

"""
J_PER_EV::Float32 - Joules per eV in the selected CODATA release.
"""
const J_PER_EV::Float32 = get(CODATA_MAP, release, CODATA2022).J_PER_EV
# Joules per eV

"""
G_PER_EV::Float32 - Grams per eV/c^2 in the selected CODATA release.
"""
const G_PER_EV::Float32 = get(CODATA_MAP, release, CODATA2022).G_PER_EV
# grams per eV/c^2

"""
RELEASE_YEAR::Int - The release year of the currently selected CODATA values.
"""
const RELEASE_YEAR::Int = get(CODATA_MAP, release, CODATA2022).RELEASE_YEAR

# kg per MeV/c²
"""
KG_PER_MEV_C2::Float32 - Kilograms per MeV/c^2
"""
const KG_PER_MEV_C2::Float32 = G_PER_EV * 1e-3

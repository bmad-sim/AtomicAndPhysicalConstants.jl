"""
Physical constants from CODATA 2022

All constants are stored as plain Float64.
"""

# Release year
const RELEASE_YEAR = 2022

#####################################################################
#  Mass constants
#####################################################################

# Electron mass [eV/c²]
const M_ELECTRON = 0.51099895069e6

# Proton mass [eV/c²]
const M_PROTON = 938.2720894300001e6

# Neutron mass [eV/c²]
const M_NEUTRON = 939.5654219399999e6

# Muon mass [eV/c²]
const M_MUON = 105.6583755e6

# Pion⁰ mass [eV/c²]
const M_PION_0 = 134.9768277676847e6

# Charged pion mass [eV/c²]
const M_PION_CHARGED = 139.57039098368132e6

# Deuteron mass [eV/c²]
const M_DEUTERON = 1875.612945e6

# Helion mass (³He nucleus) [eV/c²]
const M_HELION = 2808.39161112e6


#####################################################################
#  Magnetic moment constants
#####################################################################
# Electron magnetic moment [J/T]
const MU_ELECTRON = -9.2847646917e-24

# Proton magnetic moment [J/T]
const MU_PROTON = 1.41060679545e-26

# Neutron magnetic moment [J/T]
const MU_NEUTRON = -9.6623653e-27

# Muon magnetic moment [J/T]
const MU_MUON = -4.4904483e-26

# Deuteron magnetic moment [J/T]
const MU_DEUTERON = 4.330735087e-27

# Helion magnetic moment [J/T]
const MU_HELION = -1.07461755198e-26

# Triton magnetic moment [J/T]
const MU_TRITON = 1.5046095178e-26

#####################################################################
#  g-factor constants
#####################################################################

# Electron magnetic moment anomaly
const ANOMALY_ELECTRON = 1.15965218046e-3

# Muon magnetic moment anomaly
const ANOMALY_MUON = 1.16592062e-3

# Electron g-factor
const G_ELECTRON = -2.00231930436092

# Proton g-factor
const G_PROTON = 5.5856946893

# Neutron g-factor
const G_NEUTRON = -3.82608552

# Muon g-factor
const G_MUON = -2.00233184123

# Deuteron g-factor
const G_DEUTERON = 0.8574382335

# Helion g-factor
const G_HELION = -4.2552506995

# Triton g-factor
const G_TRITON = 5.957924930

#####################################################################
#  Fundamental constants
#####################################################################

# Speed of light in vacuum [m/s]
const C_LIGHT = 2.99792458e8

# Planck constant [J⋅s]
const H_PLANCK = 6.62607015e-34

# Reduced Planck constant [J⋅s]
const H_BAR = H_PLANCK / (2π)

# Elementary charge [C]
const E_CHARGE = 1.602176634e-19

# Fine structure constant (dimensionless)
const FINE_STRUCTURE = 0.0072973525643

# Avogadro constant [mol⁻¹]
const AVOGADRO = 6.02214076e23

# Classical electron radius [m]
const R_ELECTRON = 2.8179403205e-15

# Classical proton radius [m]
const R_PROTON = R_ELECTRON * M_ELECTRON / M_PROTON

# Permittivity of free space [F/m]
const EPS_0 = 8.8541878128e-12

# Permeability of free space [N/A²]
const MU_0 = 1.25663706212e-6

#####################################################################
#  Unit conversions
#####################################################################

# kg per atomic mass unit
const KG_PER_AMU = 1.66053906892e-27

# eV per atomic mass unit
const EV_PER_AMU = 931.49410242e6

# Joules per eV
const J_PER_EV = 1.602176634e-19

# kg per MeV/c²
const KG_PER_MEV_C2 = EV_PER_AMU * KG_PER_AMU / (1e6 * C_LIGHT^2)
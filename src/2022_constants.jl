# AtomicAndPhysicalConstants/src/2022_constants.jl
# Constants pulled from the NIST table of
# the 2022 CODATA release






#####################################################################
# constants with dimension [mass]
#####################################################################


__b_m_electron::typeof(1.0*u"MeV/c^2") = 0.51099895069 * u"MeV/c^2"
# Electron Mass [MeV]/c^2
__b_m_proton::typeof(1.0*u"MeV/c^2") = 9.382720894300001e2 * u"MeV/c^2"
# Proton Mass [MeV]/c^2
__b_m_neutron::typeof(1.0*u"MeV/c^2") = 9.395654219399999e2 * u"MeV/c^2"
# Neutron Mass [MeV]/c^2
__b_m_muon::typeof(1.0*u"MeV/c^2") = 1.056583755e2 * u"MeV/c^2"
# Muon Mass [MeV]/c^2
__b_m_helion::typeof(1.0*u"MeV/c^2") = 2.80839161112e3 * u"MeV/c^2"
# Helion Mass He3 nucleus [MeV]/c^2
__b_m_deuteron::typeof(1.0*u"MeV/c^2") = 1.875612945e3 * u"MeV/c^2"
# Deuteron Mass [MeV]/c^2


# constants mysteriously missing from the release
# picked up from PDG
__b_m_pion_0::typeof(1.0*u"MeV/c^2") = 1.349768277676847e2 * u"MeV/c^2"
# uncharged pion mass [eV]/c^2
__b_m_pion_charged::typeof(1.0*u"MeV/c^2") = 1.3957039098368132e2 * u"MeV/c^2"
# charged pion mass [eV]/c^2








#####################################################################
# constants with dimension [magnetic moment]
#####################################################################


__b_mu_deuteron::typeof(1.0*u"J/T") = 4.330735087e-27 * u"J/T"
# deuteron magnetic moment in [J/T]
__b_mu_electron::typeof(1.0*u"J/T") = -9.2847646917e-24 * u"J/T"
# electron magnetic moment in [J/T]
__b_mu_helion::typeof(1.0*u"J/T") = -1.07461755198e-26 * u"J/T"
# helion magnetic moment in [J/T]
__b_mu_muon::typeof(1.0*u"J/T") = -4.4904483e-26 * u"J/T"
# muon magnetic moment in [J/T]
__b_mu_neutron::typeof(1.0*u"J/T") = -9.6623653e-27 * u"J/T"
# neutron magnetic moment in [J/T]
__b_mu_proton::typeof(1.0*u"J/T") = 1.41060679545e-26 * u"J/T"
# proton magnetic moment in [J/T]
__b_mu_triton::typeof(1.0*u"J/T")= 1.5046095178e-26 * u"J/T"
# triton magnetic moment in [J/T]






#####################################################################
# dimensionless constants
#####################################################################


__b_N_avogadro::Float64 = 6.02214076e23;
# Avogadro's constant: Number / mole (exact)
__b_fine_structure::Float64 = 0.0072973525643;
# fine structure constant






#####################################################################
# unit conversion constants
#####################################################################


__b_kg_per_amu::typeof(1.0*u"kg/amu") = 1.66053906892e-27 * u"kg/amu";
# kg per standard atomic mass unit (dalton)
__b_eV_per_amu::typeof(1.0*u"(eV/c^2)/amu") = 9.3149410372e8 * u"(eV/c^2)/amu";
# eV per standard atomic mass unit (dalton)
__b_J_per_eV::typeof(1.0*u"J/eV") = 1.602176634e-19 * u"J/eV";
# Joules per eV






#####################################################################
# constants with miscelaneous dimension
#####################################################################


__b_e_charge::typeof(1.0*u"C") = 1.602176634e-19 * u"C";
# elementary charge [C]
__b_r_e::typeof(1.0*u"m") = 2.8179403205e-15 * u"m";
# classical electron radius [m]
__b_r_p::typeof(1.0*u"m") = __b_r_e * __b_m_electron / __b_m_proton ;
# classical proton radius [m]
__b_c_light::typeof(1.0*u"m/s") = 2.99792458e8 * u"m/s";
# speed of light [m/s]
__b_h_planck::typeof(1.0*u"eV*s") = 4.135667696e-15 * u"eV*s";
# Planck's constant [eV*s]
__b_h_bar_planck::typeof(1.0*u"eV*s") = __b_h_planck / 2pi;
# h_planck/twopi [eV*s]
__b_classical_radius_factor::typeof(1.0*u"m * MeV/c^2") = __b_r_e * __b_m_electron;
# e^2 / (4 pi eps_0) = classical_radius * mass * c^2.
# Is same for all particles of charge +/- 1.


__b_eps_0_vac::typeof(1.0*u"F/m") = 8.8541878188e-12 * u"F/m";
# Permittivity of free space in [F/m]
__b_mu_0_vac::typeof(1.0*u"N/A^2") = 1.25663706127e-6 * u"N/A^2";
# Vacuum permeability in [N/A^2] (newtons per ampere squared)






























































#---------------------------------------------------------------------------------------------------

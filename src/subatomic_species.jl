
"""
SubtomicSpecies 

### Description:
> mutable struct to store all (possibly degenerate) information about a subatomic particle<

### Fields:
- `species_name`      -- String common name for (anti) baryon
- `charge`            -- electric charge on the given particle in units of [e+]
- `mass_in_eV`              -- mass of the given particle in [eV/c^2]
- `mu`  							-- magnetic moment of particle in [eV/T]
- `spin`              -- spin of the particle in [ħ]

### Notes:
some parameters in this struct are likely named constants from PhysicalConstants.jl

### Examples:
- `SubatomicSpecies("neutron", 0, m_neutron, anom_mag_moment_neutron, 0.5)`
- `SubatomicSpecies("pion-", -1, m_pion_charged, 0.0, 0.0)`
"""
SubatomicSpecies

struct SubatomicSpecies
  species_name::String              # common species_name of the particle
  charge::typeof(1u"q")                     # charge on the particle in units of e+
  mass::typeof(1.0*u"MeV/c^2")                   # mass of the particle in [eV/c^2]
  mu::typeof(1.0u"J/T")        # anomalous magnetic moment 
  spin::typeof(1.0u"ħ")                     # spin magnetic moment in [ħ]
end;


# -----------------------------------------------------------------------------------------------
#=
Below we have a dictionary, SUBATOMIC_SPECIES :
this contatins key=>value pairs of  subatomic-name => SubatomicSpecies
=#



"""
    SUBATOMIC_SPECIES 
a dictionary of all the available subatomic species; 
the key is the particle's species_name, 
and the value is the relevant SubatomicSpecies struct, _eg_ 

Subatomic_Particles["some-particle"] = SubatomicSpecies("some-particle", ...)
"""

const SUBATOMIC_SPECIES = Dict{String,SubatomicSpecies}(
  "pion0" => SubatomicSpecies("pion0", 0*u"q", __b_m_pion_0, 0.0*u"J/T", 0.0*u"ħ"),
  "neutron" => SubatomicSpecies("neutron", 0*u"q", __b_m_neutron, __b_mu_neutron, 0.5*u"ħ"),
  "deuteron" => SubatomicSpecies("deuteron", 1*u"q", __b_m_deuteron, __b_mu_deuteron, 1.0*u"ħ"),
  "pion+" => SubatomicSpecies("pion+", 1*u"q", __b_m_pion_charged, 0.0*u"J/T", 0.0*u"ħ"),
  "anti-muon" => SubatomicSpecies("anti-muon", 1*u"q", __b_m_muon, __b_mu_muon, 0.5*u"ħ"),
  "proton" => SubatomicSpecies("proton", 1*u"q", __b_m_proton, __b_mu_proton, 0.5*u"ħ"),
  "positron" => SubatomicSpecies("positron", 1*u"q", __b_m_electron, __b_mu_electron, 0.5*u"ħ"),
  "photon" => SubatomicSpecies("photon", 0*u"q", 0.0*u"MeV/c^2", 0.0*u"J/T", 0.0*u"ħ"),
  "electron" => SubatomicSpecies("electron", -1*u"q", __b_m_electron, __b_mu_electron, 0.5*u"ħ"),
  "anti-proton" => SubatomicSpecies("anti-proton", -1*u"q", __b_m_proton, __b_mu_proton, 0.5*u"ħ"),
  "muon" => SubatomicSpecies("muon", -1*u"q", __b_m_muon, __b_mu_muon, 0.5*u"ħ"),
  "pion-" => SubatomicSpecies("pion-", -1*u"q", __b_m_pion_charged, 0.0*u"J/T", 0.0*u"ħ"),
  "anti-deuteron" => SubatomicSpecies("anti-deuteron", -1*u"q", __b_m_deuteron, __b_mu_deuteron, 1.0*u"ħ"),
  "anti-neutron" => SubatomicSpecies("anti-neutron", 0*u"q", __b_m_neutron, __b_mu_neutron, 0.5*u"ħ")
)





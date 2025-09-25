


# -----------------------------------------------------------------------------------------------
#=
Below we have a dictionary, SUBATOMIC_SPECIES :
this contatins key=>value pairs of  subatomic-name => SubatomicSpecies
=#


"""
    SUBATOMIC_SPECIES(CODATAYEAR)

## Description:
construct a dictionary of all the available subatomic species; 
the key is the particle's species_name, 
and the value is the relevant SubatomicSpecies struct, _eg_ 

Particle_dict["some-particle"] = SubatomicSpecies("some-particle", ...)
"""
SUBATOMIC_SPECIES

# global SUBATOMIC_SPECIES::Dict{String,SubatomicSpecies} = Dict{String,SubatomicSpecies}(
#     "pion0" => SubatomicSpecies("pion0", 0 * u"e", CODATA2022.__b_m_pion_0, 0.0 * u"J/T", 0.0 * u"h_bar"),
#     "neutron" => SubatomicSpecies("neutron", 0 * u"e", CODATA2022.__b_m_neutron, CODATA2022.__b_mu_neutron, 0.5 * u"h_bar"),
#     "deuteron" => SubatomicSpecies("deuteron", 1 * u"e", CODATA2022.__b_m_deuteron, CODATA2022.__b_mu_deuteron, 1.0 * u"h_bar"),
#     "pion+" => SubatomicSpecies("pion+", 1 * u"e", CODATA2022.__b_m_pion_charged, 0.0 * u"J/T", 0.0 * u"h_bar"),
#     "anti-muon" => SubatomicSpecies("anti-muon", 1 * u"e", CODATA2022.__b_m_muon, CODATA2022.__b_mu_muon, 0.5 * u"h_bar"),
#     "proton" => SubatomicSpecies("proton", 1 * u"e", CODATA2022.__b_m_proton, CODATA2022.__b_mu_proton, 0.5 * u"h_bar"),
#     "positron" => SubatomicSpecies("positron", 1 * u"e", CODATA2022.__b_m_electron, CODATA2022.__b_mu_electron, 0.5 * u"h_bar"),
#     "photon" => SubatomicSpecies("photon", 0 * u"e", 0.0 * u"MeV/c^2", 0.0 * u"J/T", 0.0 * u"h_bar"),
#     "electron" => SubatomicSpecies("electron", -1 * u"e", CODATA2022.__b_m_electron, CODATA2022.__b_mu_electron, 0.5 * u"h_bar"),
#     "anti-proton" => SubatomicSpecies("anti-proton", -1 * u"e", CODATA2022.__b_m_proton, CODATA2022.__b_mu_proton, 0.5 * u"h_bar"),
#     "muon" => SubatomicSpecies("muon", -1 * u"e", CODATA2022.__b_m_muon, CODATA2022.__b_mu_muon, 0.5 * u"h_bar"),
#     "pion-" => SubatomicSpecies("pion-", -1 * u"e", CODATA2022.__b_m_pion_charged, 0.0 * u"J/T", 0.0 * u"h_bar"),
#     "anti-deuteron" => SubatomicSpecies("anti-deuteron", -1 * u"e", CODATA2022.__b_m_deuteron, CODATA2022.__b_mu_deuteron, 1.0 * u"h_bar"),
#     "anti-neutron" => SubatomicSpecies("anti-neutron", 0 * u"e", CODATA2022.__b_m_neutron, CODATA2022.__b_mu_neutron, 0.5 * u"h_bar")
#   )

function subatomic_species(CODATAYEAR::CODATA)
  return Dict{String,SubatomicSpecies}(
    "pion0" => SubatomicSpecies("pion0", 0 * u"e", CODATAYEAR.__b_m_pion_0, 0.0 * u"J/T", 0.0 * u"h_bar"),
    "neutron" => SubatomicSpecies("neutron", 0 * u"e", CODATAYEAR.__b_m_neutron, CODATAYEAR.__b_mu_neutron, 0.5 * u"h_bar"),
    "deuteron" => SubatomicSpecies("deuteron", 1 * u"e", CODATAYEAR.__b_m_deuteron, CODATAYEAR.__b_mu_deuteron, 1.0 * u"h_bar"),
    "pion+" => SubatomicSpecies("pion+", 1 * u"e", CODATAYEAR.__b_m_pion_charged, 0.0 * u"J/T", 0.0 * u"h_bar"),
    "anti-muon" => SubatomicSpecies("anti-muon", 1 * u"e", CODATAYEAR.__b_m_muon, CODATAYEAR.__b_mu_muon, 0.5 * u"h_bar"),
    "proton" => SubatomicSpecies("proton", 1 * u"e", CODATAYEAR.__b_m_proton, CODATAYEAR.__b_mu_proton, 0.5 * u"h_bar"),
    "positron" => SubatomicSpecies("positron", 1 * u"e", CODATAYEAR.__b_m_electron, CODATAYEAR.__b_mu_electron, 0.5 * u"h_bar"),
    "photon" => SubatomicSpecies("photon", 0 * u"e", 0.0 * u"MeV/c^2", 0.0 * u"J/T", 0.0 * u"h_bar"),
    "electron" => SubatomicSpecies("electron", -1 * u"e", CODATAYEAR.__b_m_electron, CODATAYEAR.__b_mu_electron, 0.5 * u"h_bar"),
    "anti-proton" => SubatomicSpecies("anti-proton", -1 * u"e", CODATAYEAR.__b_m_proton, CODATAYEAR.__b_mu_proton, 0.5 * u"h_bar"),
    "muon" => SubatomicSpecies("muon", -1 * u"e", CODATAYEAR.__b_m_muon, CODATAYEAR.__b_mu_muon, 0.5 * u"h_bar"),
    "pion-" => SubatomicSpecies("pion-", -1 * u"e", CODATAYEAR.__b_m_pion_charged, 0.0 * u"J/T", 0.0 * u"h_bar"),
    "anti-deuteron" => SubatomicSpecies("anti-deuteron", -1 * u"e", CODATAYEAR.__b_m_deuteron, CODATAYEAR.__b_mu_deuteron, 1.0 * u"h_bar"),
    "anti-neutron" => SubatomicSpecies("anti-neutron", 0 * u"e", CODATAYEAR.__b_m_neutron, CODATAYEAR.__b_mu_neutron, 0.5 * u"h_bar")
  )
end


SUBATOMIC_SPECIES = subatomic_species(CODATA2022)


# AtomicAndPhysicalConstants/src/subatomic_species.jl

struct SubatomicSpecies
  species_name::String  # common species_name of the particle
  charge::Int64 # charge on the particle in e
  mass::Float64 # mass of the particle in [MeV/c^2]
  moment::Float64 # magnetic moment in J/T
  spin::Float64 # spin magnetic moment in [ħ]
end;


#####################################################################
#####################################################################


"""
    subatomic_species()

Construct a dictionary of subatomic particles with keys: 
["pion0", "neutron", "deuteron", "pion+", "anti-muon", "proton",
"positron", "photon", "electron", "anti-proton", "muon", "pion-",
"anti-deuteron", "anti-neutron"]

Each key is paired with a SubatomicSpecies struct containing 
information about the named particle.

## Example

SUBATOMIC_SPECIES = subatomic_species()
"""
subatomic_species

function subatomic_species(CODATAYEAR::CODATA_release)
  return Dict{String,SubatomicSpecies}(
    "pion0" => SubatomicSpecies("pion0", 0, CODATAYEAR.__b_m_pion_0, 0.0, 0.0),
    "neutron" => SubatomicSpecies("neutron", 0, CODATAYEAR.__b_m_neutron, CODATAYEAR.__b_mu_neutron, 0.5),
    "deuteron" => SubatomicSpecies("deuteron", 1, CODATAYEAR.__b_m_deuteron, CODATAYEAR.__b_mu_deuteron, 1.0),
    "pion+" => SubatomicSpecies("pion+", 1, CODATAYEAR.__b_m_pion_charged, 0.0, 0.0),
    "anti-muon" => SubatomicSpecies("anti-muon", 1, CODATAYEAR.__b_m_muon, CODATAYEAR.__b_mu_muon, 0.5),
    "proton" => SubatomicSpecies("proton", 1, CODATAYEAR.__b_m_proton, CODATAYEAR.__b_mu_proton, 0.5),
    "positron" => SubatomicSpecies("positron", 1, CODATAYEAR.__b_m_electron, CODATAYEAR.__b_mu_electron, 0.5),
    "photon" => SubatomicSpecies("photon", 0, 0.0, 0.0, 0.0),
    "electron" => SubatomicSpecies("electron", -1, CODATAYEAR.__b_m_electron, CODATAYEAR.__b_mu_electron, 0.5),
    "anti-proton" => SubatomicSpecies("anti-proton", -1, CODATAYEAR.__b_m_proton, CODATAYEAR.__b_mu_proton, 0.5),
    "muon" => SubatomicSpecies("muon", -1, CODATAYEAR.__b_m_muon, CODATAYEAR.__b_mu_muon, 0.5),
    "pion-" => SubatomicSpecies("pion-", -1, CODATAYEAR.__b_m_pion_charged, 0.0, 0.0),
    "anti-deuteron" => SubatomicSpecies("anti-deuteron", -1, CODATAYEAR.__b_m_deuteron, CODATAYEAR.__b_mu_deuteron, 1.0),
    "anti-neutron" => SubatomicSpecies("anti-neutron", 0, CODATAYEAR.__b_m_neutron, CODATAYEAR.__b_mu_neutron, 0.5)
  )
end


"""
    SUBATOMIC_SPECIES

Constant pointer to a dictionary of subatomic particles

## Example use:

`julia> SUBATOMIC_SPECIES[]["photon"]`
`SubatomicSpecies("photon", 0, 0.0, 0.0, 0.0)`
"""
const SUBATOMIC_SPECIES = Ref(subatomic_species(CODATA2022))



@doc """
    subatomic_particle(name::String)

## Description:
Dependence of Particle(name, charge=0, iso=-1)
Create a particle struct for a subatomic particle with name=name
"""
subatomic_particle

function subatomic_particle(name::String)
  # write the particle out directly
  leptons = ["electron", "positron", "muon", "anti-muon"]
  particle = SUBATOMIC_SPECIES[][name]
  if name == "photon"
    return Species(name, particle.charge,
      particle.mass,
      particle.spin,
      particle.moment,
      0.0, Kind.PHOTON)
  elseif name in leptons
    return Species(name, particle.charge,
      particle.mass,
      particle.spin,
      particle.moment,
      0.0, Kind.LEPTON)
  else
    return Species(name, particle.charge,
      particle.mass,
      particle.spin,
      particle.moment,
      0.0, Kind.HADRON)
  end
end
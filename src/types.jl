# AtomicAndPhysicalConstants/src/types.jl

# This module defines the core data structures used in APClite.
"""
"""

struct Species
  name::String # name of the particle to track
  charge::Int # charge of the particle (important to consider ionized atoms) in [e]
  mass::Float64 # mass of the particle in [eV/c^2]
  spin::Float64 # spin of the particle in [ħ]
  gspin::Float64 # gyromagnetic factor (if particle is subatomic, otherwise 0)
  moment::Float64 # magnetic moment of the particle (for now it's 0 unless we have a recorded value)
  iso::Int # if the particle is an atomic isotope this is the mass number, otherwise 0
  kind::Kind.T

  function Species(name::String, charge::Int, mass::Float64, spin::Float64, gspin::Float64, moment::Float64, iso::Int, kind::Kind.T)
    new(name, charge, mass, spin, gspin, moment, iso, kind)
  end


  # null constructor
  Species() = new("Null", 0, 0.0, 0.0, 0.0, 0.0, 0, Kind.NULL)
end;



"""
    SubatomicSpecies(speciesname, charge, mass, moment, spin, gspin)

#Structure for storing information about subatomic particles. Used in the SUBATOMIC_SPECIES dictionary.

## Fields:
-'speciesname::String': - openPMD formatted particl name.
-'charge::Int' - Particle charge in [e].
-'mass::Float64' - Particle mass in [eV/c^2].
-'moment::Float64' - Particle dipole moment in [eV/T].
-'spin::Float64' - Particle spin in [ħ].
-'gspin::Float64' - Particle g-factor.
"""
struct SubatomicSpecies
  speciesname::String  # common species_name of the particle
  charge::Int # charge on the particle in e
  mass::Float64 # mass of the particle in [MeV/c^2]
  moment::Float64 # magnetic moment in J/T
  spin::Float64 # spin magnetic moment in [ħ]
  gspin::Float64
end;


"""
    AtomicSpecies(Z, speciesname, mass)

Structure for storing information about atomic elements. Used in the ATOMIC_SPECIES dictionary.

## Fields:
-'Z::Int' - Atomic number.
-'speciesname::String': - Atomic symbol.
-'mass::Dict{Int,Float64}' - Dictionary of isotope masses for the element, each in [amu]. Dictionary is keyed by mass number.
"""
struct AtomicSpecies
  Z::Int  # atomic number
  speciesname::String  # periodic table element symbol
  mass::Dict{Int,Float64}  # a dict to store the masses, keyed by isotope all masses in amu
  #=
  keyvalue -1 => average mass of common isotopes [amu],
  keyvalue n ∈ {0} ∪ N is the mass number of the isotope
  	=> mass of that isotope [amu]
  =#
end;



# @doc"""
# CODATA is a type which contains all the relevant constants from our package;
# each release year is a different struct object with name "CODATAYYYY" where 
# YYYY is the year of the release.
# """ CODATA

@kwdef struct CODATA_release

  #######################################
  # constants with dimension [mass]
  #######################################


  M_ELECTRON::Float64
  # Electron Mass [MeV]/c^2
  M_PROTON::Float64
  # Proton Mass [MeV]/c^2
  M_NEUTRON::Float64
  # Neutron Mass [MeV]/c^2
  M_MUON::Float64
  # Muon Mass [MeV]/c^2
  M_HELION::Float64
  # Helion Mass He3 nucleus [MeV]/c^2
  M_DEUTERON::Float64
  # Deuteron Mass [MeV]/c^2

  # constants mysteriously missing from the release
  # picked up from PDG
  M_PION_0::Float64
  # uncharged pion mass [eV]/c^2
  M_PION_CHARGED::Float64
  # charged pion mass [eV]/c^2


  #######################################
  # constants with dimension [magnetic moment]
  #######################################


  MU_DEUTERON::Float64
  # deuteron magnetic moment in [J/T]
  MU_ELECTRON::Float64
  # electron magnetic moment in [J/T]
  MU_HELION::Float64
  # helion magnetic moment in [J/T]
  MU_MUON::Float64
  # muon magnetic moment in [J/T]
  MU_NEUTRON::Float64
  # neutron magnetic moment in [J/T]
  MU_PROTON::Float64
  # proton magnetic moment in [J/T]
  MU_TRITON::Float64
  # triton magnetic moment in [J/T]


  #######################################
  # dimensionless constants
  #######################################


  AVOGADRO::Float64
  # Avogadro's constant: Number / mole (exact)
  FINE_STRUCTURE::Float64
  # fine structure constant

  ANOMALY_ELECTRON::Float64
  # electron magnetic moment anomaly
  ANOMALY_MUON::Float64
  # muon magnetic moment anomaly

  G_DEUTERON::Float64
  # deuteron g factor 
  G_ELECTRON::Float64
  # electron g factor 
  G_HELION::Float64
  # helion g factor 
  G_MUON::Float64
  # muon g factor 
  G_NEUTRON::Float64
  # neutron g factor 
  G_PROTON::Float64
  # proton g factor 
  G_TRITON::Float64
  # triton g factor


  #######################################
  # constants with miscellaneous dimension
  #######################################

  E_CHARGE::Float64
  # elementary charge [C]
  R_ELECTRON::Float64
  # classical electron radius [m]
  R_PROTON::Float64
  # classical proton radius [m]
  C_LIGHT::Float64
  # speed of light [m/s]
  H_PLANCK::Float64
  # Planck's constant [J*s]
  H_BAR::Float64
  # h_planck/twopi [J*s]
  CLASSICAL_RADIUS_FACTOR::Float64
  # e^2 / (4 pi eps_0) = classical_radius*mass*c^2.
  # Is same for all particles of charge +/- 1.

  EPS_0::Float64
  # Permittivity of free space in [F/m]
  MU_0::Float64
  # Vacuum permeability in [N/A^2] (newtons per ampere squared)


  #######################################
  # conversion_consts
  #######################################

  G_PER_AMU::Float64
  # grams per dalton
  EV_PER_AMU::Float64
  # electronvolts/c^2 per dalton
  J_PER_EV::Float64
  # Joules per electronvolt
  EV_PER_J::Float64
  # electronvolts per joule
  G_PER_EV::Float64
  # grams per electronvolt/c^2


  RELEASE_YEAR::Int
  # release year for posterity
end

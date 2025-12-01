# AtomicAndPhysicalConstants/src/types.jl


struct Species
  name::String # name of the particle to track
  charge::Int # charge of the particle (important to consider ionized atoms) in [e]
  mass::Float64 # mass of the particle in [eV/c^2]
  spin::Float64 # spin of the particle in [ħ]
  moment::Float64 # magnetic moment of the particle (for now it's 0 unless we have a recorded value)
  iso::Int # if the particle is an atomic isotope this is the mass number, otherwise 0
  kind::Kind.T

  function Species(name::String, charge::Int, mass::Float64, spin::Float64, moment::Float64, iso::Int, kind::Kind.T)
    new(name, charge, mass, spin, moment, iso, kind)
  end
end;


struct SubatomicSpecies
  species_name::String  # common species_name of the particle
  charge::Int # charge on the particle in e
  mass::Float64 # mass of the particle in [MeV/c^2]
  moment::Float64 # magnetic moment in J/T
  spin::Float64 # spin magnetic moment in [ħ]
end;

struct AtomicSpecies
  Z::Int  # atomic number
  species_name::String  # periodic table element symbol
  mass::Dict{Int64,Float64}  # a dict to store the masses, keyed by isotope all masses in amu
  #=
  keyvalue -1 => average mass of common isotopes [amu],
  keyvalue n ∈ {0} ∪ N is the mass number of the isotope
  	=> mass of that isotope [amu]
  =#
end;
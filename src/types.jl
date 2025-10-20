# types.Julia



# kind enum stores the kind of particle
# NULL is for null species (placeholder species)
@enumx Kind ATOM HADRON LEPTON PHOTON NULL


#The docstring for this struct is with its constructor, in the file `src/constructors.jl`

struct Species
  name::String # name of the particle to track
  charge::Int64 # charge of the particle (important to consider ionized atoms) in [e]
  mass::Float64 # mass of the particle in [eV/c^2]
  spin::Float64 # spin of the particle in [ħ]
  moment::Float64 # magnetic moment of the particle (for now it's 0 unless we have a recorded value)
  iso::Int64 # if the particle is an atomic isotope this is the mass number, otherwise 0
  kind::Kind.T
end

Species() = Species("Null", 0, 0.0, 0.0, 0.0, 0, Kind.NULL)




import Base: getproperty



function getproperty(obj::Species, field::Symbol)
  
  error("Do not use the 'base.getproperty' syntax to access fields 
  of Species objects: instead use the provided functions; 
  massof, chargeof, spinof, momentof, isotopeof, kindof, or nameof.")

end; export getproperty


#####################################################################
#####################################################################



struct SubatomicSpecies
  species_name::String  # common species_name of the particle
  charge::Int64 # charge on the particle in units of e
  mass::Float64 # mass of the particle in [eV/c^2]
  moment::Float64 # magnetic moment in J/T
  spin::Float64 # spin magnetic moment in [ħ]
end;


#####################################################################
#####################################################################




struct AtomicSpecies
  Z::Int64  # atomic number
  species_name::String  # periodic table element symbol
  mass::Dict{Int64,Float64}  # a dict to store the masses, keyed by isotope
  #=
  keyvalue -1 => average mass of common isotopes [amu],
  keyvalue n ∈ {0} ∪ N is the mass number of the isotope
  	=> mass of that isotope [amu]
  =#
end
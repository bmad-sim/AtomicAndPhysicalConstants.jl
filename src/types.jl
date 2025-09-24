# types.Julia



# kind enum stores the kind of particle
# NULL is for null species (placeholder species)
@enumx Kind ATOM HADRON LEPTON PHOTON NULL


#The docstring for this struct is with its constructor, in the file `src/constructors.jl`

struct Species
  name::String # name of the particle to track
  charge::typeof(1u"e") # charge of the particle (important to consider ionized atoms) in [e]
  mass::typeof(1.0u"MeV/c^2") # mass of the particle in [eV/c^2]
  spin::typeof(1.0u"h_bar") # spin of the particle in [ħ]
  moment::typeof(1.0u"J/T") # magnetic moment of the particle (for now it's 0 unless we have a recorded value)
  iso::Float64 # if the particle is an atomic isotope this is the mass number, otherwise 0
  kind::Kind.T
end

function Species() 

  return Species("Null", 0.0u"e", 0.0u"MeV/c^2", 0.0u"h_bar", 0.0u"J/T", 0, Kind.NULL)

end



import Base: getproperty



function getproperty(obj::Species, field::Symbol)
  
  error("Do not use the 'base.getproperty' syntax to access fields 
  of Species objects: instead use the provided functions; 
  massof, chargeof, spinof, momentof, isotopeof, kindof, or nameof.")

end; export getproperty


#####################################################################
#####################################################################



struct SubatomicSpecies
  species_name::String              # common species_name of the particle
  charge::typeof(1.0u"e")                     # charge on the particle in units of e+
  mass::typeof(1.0u"MeV/c^2")                    # mass of the particle in [eV/c^2]
  moment::typeof(1.0u"J/T")       # magnetic moment 
  spin::typeof(1.0u"h_bar")                    # spin magnetic moment in [ħ]
end;


#####################################################################
#####################################################################




struct AtomicSpecies
  Z::Int64                                # number of protons
  species_name::String                  # periodic table element symbol
  mass::Dict{Int64,typeof(1.0 * u"amu")}  # a dict to store the masses, keyed by isotope
  #=
  keyvalue -1 => average mass of common isotopes [amu],
  keyvalue n ∈ {0} ∪ N is the mass number of the isotope
  	=> mass of that isotope [amu]
  =#
end
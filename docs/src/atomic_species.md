# Atomic Species 

atomic_species contains a dictionary off all the availible atomic species, with all the NIST isotopes.
They key is an element's atomic symbol in the periodic table and the value is the relevent AtomicSpecies struct.

For example, 
ATOMIC_SPECIES["He"] = AtomicSpecies(2, "He", ...)

## atomic_particle 

The function, atomic_particle creates a species struct for an atomic species with name=name, charge=charge and ios=iso.

*atomic_particle(name::String, charge::Int, iso::INT, CODATAvals, SUMBATOMIC_SPECIES)*




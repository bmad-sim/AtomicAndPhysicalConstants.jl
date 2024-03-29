# AtomicAndPhysicalConstants.jl/src/ParticleTypes.jl



abstract type AbstractSpecies end; export AbstractSpecies




	# -----------------------------------------------------------------------------------------------
	#=
	first define types for particle tracking: immutable for speed, data from a dictionary defined later 
	in this file is copied into one of these structs for particle tracking.
	=#
	
	
	"""
			SubatomicSpecies <: AbstractSpecies
	
	### Description:
	> immutable struct to be used for simulations of subatomic particle dynamics <
	
	### Fields:
	- `species_name`    -- AbstractString common name of particle
	- `charge`          -- charge on the particle in units of [e+]
	- `mass`            -- Float64 mass of given subatomic particle in [eV/c^2]
	- `other`           -- dictionary containing other attributes, eg 
												 spin and anomalous magnetic moment
	
	### Examples:
	- SubatomicSpecies("pion+", 1, 139.57018e6, other("anomalous_moment")=0.0, other("spin")=0.0)
	- SubatomicSpecies("electron", -1, 0.51099895000e6, 
		other("anomalous_moment")=anom_mag_moment_electron, other("spin")=0.5)
	""" SubatomicSpecies
	
	struct SubatomicSpecies <: AbstractSpecies
		species_name::AbstractString
		charge::Int32
		mass::Float64
		other::Dict{String,Float64}
	end; export SubatomicSpecies
	
	
	
	
	
	"""
			AtomicSpecies <: AbstractSpecies
	
	### Description:
	> immutable struct to be used for simulations of atomic particle dynamics <
	
	### Fields:
	- `species_name`    -- AbstractString periodic table symbol for element
	- `Z`               -- Integer atomic number (i.e. protons in the nucleus)
	- `charge`          -- Integer net charge on the atom in units of [e+]
	- `mass`            -- Float64 mass of given atomic isotope in [AMU]
	
	### Examples:
	- AtomicSpecies("Li", 3, 0, 6.9675)
	- AtomicSpecies("Ag", 47, -2, 107.8682)
	""" AtomicSpecies
	
	struct AtomicSpecies <: AbstractSpecies
		species_name::AbstractString
		Z::Int32
		charge::Int32
		mass::Float64
	end; export AtomicSpecies
	
	
	
	
	mutable struct MolecularSpeciesData
		species_name::AbstractString
		charge::Float64
		# mass::
		# other::Dict()
	end



# -----------------------------------------------------------------------------------------------
#=
In the following section, data types which carry all the information about particle species are 
defined: for now there are just atomic and subatomic particles
=#




"""
SubtomicSpeciesData <: AbstractSpeciesData

### Description:
> mutable struct to store all (possibly degenerate) information about a subatomic particle<

### Fields:
- `species_name`      -- AbstractString common name for (anti) baryon
- `charge`            -- electric charge on the given particle in units of [e+]
- `mass`              -- mass of the given particle in [eV/c^2]
- `anomalous_moment`  -- anomalous magnetic moment of particle
- `spin`              -- spin of the particle

### Notes:
some parameters in this struct are likely named constants from PhysicalConstants.jl

### Examples:
- SubatomicSpeciesData("neutron", 0, m_neutron, anom_mag_moment_neutron, 0.5)
- SubatomicSpeciesData("pion-", -1, m_pion_charged, 0.0, 0.0)
"""  SubatomicSpeciesData

mutable struct SubatomicSpeciesData
species_name::AbstractString              # common species_name of the particle
charge::Int                     # charge on the particle in units of e+
mass::Float64                     # mass of the particle in [eV/c^2]
anomalous_moment::Float64         # anomalous magnetic moment 
spin::Float64                     # spin magnetic moment in [ħ]
end; export SubatomicSpeciesData






"""
AtomicSpeciesData <: AbstractSpeciesData

### Description:
> mutable struct to store all (possibly degenerate) information about a particular element<

### Fields:
- `Z`               -- Integer atomic number (i.e. protons in the nucleus)
- `species_name`    -- AbstractString periodic table symbol for element
- `mass`            -- > Dict{Int, Float64}(isotope::Int, mass::Float64) isotope masses in [AMU]
									 > key -1 refers to the average common atomic mass, other keys refer to 
									 > the number of nucleons present in the isotope <

### Examples:
- AtomicSpeciesData(3, "Li", Dict(Int64, Float64)(-1 => 6.9675, 3 => 3.0308, 4 => 4.02719, 5 => 5.012538, 6 => 6.0151228874, 7 => 7.0160034366, 8 => 8.022486246, 9 => 9.02679019, 10 => 10.035483, 11 => 11.04372358, 12 => 12.052517, 13 => 13.06263))
- AtomicSpeciesData(47, "Ag", Dict(Int64, Float64)(-1 => 107.8682, 92 => 92.95033, 93 => 93.94373, 94 => 94.93602, 95 => 95.930744, 96 => 96.92397, 97 => 97.92156, 98 => 98.9176458, 99 => 99.9161154, 100 => 100.912684, 101 => 101.9117047, 102 => 102.9089631, 103 => 103.9086239, 104 => 104.9065256, 105 => 105.9066636, 106 => 106.9050916, 107 => 107.9059503, 108 => 108.9047553, 109 => 109.9061102, 110 => 110.9052959, 111 => 111.9070486, 112 => 112.906573, 113 => 113.908823, 114 => 114.908767, 115 => 115.9113868, 116 => 116.911774, 117 => 117.9145955, 118 => 118.91557, 119 => 119.9187848, 120 => 120.920125, 121 => 121.923664, 122 => 122.925337, 123 => 123.92893, 124 => 124.93105, 125 => 125.93475, 126 => 126.93711, 127 => 127.94106, 128 => 128.94395, 129 => 129.9507))
""" AtomicSpeciesData

mutable struct AtomicSpeciesData
Z::Int                      # number of protons
species_name::AbstractString          # periodic table element symbol
mass::Dict{Int,Float64}     # a dict to store the masses, keyed by isotope
#=
keyvalue -1 => average mass of common isotopes,
keyvalue n ∈ {0} ∪ N is the mass number of the isotope
=#
end; export AtomicSpeciesData




# Package: AtomicAndPhysicalConstants
# file: src/species_initialize.jl
# purpose: define constructors




#####################################################################
#####################################################################


"""
		subatomic_particle(name::String)

Dependence of Particle(name, charge=0, iso=-1)
Create a particle struct for a subatomic particle with name=name
"""
subatomic_particle

function subatomic_particle(name::String)
    # write the particle out directly
    return Species(name, SUBATOMIC_SPECIES[name].charge,
        SUBATOMIC_SPECIES[name].mass,
        SUBATOMIC_SPECIES[name].spin,
        SUBATOMIC_SPECIES[name].mu,
        0., IsDef.Full)
end


#####################################################################
#####################################################################


"""
	Species Struct:

The Particle struct is used for keeping track 
of information specifice to the chosen particle.

# Fields:
1. `name::String': 				the name of the particle 

2. `int_charge::typeof(1u"q")': 				 the net charge of the particle in units of |e|
																		 	 - bookkeeping only, thus in internal units
																			 - use the 'charge()' function to get the charge 
																			 - in the desired units

3. `mass::typeof(1.0u"eV/c^2")': 				 the mass of the particle in eV/c^2
																			 - bookkeeping only, thus in internal units
																		 	 - use the 'mass()' function to get the mass 
																			 - in the desired units

4. `spin::typeof(1.0u"h_bar")': 					 the spin of the particle in ħ

5. `moment::typeof(1.0u"eV/T")': 					 the magnetic moment of the particle in eV/T

6. `iso::Int': 												 if the particle is an atomic isotope, this is the 
																			 - mass number, otherwise -1

The Species Struct also has a constructor called Species, 
documentation for which follows.

		Species(name::String, charge::Int=0, iso::Int=-1)

Create a species struct for tracking and simulation.
If an anti-particle (subatomic or otherwise) prepend "anti-" to the name.

# Arguments
1. `name::String': the name of the species 
		* subatomic particle names must be given exactly,
		* Atomic symbols may include charge and isotope eg #9Li+1
		* where #[1-999] specifies the isotope and (+/-)[0-999] specifies charge
2. `charge::Int=0': the charge of the particle.
		* only affects atoms 
		* overwritten if charge given in the name
3. `iso::Int' the mass number of the atom
		* only affects atoms 
		* overwritten if mass given in the name

"""
Species


Species() = Species("Null", 0.0u"e", 0.0u"MeV/c^2", 0.0u"h_bar", 0.0u"J/T", 0, IsDef.Empty)

function Species(name::String, charge::Int=0, iso::Int=-1)


	anti = r"Anti\-|anti\-"
	# is the anti-particle in the Subatomic_Particles dictionary?
	if occursin(anti, name) && haskey(SUBATOMIC_SPECIES, name[6:end])
		if name[6:end] == "electron"
				return subatomic_particle("positron")
		else
				return subatomic_particle("anti_" * name[6:end])
		end

			# check subatomics first so we don't accidentally strip a name
	elseif haskey(SUBATOMIC_SPECIES, name) # is the particle in the Subatomic_Particles dictionary?
		# write the particle out directly
		return subatomic_particle(name)

	else
		# make sure to use the optional arguments
		charge = charge
		iso = iso

		# define regex for the name String

		rgas = r"[A-Z][a-z]|[A-Z]" # atomic symbol regex
		rgm = r"#[0-9][0-9][0-9]|#[0-9][0-9]|#[0-9]" # atomic mass regex
		rgcp = r"\+[0-9][0-9][0-9]|\+[0-9][0-9]|\+[0-9]|\+\+|\+" # positive charge regex
		rgcm = r"\-[0-9][0-9][0-9]|\-[0-9][0-9]|\-[0-9]|\-\-|\-" # negative charge regex

		anti_atom::Bool = false

		if occursin(anti, name)
			name = name[6:end]
			anti_atom = true
		end

		AS = match(rgas, name) # grab just the atomic symbol
		AS = AS.match # throw out the wrapper
		isom = match(rgm, name)
		if typeof(isom) != Nothing
			isostr = strip(isom.match, '#')
			iso = tryparse(Int, isostr)
		end
		if occursin(rgcp, name) == true
			chstr = match(rgcp, name).match
			if chstr == "+"
					charge = 1
			elseif chstr == "++"
					charge = 2
			else
					charge = tryparse(Int, chstr)
			end
		elseif occursin(rgcm, name) == true
			chstr = match(rgcm, name).match
			if chstr == "-"
					charge = -1
			elseif chstr == "--"
					charge = -2
			else
					charge = tryparse(Int, chstr)
			end
		end
		if count('+', name) != 0 && count('-', name) != 0
			error(f"""You made a typo in "{name}". You have both a + and a - in the name. """)
			return
		end
		if haskey(ATOMIC_SPECIES, AS) # is the particle in the Atomic_Particles dictionary?
			if iso ∉ keys(ATOMIC_SPECIES[AS].mass) # error handling if the isotope isn't available
				error("The isotope you specified is not available: Isotopes are specified by the atomic symbol and integer mass number.")
				return
			end
			mass = begin
				if anti_atom == false
					nmass = uconvert(u"MeV/c^2", ATOMIC_SPECIES[AS].mass[iso]); 
					# ^ mass of the positively charged isotope in eV/c^2
					nmass.val + __b_m_electron.val * (ATOMIC_SPECIES[AS].Z - charge) 
					# ^ put it in eV/c^2 and remove the electrons
				elseif anti_atom == true
					nmass = uconvert(u"MeV/c^2", ATOMIC_SPECIES[AS].mass[iso]); 
					# ^ mass of the positively charged isotope in amu
					nmass.val + __b_m_electron.val * (-ATOMIC_SPECIES[AS].Z + charge) 
					# ^ put it in eV/c^2 and remove the positrons
				end
			end
				if iso == -1 # if it's the average, make an educated guess at the spin
					partonum = round(ATOMIC_SPECIES[AS].mass[iso].val)
					if anti_atom == false
						spin = 0.5 * (partonum + (ATOMIC_SPECIES[AS].Z - charge))
					else
						spin = 0.5 * (partonum + (ATOMIC_SPECIES[AS].Z + charge))
					end
				else # otherwise, use the sum of proton and neutron spins
					spin = 0.5 * iso
				end
				if anti_atom == false
					return Species(AS, charge*u"e", mass*u"MeV/c^2", spin*u"h_bar", 0*u"J/T", iso, IsDef.Full) # return the object to track
				else
					return Species("anti-" * AS, charge*u"e", mass*u"MeV/c^2", spin*u"h_bar", 0u"J/T", iso, IsDef.Full)
				end


		else # handle the case where the given name is garbage
			error("The specified particle name does not exist in this library.")
			#=
			println("Available subatomic particles are: ")
			for p in keys(SUBATOMIC_SPECIES)
				println(p)
			end
			println("Available atomic elements are")
			for p in keys(ATOMIC_SPECIES)
				println(p)
			end
			=#
			return
		end
	end
end;
export Species



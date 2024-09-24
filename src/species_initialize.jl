# AtomicAndPhysicalConstants.jl/src/ParticleTypes.jl








struct Species
  name::String # name of the particle to track
  charge::Int32 # charge of the particle (important to consider ionized atoms) in [e]
  mass::Float64 # mass of the particle in [eV/c^2]
  spin::Float64 # spin of the particle in [eV*s]
  mu::Float64 # magnetic moment of the particle (for now it's 0 unless we have a recorded value)
	iso::Int # if the particle is an atomic isotope, this is the mass number, otherwise 0
end;
export Species




# ------------------------------------------------------------------------------------------------------------

"""
		subatomic_particle(name::String)

Dependence of Particle(name, charge=0, iso=-1)
Create a particle struct for a subatomic particle with name=name
""" subatomic_particle

function subatomic_particle(name::String)
		# write the particle out directly
		return Species(name, subatomic_particles[name].charge,
			subatomic_particles[name].mass,
			subatomic_particles[name].spin,
			subatomic_particles[name].mu,
			0)
	end

# -----------------------------------------------------------------------------------------------


"""
	Species Struct:

The Particle struct is used for keeping track 
of information specifice to the chosen particle.

# Fields:
1. `name::String': 	the name of the particle 
2. `charge::Int32': the net charge of the particle in units of |e|
3. `mass::Float64': the mass of the particle
4. `spin::Float64': the spin of the particle (multiplied with ħ)
5. `mu::Float64': 	the magnetic moment of the particle.
5. `iso::Int': 			if the particle is an atomic isotope, this is the 
										mass number, otherwise 0

The Species Struct also has a constructor called Species, 
documentation for which follows.

		Species(name::String, charge::Int=0, iso::Int=-1)

Create a species struct for tracking and simulation.
If an anti-particle (subatomic or otherwise) prepend "anti-" to the name.

# Arguments
1. `name::String': the name of the species 
		* subatomic particle names must be given exactly,
		* Atomic symbols may include charge and isotope eg Li#9+1
		* where #[1-999] specifies the isotope and (+/-)[0-999] specifies charge
2. `charge::Int=0': the charge of the particle.
		* only affects atoms 
		* overwritten if charge given in the name
3. `iso::Int' the mass number of the atom
		* only affects atoms 
		* overwritten if mass given in the name

""" Species



function Species(name::String, charge::Int=0, iso::Int=-1)

	anti = r"Anti\-|Anti|anti\-|anti"
	# is the anti-particle in the Subatomic_Particles dictionary?
	if occursin(anti, name) && haskey(subatomic_particles, name[6:end])
		if name[6:end] == "electron"
			if charge != 0 || iso != -1
				println("Subatomic particles accept no optional charge or mass arguments.")
				println("For a list of subatomic particles available, see the documentation.")
				return
			else
				return subatomic_particle("positron")
			end
		else
			if charge != 0 || iso != -1
				println("Subatomic particles accept no optional charge or mass arguments.")
				println("For a list of subatomic particles available, see the documentation.")
				return
			else
				return subatomic_particle("anti_"*name[6:end])
			end
		end

	# check subatomics first so we don't accidentally strip a name
	elseif haskey(subatomic_particles, name) 
		if charge != 0 || iso != -1
			println("Subatomic particles accept no optional charge or mass arguments.")
			println("For a list of subatomic particles available, see the documentation.")
			return
		else
			return subatomic_particle(name)
		end
		
	else
		# make sure to use the optional arguments
		charge = charge
		iso = iso

		# define regex for the name String

		rgas = r"[A-Z][a-z]|[A-Z]" # atomic symbol regex
		rgm = r"#[0-9][0-9][0-9]|#[0-9][0-9]|#[0-9]" # atomic mass regex
		rgcp = r"\+[0-9][0-9][0-9]|\+[0-9][0-9]|\+[0-9]|\+\+|\+" # positive charge regex
		rgcm = r"\-[0-9][0-9][0-9]|\-[0-9][0-9]|\-[0-9]|\-\-|\-" # negative charge regex
		errreg = r"\+[A-Z]|\+[a-z]|\-[A-Z]|\-[a-z]|#[A-Z]|#[a-z]"

		anti_atom = false

		# handle bad atomic names
		if occursin(errreg, name) == true
			println("\nBad characters appear in your atom specification;")
			println("no species has been set.")
			return
		end

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
	

		if haskey(atomic_particles, AS) # is the particle in the Atomic_Particles dictionary?
			if iso ∉ keys(atomic_particles[AS].mass) # error handling if the isotope isn't available
				println("The isotope you specified is not available.")
				println("Isotopes are specified by the atomic symbol and integer mass number.")
				return
			end
			mass = begin
				if anti_atom == false
					nmass = atomic_particles[AS].mass[iso] # mass of the positively charged isotope in amu
					nmass * (__b_eV_per_amu) + __b_m_electron * (atomic_particles[AS].Z - charge) # put it in eV/c^2 and remove the electrons
				elseif anti_atom == true
					nmass = atomic_particles[AS].mass[iso] # mass of the positively charged isotope in amu
					nmass * (__b_eV_per_amu) + __b_m_electron * (-atomic_particles[AS].Z + charge) # put it in eV/c^2 and remove the positrons
				end
			end
			if iso == -1 # if it's the average, make an educated guess at the spin
				partonum = round(nmass)
				if anti_atom == false
					spin = 0.5*__b_h_bar_planck*(partonum + (atomic_particles[AS].Z-charge))
				elseif anti_atom == true
					spin = 0.5*__b_h_bar_planck*(partonum + (atomic_particles[AS].Z+charge))
				end
			else # otherwise, use the sum of proton and neutron spins
				spin = 0.5*__b_h_bar_planck*iso
			end
			if anti_atom == false
				return Species(AS, charge, mass, spin, 0, iso) # return the object to track
			elseif anti_atom == true
				return Species("anti-"*AS, charge, mass, spin, 0, iso)
			end


		else # handle the case where the given name is garbage
			println("The specified particle name does not exist in this library.")
			println("Available subatomic particles are: ")
			for p in keys(subatomic_particles)
				println(p)
			end
			println("Available atomic elements are")
			for p in keys(atomic_particles)
				println(p)
			end
			return
		end
	end
end; export Species



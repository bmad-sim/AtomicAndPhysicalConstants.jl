# AtomicAndPhysicalConstants.jl/src/ParticleTypes.jl








struct Species
  name::String # name of the particle to track
  charge::Int32 # charge of the particle (important to consider ionized atoms) in [e]
  mass::Float64 # mass of the particle in [eV/c^2]
  spin::Float64 # spin of the particle in [eV*s]
  mu::Float64 # magnetic moment of the particle (for now it's 0 unless we have a recorded value)
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
			subatomic_particles[name].mu)
	end

# -----------------------------------------------------------------------------------------------


"""
	Species Struct:

The Particle struct is used for keeping track 
of information specifice to the chosen particle.

# Fields:
1. `name::String': the name of the particle 
2. `charge::Int32': the net charge of the particle in units of |e|
3. `mass::Float64': the mass of the particle
4. `spin::Float64': the spin of the particle (multiplied with ħ)
5. `mu::Float64': the magnetic moment of the particle.

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

	anti = r"Anti\-|anti\-"
	# is the anti-particle in the Subatomic_Particles dictionary?
	if occursin(anti, name) && haskey(Subatomic_Particles, name[6:end])
		if name[6:end] != "electron"
			return subatomic_particle("positron")
		else
			return subatomic_particle("anti_"*name[6:end])
		end

	# check subatomics first so we don't accidentally strip a name
	elseif haskey(Subatomic_Particles, name) # is the particle in the Subatomic_Particles dictionary?
		# write the particle out directly
			subatomic_particle(name)
		
	else
		# make sure to use the optional arguments
		charge = charge
		iso = iso

		# define regex for the name String

		rgas = r"[A-Z][a-z]|[A-Z]" # atomic symbol regex
		rgm = r"#[0-9][0-9][0-9]|#[0-9][0-9]|#[0-9]" # atomic mass regex
		rgcp = r"\+[0-9][0-9][0-9]|\+[0-9][0-9]|\+[0-9]|\+\+|\+" # positive charge regex
		rgcm = r"\-[0-9][0-9][0-9]|\-[0-9][0-9]|\-[0-9]|\-\-|\-" # negative charge regex

		anti_atom = false

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
			chstr = match(rgcp, name)
			if chstr == '+'
				charge = 1
			elseif chstr == "++"
				charge = 2
			else 
				charge = tryparse(Int, chstr)
			end
		elseif occursin(rgcm, name) == true
			chstr = match(rgcm, name)
			if chstr == '-'
				charge = -1
			elseif chstr == "--"
				charge = -2
			else 
				charge = tryparse(Int, chstr)
			end
		end
		

		if haskey(Atomic_Particles, AS) # is the particle in the Atomic_Particles dictionary?
			if iso ∉ keys(Atomic_Particles[AS].mass) # error handling if the isotope isn't available
				println("The isotope you specified is not available.")
				println("Isotopes are specified by the atomic symbol and integer mass number.")
				return
			end
			mass = begin
				if anti_atom == false
					nmass = Atomic_Particles[AS].mass[iso] # mass of the positively charged isotope in amu
					nmass * (__b_eV_per_amu) + __b_m_electron * (Atomic_Particles[AS].Z - charge) # put it in eV/c^2 and remove the electrons
				elseif anti_atom == true
					nmass = Atomic_Particles[AS].mass[iso] # mass of the positively charged isotope in amu
					nmass * (__b_eV_per_amu) + __b_m_electron * (-Atomic_Particles[AS].Z + charge) # put it in eV/c^2 and remove the positrons
				end
			end
			if iso == -1 # if it's the average, make an educated guess at the spin
				partonum = round(nmass)
				if anti_atom == false
					spin = 0.5*__b_h_bar_planck*(partonum + (Atomic_Particles[AS].Z-charge))
				elseif anti_atom == true
					spin = 0.5*__b_h_bar_planck*(partonum + (Atomic_Particles[AS].Z+charge))
				end
			else # otherwise, use the sum of proton and neutron spins
				spin = 0.5*__b_h_bar_planck*iso
			end
			if anti_atom == false
				return Species(AS, charge, mass, spin, 0) # return the object to track
			elseif anti_atom == true
				return Species("anti-"*AS, charge, mass, spin, 0)
			end


		else # handle the case where the given name is garbage
			println("The specified particle name does not exist in this library.")
			println("Available subatomic particles are: ")
			for p in keys(Subatomic_Particles)
				println(p)
			end
			println("Available atomic elements are")
			for p in keys(Atomic_Particles)
				println(p)
			end
			return
		end
	end
end; export Species



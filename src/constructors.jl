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
  leptons = ["electron", "positron", "muon", "anti-muon"]
  if lowercase(name) == "photon"
    return Species(name, SUBATOMIC_SPECIES[name].charge,
      SUBATOMIC_SPECIES[name].mass,
      SUBATOMIC_SPECIES[name].spin,
      SUBATOMIC_SPECIES[name].mu,
      0.0, Kind.PHOTON)
  elseif lowercase(name) in leptons
    return Species(name, SUBATOMIC_SPECIES[name].charge,
      SUBATOMIC_SPECIES[name].mass,
      SUBATOMIC_SPECIES[name].spin,
      SUBATOMIC_SPECIES[name].mu,
      0.0, Kind.LEPTON)
  else
    return Species(name, SUBATOMIC_SPECIES[name].charge,
      SUBATOMIC_SPECIES[name].mass,
      SUBATOMIC_SPECIES[name].spin,
      SUBATOMIC_SPECIES[name].mu,
      0.0, Kind.HADRON)
  end
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


Species() = Species("Null", 0.0u"e", 0.0u"MeV/c^2", 0.0u"h_bar", 0.0u"J/T", 0, Kind.NULL)

function Species(name::String, charge::Int, iso::Int)
  # whether the atom is anti-atom
  anti_atom::Bool = occursin(r"Anti\-|anti\-|Anti|anti", name)
  # if the particle is an anti-particle, remove the prefix for easier lookup
  AS::String = replace(name, r"Anti\-|anti\-|Anti|anti" => "")

  @assert haskey(ATOMIC_SPECIES, AS) "$AS is not a valid atomic species"

  atom::AtomicSpecies = ATOMIC_SPECIES[AS]
  nmass::Float64 = uconvert(u"MeV/c^2", atom.mass[iso]).val
  spin::Float64 = 0.0

  mass::Float64 = begin
    if anti_atom == false
      # ^ mass of the positively charged isotope in eV/c^2
      nmass + __b_m_electron.val * ( - charge)
      # ^ put it in eV/c^2 and remove the electrons
    else
      # ^ mass of the positively charged isotope in amu
      nmass + __b_m_electron.val * ( + charge)
      # ^ put it in eV/c^2 and remove the positrons
    end
  end
  if iso == -1 # if it's the average, make an educated guess at the spin
    partonum::Float64 = round(atom.mass[iso].val)
    if anti_atom == false
      spin = 0.5 * (partonum + (atom.Z - charge))
    else
      spin = 0.5 * (partonum + (atom.Z + charge))
    end
  else # otherwise, use the sum of proton and neutron spins
    spin = 0.5 * iso
  end
  # return the object to track
  if anti_atom == false
    return Species(AS, charge * u"e", mass * u"MeV/c^2",
      spin * u"h_bar", 0 * u"J/T", iso, Kind.ATOM)
  else
    return Species("anti-" * AS, charge * u"e", mass * u"MeV/c^2",
      spin * u"h_bar", 0 * u"J/T", iso, Kind.ATOM)
  end

end
export Species

function Species(speciesname::String)
  name::String = speciesname
  # if the name is "Null", return a null Species
  if name == "Null" || name == "null" || name == ""
    return Species()
  end

  # by checking for the anti- prefix, we can determine if the particle is an anti-particle
  # anti is true for anti-particles
  anti::Bool = occursin(r"Anti\-|anti\-|Anti|anti", name)
  # if the particle is an anti-particle, remove the prefix for easier lookup
  name = replace(name, r"Anti\-|anti\-|Anti|anti" => "")

  for (k, _) in SUBATOMIC_SPECIES
    # whether the particle is in the subatomic species dictionary
    if occursin(k, lowercase(name))
      # whether the particle name only contains characters in the subatomic species dictionary
      # delete all the names and spaces, there should be nothing left
      @assert isempty(replace(replace(name, k => ""), " " => ""))
      "$speciesname should contain only the name of the subatomic particle"
      if anti
        if lowercase(k) == "electron"
          return subatomic_particle("positron")
        end
        return subatomic_particle("anti-" * k)
      else
        return subatomic_particle(k)
      end
    end
  end

  # the atomic symbol
  atom::String = ""
  # the first index of the atomic symbol
  index::Int64 = 0

  # if the particle is not in the subatomic species dictionary, check the atomic species dictionary
  for k in sort(collect(keys(ATOMIC_SPECIES)), by=length, rev=true) #  sort by length to find the longest match first
    # whether the particle is in the atomic species dictionary
    if occursin(k, name)
      atom = k
      index = findfirst(k, name).start  # find the first index of the atomic symbol
      break
    end
  end
  # atom should not be empty
  @assert atom != "" "you did not specify an atomic species or subatomic species in $speciesname"


  #check for the isotope 

  #the substring before the symbol
  left::String = ""
  try
    left = name[1:index-1]
  catch
    try
      left = name[1:index-2] #if unicode takes 2 bytes
    catch
      try
        left = name[1:index-3] #if unicode takes 3 bytes
      catch
        left = name[1:index-4] #if unicode takes 3 bytes
      end
    end
  end
  #the substring after the symbol
  right::String = name[index+length(atom):end]

  iso::Int64 = 0

  #if the user choose to put isotope in the front 
  if left != ""
    # the substring should include only digits or unicode superscript
    @assert occursin(r"^[0-9⁰¹²³⁴⁵⁶⁷⁸⁹]+$", left) "To specify isotope, you should only include 
    numbers or superscript numbers before the atomic symbol in $speciesname"
    # convert the isotope to an integer
    for c in left
      if haskey(SUPERSCRIPT_MAP, c)
        iso = iso * 10 + SUPERSCRIPT_MAP[c]
      else
        iso = iso * 10 + parse(Int64, c)
      end
    end
    @assert haskey(ATOMIC_SPECIES[atom].mass, iso) "$iso is not a valid isotope of $atom"
  end

  # if the user choose to put isotope in the back
  @assert !(iso != 0 && occursin("#", right)) "You cannot specified isotope in both front and back of the atomic symbol in $speciesname"

  if occursin("#", right)
    # there should not be anything except for space before the #
    @assert replace(right, " " => "")[1] == '#' "You cannot put anything between atomic symbol and `#`"
    # parse the isotope, the number should be in ASCII
    @assert isdigit(right[2]) "use numbers (not superscripts) to specify isotope after `#`"
    i = 2
    while i <= length(right) && isdigit(right[i])
      iso = iso * 10 + parse(Int64, right[i])
      i += 1
    end
    @assert haskey(ATOMIC_SPECIES[atom].mass, iso) "$iso is not a valid isotope of $atom"
    # the rest of the string should be charge
    right = right[i:end]
  end

  # if iso is not specified, use the most abundant isotope
  if iso == 0
    iso = -1
  end

  #now try to parse the charge
  right = replace(right, " " => "") # remove all the spaces
  right = replace(right, "⁺" => "+") # change superscript + to ASCII
  right = replace(right, "⁻" => "-") # change superscript - to ASCII
  charge::Int64 = 0
  chargenum::Int64 = 0
  @assert !(occursin("+", right) && occursin("-", right)) "You cannot have opposite charge in $speciesname"

  #replace all the superscript with number 
  for (k, _) in SUPERSCRIPT_MAP
    right = replace(right, k => string(SUPERSCRIPT_MAP[k]))
  end
  #if the charge is positive
  if occursin("+", right)
    charge = count(r"\+", right)
    #either put the charge symbol in the front or the back
    @assert right[1] == '+' || right[end] == '+' "You should only put the charge symbol in the front or the back of the atomic symbol in $speciesname"
    # remove the charge symbol
    right = replace(right, "+" => "")
    for c in right
      chargenum = chargenum * 10 + parse(Int64, c) #parse the charge number 
    end
    if chargenum == 0 #if the charge number is not specified
      chargenum = 1
    end
    charge *= chargenum
  elseif occursin("-", right) #if the charge is negative
    charge = -count(r"\-", right)
    #either put the charge symbol in the front or the back
    @assert right[1] == '-' || right[end] == '-' "You should only put the charge symbol in the front or the back of the atomic symbol in $speciesname"
    # remove the charge symbol
    right = replace(right, "-" => "")
    for c in right
      chargenum = chargenum * 10 + parse(Int64, c) #parse the charge number 
    end
    if chargenum == 0 #if the charge number is not specified
      chargenum = 1
    end
    charge *= chargenum
  end
  # when the charge symbol is removed, the rest of the string should be a number
  @assert all(isdigit, right) "The charge specification should only include '+', '-' and number"

  if anti
    charge = -charge
  end
  if anti
    return Species("anti-" * atom, charge, iso)
  else
    return Species(atom, charge, iso)
  end

end

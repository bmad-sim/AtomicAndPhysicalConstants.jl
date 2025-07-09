# Package: AtomicAndPhysicalConstants
# file: src/species_initialize.jl
# purpose: define constructors




#####################################################################
#####################################################################

# precompile regEx

const anti_regEx = r"Anti\-|anti\-|Anti|anti"

"""
		subatomic_particle(name::String)

## Description:
Dependence of Particle(name, charge=0, iso=-1)
Create a particle struct for a subatomic particle with name=name
"""
subatomic_particle

function subatomic_particle(name::String)
  # write the particle out directly
  leptons = ["electron", "positron", "muon", "anti-muon"]
  particle = SUBATOMIC_SPECIES[name]
  if name == "photon"
    return Species(name, particle.charge,
      particle.mass,
      particle.spin,
      particle.moment,
      0.0, Kind.PHOTON)
  elseif name in leptons
    return Species(name, particle.charge,
      particle.mass,
      particle.spin,
      particle.moment,
      0.0, Kind.LEPTON)
  else
    return Species(name, particle.charge,
      particle.mass,
      particle.spin,
      particle.moment,
      0.0, Kind.HADRON)
  end
end


#####################################################################
#####################################################################


"""
	Species Struct:

The Species struct is used for keeping track 
of information specifice to the chosen particle.

## Fields:
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
7. `kind::Kind.T': 									 the kind of particle (ATOM, HADRON, LEPTON, PHOTON, NULL)
                                       - NULL kind defines a null particle, which is not a real particle 
                                       - but a placeholder

## Constructors:

This structure has the following constructor

    Species(speciesname::String)

This constructor is used to create a species struct for a subatomic particle or an atomic species by giving the name 
of the particle.

Here are some ways to use this constructor:
1. If the particle is To construct a subatomic species, put the name of the subatomic species in the field name. 
Note that the name must be provided exactly.
2. If the particle is an atomic species, put the atomic symbol in the name along with isotope and charge information.
   - The name of the atomic species should be in the format:
   "mass number" + "atomic symbol" + "charge"
   the mass number in front of the atomic symbol, and the charge at the end.
   - The mass number and charge are optional.
   - The mass number can be in unicode superscript or in ASCII, with an optional "#" in front.
   e.g. 
    Species("¹H") - Hydrogen-1
    Species("1H") - Hydrogen-1
    Species("#1H") - Hydrogen-1
   - if the mass number is not specified, the most abundant isotope will be used.
   - The charge can be in the following formats:
      * "+" represents single positive charge
      * "++" represents double positive charge
      * "+n" or "n+" represents n positive charge, where n can be unicode superscript
      * "-" represents single negative charge
      * "–-" represents double negative charge
      * "-n" or "n-" represents n negative charge, where n can be unicode superscript
    e.g. 
    Species("C+") - Carbon with a single positive charge
    Species("N³⁻") - Nitrogen with a 3 negative charge
   - if charge is not specified, the charge will be 0.
3. To create a null species, use the name "Null" or "null" or "".
4. To create an anti-particle, prepend "anti-" to the name of the particle.
   e.g. Species("anti-H") - Anti-hydrogen
   Species("anti-Fe") - Anti-iron
   Species("anti-positron") - Positron

"""
Species

function SpeciesN(speciesname::String)
  name::String = speciesname
  # if the name is "Null", return a null Species
  if name == "Null" || name == "null" || name == ""
    return Species()
  end

  # by checking for the anti- prefix, we can determine if the particle is an anti-particle
  # anti is true for anti-particles
  anti::Bool = occursin(anti_regEx, name)
  # if the particle is an anti-particle, remove the prefix for easier lookup
  name = replace(name, anti_regEx => "")

  for (k, _) in SUBATOMIC_SPECIES
    # whether the particle is in the subatomic species dictionary
    if occursin(k, name)
      # whether the particle name only contains characters in the subatomic species dictionary
      # delete all the names and spaces, there should be nothing left
      @assert length(k) == length(name)
      "$speciesname should contain only the name of the subatomic particle"
      if anti
        if k == "electron"
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

  function normalize_superscripts(str::String)
    buf = IOBuffer()
    for c in str
      if haskey(SUPERSCRIPT_MAP, c)
        print(buf, SUPERSCRIPT_MAP[c])  # write digit
      elseif c == '⁺' # superscript +
        print(buf, '+')  # write ASCII +
      elseif c == '⁻' # superscript -
        print(buf, '-')  # write ASCII -
      elseif c == ' ' # remove spaces
        continue
      else
        print(buf, c)  # preserve original char
      end
    end
    return String(take!(buf))
  end
  name = normalize_superscripts(name)

  # if the particle is not in the subatomic species dictionary, check the atomic species dictionary
  for k in sorted_list_of_atomic_symbols #  sort by length to find the longest match first
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
  left::String = name[1:index-1]

  iso::Int64 = 0

  #if the user choose to put isotope in the front 
  if left != ""
    #if the left string starts with #, delete the #
    if left[1] == '#'
      left = left[2:end]
    end
    # convert the isotope to an integer
    for c in left
      iso = iso * 10 + parse(Int64, c)
    end
    @assert haskey(ATOMIC_SPECIES[atom].mass, iso) "$iso is not a valid isotope of $atom"
  end

  # if iso is not specified, use the most abundant isotope
  if iso == 0
    iso = -1
  end

  #now try to parse the charge
  right::String = name[index+length(atom):end]
  charge::Int64 = 0
  chargenum::Int64 = 0
  @assert !(occursin("+", right) && occursin("-", right)) "You cannot have opposite charge in $speciesname"

  #if the charge is positive
  if occursin("+", right)
    charge = count(==('+'), right)
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
    charge = -count(==('-'), right)
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
    return create_atomic_species("anti-" * atom, charge, iso)
  else
    return create_atomic_species(atom, charge, iso)
  end

end


"""
    create_atomic_species(name::String, charge::Int, iso::Int)

## Description:
Create a species struct for an atomic species with name=name, charge=charge and iso=iso
## fields:
- `name::String': 				the atomic symbol, must be exact. anti-prefix specifies whether it is an anti-atom
- `charge::Int': 				  the net charge of the particle in units of [e]
- `iso::Int': 					  the mass number of the isotope, -1 for the most abundant isotope
"""
function create_atomic_species(name::String, charge::Int, iso::Int)
  # whether the atom is anti-atom
  anti_atom::Bool = occursin(anti_regEx, name)
  # if the particle is an anti-particle, remove the prefix for easier lookup
  AS::String = replace(name, anti_regEx => "")

  @assert haskey(ATOMIC_SPECIES, AS) "$AS is not a valid atomic species"

  atom::AtomicSpecies = ATOMIC_SPECIES[AS]
  nmass::Float64 = uconvert(u"MeV/c^2", atom.mass[iso]).val
  spin::Float64 = 0.0

  mass::Float64 = begin
    if anti_atom == false
      # ^ mass of the positively charged isotope in eV/c^2
      nmass + __b_m_electron.val * (-charge)
      # ^ put it in eV/c^2 and remove the electrons
    else
      # ^ mass of the positively charged isotope in amu
      nmass + __b_m_electron.val * (+charge)
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



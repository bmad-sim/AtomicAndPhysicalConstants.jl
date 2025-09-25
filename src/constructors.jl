# Package: AtomicAndPhysicalConstants
# file: src/species_initialize.jl
# purpose: define constructors




#####################################################################
#####################################################################

# precompile regEx

const anti_regEx = r"Anti\-|anti\-|Anti|anti"

@doc """
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


function Species(speciesname::String)
  
  
  # if the name is "Null", return a null Species
  if speciesname == "Null" || speciesname == "null" || speciesname == ""
    return Species()
  end

  name::String = speciesname

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
      length(k) == length(name) || "$speciesname should contain only the name of the subatomic particle"
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
  atom != "" || error("you did not specify an atomic species or subatomic species in $speciesname")


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
    haskey(ATOMIC_SPECIES[atom].mass, iso) || error("$iso is not a valid isotope of $atom")
  end

  # if iso is not specified, use the most abundant isotope
  if iso == 0
    iso = -1
  end

  #now try to parse the charge
  right::String = name[index+length(atom):end]
  charge::Int64 = 0
  chargenum::Int64 = 0
  !(occursin("+", right) && occursin("-", right)) || error("You cannot have opposite charge in $speciesname")

  #if the charge is positive
  if occursin("+", right)
    charge = count(==('+'), right)
    #either put the charge symbol in the front or the back
    right[1] == '+' || right[end] == '+' || error("You should only put the charge symbol in the front or the back of the atomic symbol in $speciesname")
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
    right[1] == '-' || right[end] == '-' || error("You should only put the charge symbol in the front or the back of the atomic symbol in $speciesname")
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
  all(isdigit, right) || error("The charge specification should only include '+', '-' and number")

  if anti
    return create_atomic_species("anti-" * atom, charge, iso)
  else
    return create_atomic_species(atom, charge, iso)
  end


end


#####################################################################
#####################################################################
@doc """
    create_atomic_species(name::String, charge::Int, iso::Int)

## Description:
Create a species struct for an atomic species with name=name, charge=charge and iso=iso
## fields:
- `name::String':         the atomic symbol, must be exact. anti-prefix specifies whether it is an anti-atom
- `charge::Int':           the net charge of the particle in units of [e]
- `iso::Int':             the mass number of the isotope, -1 for the most abundant isotope
"""
create_atomic_species

function create_atomic_species(name::String, charge::Int, iso::Int)
  # whether the atom is anti-atom
  anti_atom::Bool = occursin(anti_regEx, name)
  # if the particle is an anti-particle, remove the prefix for easier lookup
  AS::String = replace(name, anti_regEx => "")

  haskey(ATOMIC_SPECIES, AS) || error("$AS is not a valid atomic species")

  atom::AtomicSpecies = ATOMIC_SPECIES[AS]
  nmass::Float64 = uconvert(u"MeV/c^2", atom.mass[iso]).val
  spin::Float64 = 0.0

  mass::Float64 = begin
    if anti_atom == false
      # ^ mass of the positively charged isotope in eV/c^2
      nmass + SUBATOMIC_SPECIES["electron"].mass.val * (-charge)
      # ^ put it in eV/c^2 and remove the electrons
    else
      # ^ mass of the positively charged isotope in amu
      nmass + SUBATOMIC_SPECIES["electron"].mass.val * (+charge)
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



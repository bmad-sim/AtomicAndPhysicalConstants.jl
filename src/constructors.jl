# AtomicAndPhysicalConstants/src/species.jl

include("species_data.jl")

@doc """
    subatomic_particle(name::String)

## Description:
Dependence of Particle(name, charge=0, iso=-1)
Create a particle struct for a subatomic particle with name=name
"""
subatomic_particle

function subatomic_particle(name::String)::Species
  # write the particle out directly

  particle = SUBATOMIC_SPECIES[name]
  if name == "photon"
    return Species(
      name, 
      particle.charge,
      particle.mass,
      particle.spin,
      particle.moment,
      Int(0), 
      Kind.PHOTON)
  elseif name in leptons
    return Species(
      name, 
      particle.charge,
      particle.mass,
      particle.spin,
      particle.moment,
      0, 
      Kind.LEPTON)
  else
    return Species(
      name, 
      particle.charge,
      particle.mass,
      particle.spin,
      particle.moment,
      0, 
      Kind.HADRON)
  end
end


@doc """
    atomic_particle(name::String, charge::Int, iso::Int)

## Description:
Create a species struct for an atomic species with name=name, charge=charge and iso=iso
## fields:
- `name::String':         the atomic symbol, must be exact. anti-prefix specifies whether it is an anti-atom
- `charge::Int':           the net charge of the particle in units of [e]
- `iso::Int':             the mass number of the isotope, -1 for the most abundant isotope
"""
atomic_particle

function atomic_particle(name::String, charge::Int, iso::Int;)

  # whether the atom is anti-atom
  anti_atom::Bool = occursin(anti_regEx, name)
  # if the particle is an anti-particle, remove the prefix for easier lookup
  AS::String = replace(name, anti_regEx => "")

  haskey(ATOMIC_SPECIES, AS) || error("$AS is not a valid atomic species")

  # grab the particular element from the stack
  atom::AtomicSpecies = ATOMIC_SPECIES[AS]
  # convert the mass of the selected isotope from amu to MeV
  nmass::Float64 = atom.mass[iso] * EV_PER_AMU

  spin::Float64 = 0.0

  mass::Float64 = begin
    if anti_atom == false
      nmass + SUBATOMIC_SPECIES["electron"].mass * abs(charge)
      # for a nominal atom, add 1 electron mass for every - charge
    else
      nmass + SUBATOMIC_SPECIES["positron"].mass * abs(charge)
      # for an anti-atom, add 1 positron mass for every + charge
    end
  end
  if iso == -1 # if it's the average, make an educated guess at the spin
    partonum::Float64 = round(atom.mass[iso])
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
    return Species(
      AS, 
      charge, 
      mass,
      spin, 
      0.0, 
      iso, 
      Kind.ATOM
    )
  else
    return Species(
      "anti-" * AS, 
      charge, 
      mass,
      spin, 
      0.0, 
      iso, 
      Kind.ATOM
    )
  end

end



# null constructor
Species() = new("Null", 0, 0.0, 0.0, 0.0, 0, Kind.NULL)

# vector of Null names
const nulls::Vector{String} = ["null", ""]
# anti::Bool = false

left::String = ""
#####################################################################
#####################################################################




function Species(speciesname::String)
  
  
  # if the name is "Null", return a null Species
  if speciesname in nulls
    return Species()
  end

  # name::String = lowercase(speciesname)

  # by checking for the anti- prefix, we can determine if the particle is an anti-particle
  # anti is true for anti-particles
  # anti = occursin(anti_regEx, name)
  # if the particle is an anti-particle, remove the prefix for easier lookup
  # name = replace(name, anti_regEx => "")

  for (k, _) in SUBATOMIC_SPECIES
    # whether the particle is in the subatomic species dictionary
    if k == speciesname
      # whether the particle name only contains characters in the subatomic species dictionary
      # delete all the names and spaces, there should be nothing left
      # length(k) == length(name) || "$speciesname should contain only the name of the subatomic particle"
      # if anti
      #   if k == "electron"
      #     return subatomic_particle("positron")
      #   end
      #   return subatomic_particle("anti-" * k)
      # else
        return subatomic_particle(k)
      # end
    end
  end

  # the atomic symbol
  atom::String = ""
  # the first index of the atomic symbol
  index::Int = 0
  anti = occursin(anti_regEx, speciesname)
  # if the particle is an anti-particle, remove the prefix for easier lookup
  if !anti
    name = speciesname
  else
    name = replace(name, anti_regEx => "")
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

  # default isotope is abundance avg
  iso::Int = -1
  #check for the isotope 
  #if the user choose to put isotope in the front
  if index != 1
    #the substring before the symbol
    left::String = name[1:index-1]

    #if the left string starts with #, delete the #
    if left[1] == '#'
      left = left[2:end]
    end
    # convert the isotope to an integer
    iso = parse(Int, left)
    haskey(ATOMIC_SPECIES[atom].mass, iso) || error("$iso is not a valid isotope of $atom")

  end


  # now try to parse the charge
  right::String = name[index+length(atom):end]
  !(occursin('+', right) && occursin('-', right)) || error("$speciesname has an ambiguously defined charge value.")
  charge::Int = chargeparse(right)
  

  # #if the charge is positive
  # if occursin("+", right)
  #   charge = count(==('+'), right)
  #   #either put the charge symbol in the front or the back
  #   right[1] == '+' || right[end] == '+' || error("You should only put the charge symbol in the front or the back of the atomic symbol in $speciesname")
  #   # remove the charge symbol
  #   right = replace(right, "+" => "")

  #   if right != ""
  #     charge = parse(Int, right)
  #   end


  # elseif occursin("-", right) #if the charge is negative
  #   charge = -count(==('-'), right)
  #   #either put the charge symbol in the front or the back
  #   right[1] == '-' || right[end] == '-' || error("$speciesname has an incorrectly stated charge value.")
  #   # remove the charge symbol
  #   right = replace(right, "-" => "")

  #   if right != ""
  #     charge = -parse(Int, right)
  #   end
  # end
  # # when the charge symbol is removed, the rest of the string should be a number
  # all(isdigit, right) || error("The charge specification should only include '+' or '-', and numerical value.")

  if anti
    return atomic_particle("anti-" * atom, charge, iso)
  else
    return atomic_particle(atom, charge, iso)
  end


end

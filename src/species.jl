# AtomicAndPhysicalConstants/src/species.jl

struct Species
  name::String # name of the particle to track
  charge::Int64 # charge of the particle (important to consider ionized atoms) in [e]
  mass::Float64 # mass of the particle in [eV/c^2]
  spin::Float64 # spin of the particle in [ħ]
  moment::Float64 # magnetic moment of the particle (for now it's 0 unless we have a recorded value)
  iso::Int64 # if the particle is an atomic isotope this is the mass number, otherwise 0
  kind::Kind.T
end


# null constructor
Species() = new("Null", 0, 0.0, 0.0, 0.0, 0, Kind.NULL)

#####################################################################
#####################################################################

# precompile regEx

const anti_regEx = r"Anti\-|anti\-|Anti|anti"


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

  for (k, _) in SUBATOMIC_SPECIES[]
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

  # default isotope is abundance avg
  iso::Int64 = -1

  #if the user choose to put isotope in the front 
  if left != ""
    #if the left string starts with #, delete the #
    if left[1] == '#'
      left = left[2:end]
    end
    # convert the isotope to an integer
    iso = parse(Int64, left)
    haskey(ATOMIC_SPECIES[atom].mass, iso) || error("$iso is not a valid isotope of $atom")
  end



  # now try to parse the charge
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

    right == "" || charge = parse(Int64, right)


  elseif occursin("-", right) #if the charge is negative
    charge = -count(==('-'), right)
    #either put the charge symbol in the front or the back
    right[1] == '-' || right[end] == '-' || error("You should only put the charge symbol in the front or the back of the atomic symbol in $speciesname")
    # remove the charge symbol
    right = replace(right, "-" => "")

    right == "" || charge = -parse(Int64, right)

  end
  # when the charge symbol is removed, the rest of the string should be a number
  all(isdigit, right) || error("The charge specification should only include '+', '-' and number")

  if anti
    return create_atomic_species("anti-" * atom, charge, iso)
  else
    return create_atomic_species(atom, charge, iso)
  end


end

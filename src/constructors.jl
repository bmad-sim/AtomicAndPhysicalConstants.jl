# AtomicAndPhysicalConstants/src/species.jl


@doc """
    subatomic_particle(name::String)

## Description:
sub-constructor for struct Species: subatomic_particle generates a Species object 
for a particle with openPMD identifier 'name'
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
      particle.gspin,
      particle.moment,
      Int(0), 
      Kind.PHOTON)
  elseif name in leptons
    return Species(
      name, 
      particle.charge,
      particle.mass,
      particle.spin,
      particle.gspin,
      particle.moment,
      0, 
      Kind.LEPTON)
  else
    return Species(
      name, 
      particle.charge,
      particle.mass,
      particle.spin,
      particle.gspin,
      particle.moment,
      0, 
      Kind.HADRON)
  end
end


@doc """
    atomic_particle(name::String, charge::Int, iso::Int)

## Description:
sub-constructor for struct Species: atomic_particle generates a Species object 
for an atom with atomic symbol 'name', charge state 'charge', and mass number 'iso'
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
      0.0, 
      iso, 
      Kind.ATOM
    )
  end

end




# vector of Null names
const nulls::Vector{String} = ["null", ""]
# anti::Bool = false

left::String = ""
#####################################################################
#####################################################################



@doc """
# Species Struct:

The Species struct is used for keeping track 
of information specifice to the chosen particle.

## Fields:
1. `name::String':         the name of the particle 

2. `int_charge::Float64':          the net charge of the particle in units of |e|
                                        - bookkeeping only, thus in internal units
                                       - use the 'charge()' function to get the charge 
                                       - in the desired units

3. `mass::Float64':          the mass of the particle in eV/c^2
                                       - bookkeeping only, thus in internal units
                                        - use the 'mass()' function to get the mass 
                                       - in the desired units

4. `spin::Float64':            the spin of the particle in ħ

5. 'gspin::Float64':            the spin g-factor of the particle
                                      - defaults to 0 for atoms.

6. `moment::Float64':            the magnetic moment of the particle in eV/T

7. `iso::Int':                          if the particle is an atomic isotope, this is the 
                                       - mass number, otherwise -1
8. `kind::Kind.T':                    the kind of particle (ATOM, HADRON, LEPTON, PHOTON, NULL)
                                       - NULL kind defines a null particle, which is not a real particle 
                                       - but a placeholder

# Species Constructor:

This structure has the following constructor

    Species(speciesname::String)

This constructor is used to create a species struct for a subatomic particle or an atomic species by giving the name 
of the particle.

### Usage:
1. To construct a subatomic species, put the name of the subatomic species in the field name. 
Note that the name must be provided exactly.
2. If the particle is an atomic species, put the atomic symbol in the name along with isotope and charge information.
   - The name of the atomic species should be in the format: "mass number" + "atomic symbol" + "charge"
   the mass number in front of the atomic symbol, and the charge at the end.
   - The mass number and charge are optional.
   - The mass number can be in unicode superscript or in ASCII, with an optional "#" in front.
   e.g. 
    Species("¹H"): Hydrogen 1, 
    Species("1H"): Hydrogen 1, 
    Species("#1H"): Hydrogen 1
   - if the mass number is not specified, the abundance averaged mass will be used.
   - The charge can be in the following formats:
      * "+" represents single positive charge
      * "++" represents double positive charge
      * "+n" represents n positive charge, where n can be unicode superscript
      * "-" represents single negative charge
      * "–-" represents double negative charge
      * "-n" or "n-" represents n negative charge, where n can be unicode superscript
    e.g. 
    Species("C+"): Carbon with a single positive charge
    Species("N⁻³"): Nitrogen with a 3 negative charge
   - if charge is not specified, the charge will be 0.
3. To create a null species, call Species() with nor arguments, or use the name "Null", "null", or "".
4. To create an anti-particle, prepend "anti-" to the name of the particle.
   e.g. Species("anti-H"): Anti-hydrogen
   Species("anti-Fe"): Anti-iron
   Species("anti-electron"): Positron

"""
function Species(speciesname::String)
  
  
  # if the name is "Null", return a null Species
  if speciesname in nulls
    return Species()
  end


  for (k, _) in SUBATOMIC_SPECIES
    # whether the particle is in the subatomic species dictionary
    if k == speciesname
      return subatomic_particle(k)
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
  if charge > ATOMIC_SPECIES[atom].Z
    error("The element $atom does not contain $charge protons; the particle $atom with charge +$charge is not physical.")
  end

  if anti
    return atomic_particle("anti-" * atom, charge, iso)
  else
    return atomic_particle(atom, charge, iso)
  end


end

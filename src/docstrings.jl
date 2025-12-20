# AtomicAndPhysicalConstants/src/docstrings.jl


#####################################################################
#####################################################################
# docstrings for constructors
#####################################################################
#####################################################################


@doc """
  Species Struct:

The Species struct is used for keeping track 
of information specifice to the chosen particle.

## Fields:
1. `name::String':         the name of the particle 

2. `int_charge::typeof(1u"q")':          the net charge of the particle in units of |e|
                                        - bookkeeping only, thus in internal units
                                       - use the 'charge()' function to get the charge 
                                       - in the desired units

3. `mass::typeof(1.0u"eV/c^2")':          the mass of the particle in eV/c^2
                                       - bookkeeping only, thus in internal units
                                        - use the 'mass()' function to get the mass 
                                       - in the desired units

4. `spin::typeof(1.0u"h_bar")':            the spin of the particle in ħ

5. `moment::typeof(1.0u"eV/T")':            the magnetic moment of the particle in eV/T

6. `iso::Int':                          if the particle is an atomic isotope, this is the 
                                       - mass number, otherwise -1
7. `kind::Kind.T':                    the kind of particle (ATOM, HADRON, LEPTON, PHOTON, NULL)
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


#####################################################################
#####################################################################
# custom base struct docstrings
# (Species struct docs included with constructors)
#####################################################################
#####################################################################

@doc """
SubatomicSpecies 

## Description:
> mutable struct to store all (possibly degenerate) information about a subatomic particle<

## Fields:
- `species_name`      -- String common name for (anti) baryon
- `charge`            -- electric charge on the given particle in units of [e+]
- `mass`              -- mass of the given particle in [eV/c^2]
- `moment`                -- magnetic moment of particle in [eV/T]
- `spin`              -- spin of the particle in [ħ]

## Notes:
some parameters in this struct are likely named constants from PhysicalConstants.jl

## Examples:
- `SubatomicSpecies("neutron", 0, m_neutron, anom_mag_moment_neutron, 0.5)`
- `SubatomicSpecies("pion-", -1, m_pion_charged, 0.0, 0.0)`
"""
SubatomicSpecies


#####################################################################


@doc """
Struct AtomicSpecies

## Description:
> mutable struct to store all (possibly degenerate) information about a particular element<

## Fields:
- `Z`            -- Integer atomic number (i.e. protons in the nucleus)
- `species_name` -- String periodic table symbol for element
- `mass`   -- > Dict{Int, Float64}(isotope::Int, mass::Float64) isotope masses
                   > key -1 refers to the average common atomic mass, other keys refer to 
                   > the number of nucleons present in the isotope <

## Examples:
- `AtomicSpeciesData(3, "Li", Dict(Int, Float64)(-1 => 6.9675, 3 => 3.0308, 4 => 4.02719, 
    5 => 5.012538, 6 => 6.0151228874, 7 => 7.0160034366, 8 => 8.022486246, 9 => 9.02679019, 
    10 => 10.035483, 11 => 11.04372358, 12 => 12.052517, 13 => 13.06263))`
- `AtomicSpeciesData(47, "Ag", Dict(Int, Float64)(-1 => 107.8682, 92 => 92.95033, 
    93 => 93.94373, 94 => 94.93602, 95 => 95.930744, 96 => 96.92397, 97 => 97.92156, 
    98 => 98.9176458, 99 => 99.9161154, 100 => 100.912684, 101 => 101.9117047, 
    102 => 102.9089631, 103 => 103.9086239, 104 => 104.9065256, 105 => 105.9066636, 
    106 => 106.9050916, 107 => 107.9059503, 108 => 108.9047553, 109 => 109.9061102, 
    110 => 110.9052959, 111 => 111.9070486, 112 => 112.906573, 113 => 113.908823, 
    114 => 114.908767, 115 => 115.9113868, 116 => 116.911774, 117 => 117.9145955, 
    118 => 118.91557, 119 => 119.9187848, 120 => 120.920125, 121 => 121.923664, 
    122 => 122.925337, 123 => 123.92893, 124 => 124.93105, 125 => 125.93475, 
    126 => 126.93711, 127 => 127.94106, 128 => 128.94395, 129 => 129.9507))`
"""
AtomicSpecies


#####################################################################
#####################################################################
# Nuts'n'bolts function docstrings
#####################################################################
#####################################################################

@doc """
This definition overrides Base.getproperty to disallow access to 
the Species fields :mass and :charge via the dot syntax, i.e. 
Species.mass or Species.charge"
"""
getproperty

















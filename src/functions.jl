# AtomicAndPhysicalConstants/src/helpers.jl

#####################################################################
# functions that produce the gyromagnetic constants
#####################################################################
"""
    g_spin(species::Species)

Compute and return the value of g_s for a particle in [1/(T*s)] == [C/kg]
For atomic particles, will currently return 0. Will be updated in a future patch
"""
function g_spin(mass, moment, spin, charge)

  m_s = mass * G_PER_EV / 1e3 # mass in kg
  mu_s = moment # magnetic moment in J/T
  spin_s = spin * H_BAR # spin in J*s

  charge_s = charge * E_CHARGE # charge in C

  # kg * ( J / T ) / (C * J * s) === kg / (T * C * s) === 1
  gs = m_s * mu_s / (charge_s * spin_s)
  return gs

end;





#####################################################################
# species struct getter functions
#####################################################################


"""
    nameof(species::Species) -> String

Return the canonical name of `species`.

For subatomic particles the openPMD name is returned unchanged.
For atomic species the name is assembled from the atomic symbol, mass number
(if a specific isotope was requested), and charge state, using the `#mAS±c`
convention:

```julia
nameof(Species("electron"))   # "electron"
nameof(Species("Fe"))         # "Fe"
nameof(Species("4He+2"))      # "#4He+2"
nameof(Species("Li+"))        # "Li+1"
```
"""
function Base.nameof(species::Species)
  if getfield(species, :kind) != Kind.ATOM
    return getfield(species, :name)
  elseif getfield(species, :iso) == -1
    charge = Int(getfield(species, :charge))
    if charge > 0
      return getfield(species, :name) * "+$charge"
    elseif charge < 0
      return getfield(species, :name) * "$charge"
    else
      return getfield(species, :name)
    end
  else
    iso = getfield(species, :iso)
    charge = Int(getfield(species, :charge))
    if charge > 0
      return "#$iso" * getfield(species, :name) * "+$charge"
    elseif charge < 0
      return "#$iso" * getfield(species, :name) * "$charge"
    else
      return "#$iso" * getfield(species, :name)
    end
  end
end

"""
    chargeof(species::Species; C::Bool = false) -> Float64

Return the net charge of `species`.

By default the charge is returned as a (whole-numbered) multiple of the
elementary charge *e*.  Pass `C = true` to convert to coulombs using the
active [`E_CHARGE`](@ref) constant.

# Examples

```julia
chargeof(Species("proton"))       # 1.0
chargeof(Species("electron"))     # -1.0
chargeof(Species("Li+3"))         # 3.0
chargeof(Species("proton"), C=true)   # ≈ 1.602176634e-19
```
"""
function chargeof(species::Species; C::Bool=false)
  !C ? (return getfield(species, :charge)) : (return E_CHARGE * getfield(species, :charge))
end

"""
    massof(species::Species; AMU::Bool = false) -> Float64

Return the rest mass of `species`.

By default the mass is returned in **eV/c²**.  Pass `AMU = true` to return the
mass in atomic mass units (daltons), which is particularly convenient for
atomic species.

# Examples

```julia
massof(Species("electron"))              # 510998.95069  eV/c²
massof(Species("proton"))               # 9.38272089430e8  eV/c²
massof(Species("H"), AMU = true)        # ≈ 1.00794  u
massof(Species("4He"), AMU = true)      # ≈ 4.0026  u
```
"""
function massof(species::Species; AMU::Bool=false)

  !AMU ? (return getfield(species, :mass)) : (getfield(species, :mass) / EV_PER_AMU)
end

"""
    spinof(species::Species) -> Float64

Return the spin of `species` in units of the reduced Planck constant ħ.

# Examples

```julia
spinof(Species("electron"))    # 0.5
spinof(Species("proton"))      # 0.5
spinof(Species("photon"))      # 1.0
```
"""
function spinof(species::Species)
  return getfield(species, :spin)
end

"""
    gspin_of(species::Species; signed::Bool = false) -> Float64

Return the spin g-factor of `species`.

By default the absolute value is returned.  Pass `signed = true` to get the
signed g-factor (negative for particles with a negative gyromagnetic ratio,
such as the electron).

Returns 0 for atomic species, for which no g-factor is stored.

# Examples

```julia
gspin_of(Species("electron"))               # 2.00231930436092
gspin_of(Species("electron"), signed=true)  # -2.00231930436092
gspin_of(Species("proton"))                 # 5.5856946893
gspin_of(Species("H"))                      # 0.0
```
"""
function gspin_of(species::Species; signed::Bool = false)

  !signed ? (return abs(getfield(species, :gspin))) : (return getfield(species, :gspin))
end


"""
    gyromagnetic_anomaly(species::Species) -> Float64

Compute and return the gyromagnetic anomaly

```math
a = \\frac{g - 2}{2}
```

for leptons and hadrons.  Returns `NaN` for photons, atoms, and null species,
since the gyromagnetic anomaly is not defined for them.

# Examples

```julia
gyromagnetic_anomaly(Species("electron"))   # ≈  0.00115965218046
gyromagnetic_anomaly(Species("muon"))       # ≈  0.00116592062
gyromagnetic_anomaly(Species("H"))          # NaN
```
"""
function gyromagnetic_anomaly(species::Species)::Float64
  kind = getfield(species, :kind)
  (kind == Kind.LEPTON || kind == Kind.HADRON) ? (return (gspin_of(species) - 2.0) / 2.0) : (return convert(Float64, NaN))

end


"""
    momentof(species::Species) -> Float64

Return the magnetic dipole moment of `species` in **eV/T**.

Returns 0 for atomic species and the null species (no moment is stored for
these types).

# Examples

```julia
momentof(Species("electron"))   # ≈ -5.7883818060e-5  eV/T
momentof(Species("proton"))     # ≈  8.8043151136e-8  eV/T
momentof(Species("H"))          # 0.0
```
"""
function momentof(species::Species)::Float64
  if getfield(species, :kind) != Kind.ATOM && getfield(species, :kind) != Kind.NULL
    return getfield(species, :moment)
  else return 0.0
  end
end


"""
    iso_of(species::Species) -> Int

Return the mass number (isotope) of `species`.

- For atomic species: the mass number of the requested isotope, or `−1` if the
  abundance-averaged atomic mass was used.
- For subatomic particles: always `0`.

# Examples

```julia
iso_of(Species("3He"))          # 3
iso_of(Species("He"))           # -1  (abundance average)
iso_of(Species("electron"))     # 0
```
"""
function iso_of(species::Species) 
  if getfield(species, :kind) == Kind.ATOM
    return getfield(species, :iso)
  else return 0
  end
end

"""
    kindof(species::Species) -> Kind.T

Return the particle classification of `species` as a `Kind.T` enum value.

Possible values: `Kind.LEPTON`, `Kind.HADRON`, `Kind.PHOTON`, `Kind.ATOM`,
`Kind.NULL`.

# Examples

```julia
kindof(Species("electron"))    # Kind.LEPTON
kindof(Species("proton"))      # Kind.HADRON
kindof(Species("H"))           # Kind.ATOM
kindof(Species("photon"))      # Kind.PHOTON
kindof(Species())              # Kind.NULL
```
"""
function kindof(species::Species)
  return getfield(species, :kind)
end


"""
    atomicnumberof(species::Species) -> Int

Return the atomic number (number of protons) of `species`.

For an anti-atom, returns the *negative* of the atomic number (`-Z`), to
distinguish it from the matter atom of the same symbol.

Throws an error if `species` is not of kind `ATOM`.

# Examples

```julia
atomicnumberof(Species("Fe"))       # 26
atomicnumberof(Species("H+"))       # 1
atomicnumberof(Species("anti-H"))   # -1
atomicnumberof(Species("electron")) # ERROR
```
"""
function atomicnumberof(species::Species)
  if getfield(species, :kind) != Kind.ATOM
    error("Particle species which are not atoms do not have atomic numbers.")
  else
    AS = getfield(species, :name)
    if occursin(anti_regEx, AS)
      AS = replace(AS, anti_regEx => "")
      return -ATOMIC_SPECIES[AS].Z
    else
      return ATOMIC_SPECIES[AS].Z
    end
  end
end


"""
    isnullspecies(species::Species) -> Bool

Return `true` if `species` is a null (placeholder) species, `false` otherwise.

```julia
isnullspecies(Species())           # true
isnullspecies(Species("null"))     # true
isnullspecies(Species("proton"))   # false
```
"""
isnullspecies(species::Species) = getfield(species, :kind) == Kind.NULL

#####################################################################
# Nuts and bolts functionality in more convenient packaging
#####################################################################

"""
    set_release(; year::String = "2022")

Persistently set the CODATA release year used by AtomicAndPhysicalConstants.jl.

The setting is stored via [Preferences.jl](https://github.com/JuliaPackaging/Preferences.jl)
in the active Julia environment and survives across sessions.  A Julia restart
is required for the new constants to take effect.

Valid values for `year`: `"2002"`, `"2006"`, `"2010"`, `"2014"`, `"2018"`,
`"2022"`.  Calling with no arguments resets to the default (`"2022"`).

# Examples

```julia
set_release(year = "2014")
# [ Info: The default CODATA release is now 2014.
#         Restart your Julia session for this change to take effect.

set_release()   # revert to 2022
```

See also: [`RELEASE_YEAR`](@ref).
"""
function set_release(;year::String = "2022")
  if !haskey(CODATA_MAP, year)
    throw(ArgumentError("You have provided an invalid release year: 
                         options are currently 
                         2002, 2006, 2010, 2014, 2018, or 2022."))
  end
  @set_preferences!("release" => year)
  @info("The default CODATA release is now $year. Restart your Julia session for this change to take effect.")
end




import Base: getproperty

function getproperty(obj::Species, field::Symbol)
  
  error("Do not use the 'base.getproperty' syntax to access fields 
  of Species objects: instead use the provided functions; 
  massof, chargeof, spinof, momentof, isotopeof, kindof, or nameof.")

end; export getproperty

"""
    SUPERSCRIPT_MAP
    A dictionary mapping superscript characters to their corresponding integer values.
    This is used to convert superscript numbers in species names to their integer values.
"""
const SUPERSCRIPT_MAP = Dict{Char,Int}(
  '⁰' => 0,
  '¹' => 1,
  '²' => 2,
  '³' => 3,
  '⁴' => 4,
  '⁵' => 5,
  '⁶' => 6,
  '⁷' => 7,
  '⁸' => 8,
  '⁹' => 9,
)

"""
    SUPER_LOOKUP

The inverse of [`SUPERSCRIPT_MAP`](@ref): maps each digit `0`-`9` to its
superscript character. Used by [`find_superscript`](@ref) for O(1) digit
lookup instead of scanning `SUPERSCRIPT_MAP` for a matching value.
"""
const SUPER_LOOKUP = Dict{Int,Char}(v => k for (k, v) in SUPERSCRIPT_MAP)

"""
    find_superscript(num::Int64)

## Description:
Convert an integer to its superscript representation.
This function takes an integer and returns a string containing the corresponding
superscript characters for each digit in the integer.
"""
function find_superscript(num::Int)
  buf = IOBuffer()
  for d in reverse(digits(num))  # most-significant digit first
    print(buf, SUPER_LOOKUP[d])
  end
  return String(take!(buf))
end


"""
    normalize_superscripts(str::String)

Turns a superscript string of digits `str` into a normal string of digits.
"""
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

"""
    chargeparse(c::String)

Turn a user defined string `c` representing atomic charge state into an integer charge state.
"""
function chargeparse(c::String)

  if c == ""
    return 0
  elseif c[1] == '+'
    if c[end] == '+' && length(c) ≤ 3
      return Int(length(c))
    elseif occursin(mag_regEx, c)
      return parse(Int, c)
    else
      error("The given charge $c is not formatted correctly.")
    end
  elseif c[1] == '-'
    if c[end] == '-' && length(c) ≤ 3
      return -1*Int(length(c))
    elseif occursin(mag_regEx, c)
      return parse(Int, c)
    else
      error("The given charge $c is not formatted correctly.")
    end
  else
    error("Charge specifier must begin with '+' or '-'")
  end
end



function Base.show(io::IO, ::MIME"text/plain", species::Species)
  if isnullspecies(species) == true
    print(io, "Species(Null)")
  else
    println(io, "Species: $(getfield(species, :name))")
    println(io, "Charge: $(Int(chargeof(species))) e")
    println(io, "Mass: $(massof(species)) eV/c²")
    println(io, "Spin: $(spinof(species)) ħ")
    println(io, "Moment: $(momentof(species)) eV/T")
    println(io, "G-factor: $(gspin_of(species))")
    if iso_of(species) > 0 
      println(io, "Mass number: $(iso_of(species))")
      println(io, "Atomic Number: $(atomicnumberof(species))")
    end
    println(io, "Kind: $(kindof(species))")
  end

end

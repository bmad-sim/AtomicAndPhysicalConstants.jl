# AtomicAndPhysicalConstants/src/helpers.jl


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

```jldoctest
julia> nameof(Species("electron"))
"electron"

julia> nameof(Species("#4He+2"))
"#4He+2"

julia> nameof(Species("Li+"))      # the charge is always spelled out
"Li+1"

julia> nameof(Species("anti-#4He"))
"anti-#4He"
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
    name = getfield(species, :name)
    # For anti-atoms the stored name is "anti-<symbol>"; the mass-number prefix
    # belongs on the symbol, giving "anti-#<iso><symbol>" (not "#<iso>anti-...").
    if startswith(name, "anti-")
      base = "anti-#$iso" * chopprefix(name, "anti-")
    else
      base = "#$iso" * name
    end
    if charge > 0
      return base * "+$charge"
    elseif charge < 0
      return base * "$charge"
    else
      return base
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

```jldoctest
julia> chargeof(Species("proton"))
1.0

julia> chargeof(Species("electron"))
-1.0

julia> chargeof(Species("Li+3"))
3.0

julia> chargeof(Species("proton"), C = true)   # coulombs
1.602176634e-19
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

```jldoctest
julia> massof(Species("electron"))          # eV/c²
510998.95069

julia> massof(Species("proton"))
9.3827208943e8

julia> massof(Species("H"), AMU = true)     # daltons
1.0079407540557772

julia> massof(Species("#4He"), AMU = true)
4.00260325413
```
"""
function massof(species::Species; AMU::Bool=false)

  !AMU ? (return getfield(species, :mass)) : (getfield(species, :mass) / EV_PER_AMU)
end

"""
    spinof(species::Species) -> Float64

Return the spin of `species` in units of the reduced Planck constant ħ.

For an atomic species this is the **nuclear** spin, taken from the tabulated
NUBASE2020 ground-state values.  Electron spin is not included: the total
angular momentum of an atom depends on its electronic state, which `Species`
does not model.  Ionisation therefore does not change the result, and an
anti-nucleus has the same spin as its mirror.

Returns `NaN` when no spin is defined:

- for an atom given without a mass number (*e.g.* `Species("He")`), because the
  abundance average runs over isotopes with differing spins;
- for the handful of exotic isotopes to which NUBASE assigns no unambiguous
  ground-state spin.

Note that spin is *not* a function of the mass number — nucleons pair off with
opposite spins, so every even-even nucleus has spin 0.

# Examples

```jldoctest
julia> spinof(Species("electron"))
0.5

julia> spinof(Species("photon"))
1.0

julia> spinof(Species("#4He"))     # even-even nucleus
0.0

julia> spinof(Species("#3He+2"))   # ionisation does not change the nucleus
0.5

julia> spinof(Species("He"))       # abundance average, no single value
NaN
```
"""
function spinof(species::Species)
  return getfield(species, :spin)
end

"""
    g_spin(species::Species; signed::Bool = false) -> Float64

Return the spin g-factor of `species`.

By default the absolute value is returned.  Pass `signed = true` to get the
signed g-factor in the convention `mu = g * (e / 2m) * S` with `e > 0`, so the
sign is that of the magnetic moment relative to the spin: negative for the
electron, muon, neutron, and helion, and positive for their antiparticles.

Returns 0 for atomic species, for which no g-factor is stored.

# Examples

```jldoctest
julia> g_spin(Species("electron"))
2.00231930436092

julia> g_spin(Species("electron"), signed = true)
-2.00231930436092

julia> g_spin(Species("positron"), signed = true)
2.00231930436092

julia> g_spin(Species("proton"))
5.5856946893

julia> g_spin(Species("H"))        # atoms carry no g-factor
0.0
```
"""
function g_spin(species::Species; signed::Bool = false)

  !signed ? (return abs(getfield(species, :gspin))) : (return getfield(species, :gspin))
end


"""
    gyromagnetic_anomaly(species::Species) -> Float64

Compute and return the gyromagnetic anomaly

```math
a = \\frac{g_q - 2}{2}, \\qquad g_q = g \\, \\frac{e}{q}
```

for charged leptons and hadrons, where ``g`` is the signed g-factor
([`g_spin`](@ref) with `signed = true`) and ``q`` the particle's charge.
``g_q`` is the g-factor normalized to the particle's own charge,
``\\boldsymbol{\\mu} = g_q \\frac{q}{2m} \\mathbf{S}``, which is the anomaly that
enters the Thomas–BMT spin-precession equation.  Returns `NaN` for neutral
particles (neutron, anti-neutron, neutral pion), for which ``g_q`` is undefined,
and for photons, atoms, and null species.

Dividing by the charge takes care of the sign: the electron (``g < 0``,
``q = -e``) gets the conventional `+0.00115965…`, the same as the positron
(``g > 0``, ``q = +e``).  It also takes care of the doubly charged helion, whose
anomaly is `-4.1841537…` rather than the value `(|g| - 2)/2` would give.

The stored g-factors are all in the convention `mu = g * (e / 2m) * S`, where the
particle's own mass sets the magneton.  For the deuteron, helion, and triton this
required renormalizing the NIST values, which are tabulated against the nuclear
magneton `e*hbar/(2*M_PROTON)`; `G_DEUTERON`, `G_HELION`, and `G_TRITON` carry the
renormalized values (see the [Physical Constants](@ref man-constants) manual page).

# Examples

```jldoctest
julia> gyromagnetic_anomaly(Species("electron"))
0.0011596521804599913

julia> gyromagnetic_anomaly(Species("muon"))
0.0011659206150000934

julia> gyromagnetic_anomaly(Species("deuteron"))
-0.14298726968020148

julia> gyromagnetic_anomaly(Species("helion"))    # doubly charged
-4.184153749832893

julia> gyromagnetic_anomaly(Species("neutron"))   # neutral
NaN
```
"""
function gyromagnetic_anomaly(species::Species)::Float64
  kind = getfield(species, :kind)
  q = getfield(species, :charge)
  (kind == Kind.LEPTON || kind == Kind.HADRON) && q != 0 || return NaN
  g_q = getfield(species, :gspin) / q
  return (g_q - 2.0) / 2.0
end


"""
    momentof(species::Species) -> Float64

Return the magnetic dipole moment of `species` in **eV/T**.

Returns 0 for atomic species and the null species (no moment is stored for
these types).

# Examples

```jldoctest
julia> momentof(Species("electron"))   # eV/T
-5.795094307747843e-5

julia> momentof(Species("proton"))
8.804315114297192e-8

julia> momentof(Species("H"))          # atoms carry no moment
0.0
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

```jldoctest
julia> iso_of(Species("#3He"))
3

julia> iso_of(Species("He"))        # abundance average
-1

julia> iso_of(Species("electron"))  # not an atom
0
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

```jldoctest
julia> kindof(Species("electron"))
Kind.LEPTON = 2

julia> kindof(Species("H"))
Kind.ATOM = 0

julia> kindof(Species())
Kind.NULL = 4
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

```jldoctest
julia> atomicnumberof(Species("Fe"))
26

julia> atomicnumberof(Species("H+"))     # ionisation does not change Z
1

julia> atomicnumberof(Species("anti-H"))
-1
```
"""
function atomicnumberof(species::Species)
  if getfield(species, :kind) != Kind.ATOM
    error("Particle species which are not atoms do not have atomic numbers.")
  else
    AS = getfield(species, :name)
    if startswith(AS, "anti-")
      return -ATOMIC_SPECIES[chopprefix(AS, "anti-")].Z
    else
      return ATOMIC_SPECIES[AS].Z
    end
  end
end


"""
    isnullspecies(species::Species) -> Bool

Return `true` if `species` is a null (placeholder) species, `false` otherwise.

```jldoctest
julia> isnullspecies(Species())
true

julia> isnullspecies(Species("null"))
true

julia> isnullspecies(Species("proton"))
false
```
"""
isnullspecies(species::Species) = getfield(species, :kind) == Kind.NULL

#####################################################################
# Nuts and bolts functionality in more convenient packaging
#####################################################################

"""
    set_release(; year::Union{String,Nothing} = nothing)

Persistently set the CODATA release year used by AtomicAndPhysicalConstants.jl.

The setting is stored via [Preferences.jl](https://github.com/JuliaPackaging/Preferences.jl)
in the active Julia environment and survives across sessions.  A Julia restart
is required for the new constants to take effect.

Valid values for `year` are the keys of `CODATA_MAP`, currently
$(join(sort(collect(keys(CODATA_MAP))), ", ")), each given as a string.  Calling
with no arguments removes the setting, so the package uses its default: the most
recent release it ships, which moves forward when a newer release is added.

# Examples

```julia
set_release(year = "2014")
# [ Info: The default CODATA release is now 2014.
#         Restart your Julia session for this change to take effect.

set_release()   # follow the most recent release again
```

See also: [`RELEASE_YEAR`](@ref).
"""
function set_release(; year::Union{String,Nothing}=nothing)
  if year === nothing
    @delete_preferences!("release")
    @info("The CODATA release now follows the most recent one, currently $_LATEST_RELEASE. Restart your Julia session for this change to take effect.")
    return nothing
  end
  if !haskey(CODATA_MAP, year)
    throw(ArgumentError("You have provided an invalid release year:
                         options are currently
                         $(join(sort(collect(keys(CODATA_MAP))), ", "))."))
  end
  @set_preferences!("release" => year)
  @info("The default CODATA release is now $year. Restart your Julia session for this change to take effect.")
end




import Base: getproperty

function getproperty(obj::Species, field::Symbol)
  
  error("Do not use the '.' syntax to access fields of Species objects:
  instead use the provided accessor functions; nameof, massof, chargeof,
  spinof, momentof, g_spin, gyromagnetic_anomaly, iso_of, atomicnumberof,
  kindof, or isnullspecies.")

end

"""
    SUPERSCRIPT_MAP

A dictionary mapping superscript characters to their corresponding integer
values.  Used to convert superscript mass numbers in species names.
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
    find_superscript(num::Int)

Convert an integer to its superscript representation, returning a string of the
superscript character for each digit of `num`.
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

  isempty(c) && return 0

  if occursin(r"^\++$", c)            # "+", "++", "+++"
    length(c) ≤ 3 || error("The given charge $c is not formatted correctly.")
    return length(c)

  elseif occursin(r"^-+$", c)         # "-", "--", "---"
    length(c) ≤ 3 || error("The given charge $c is not formatted correctly.")
    return -length(c)

  elseif occursin(r"^[+-]\d+$", c)    # "+n" / "-n"
    return parse(Int, c)

  else
    error("The given charge $c is not formatted correctly.")
  end
end



function Base.show(io::IO, ::MIME"text/plain", species::Species)
  if isnullspecies(species) == true
    print(io, "Species(Null)")
  else
    println(io, "Species: $(nameof(species))")
    println(io, "Charge: $(Int(chargeof(species))) e")
    println(io, "Mass: $(massof(species)) eV/c²")
    # spinof returns NaN where no nuclear spin is defined; print that value and say
    # which of the two cases applies, so it does not read as a defect.
    s = spinof(species)
    println(io, if !isnan(s)
      "Spin: $s ħ  # Absolute value from spinof(species)"
    elseif iso_of(species) > 0
      "Spin: NaN (undefined, not assigned in NUBASE2020)"
    else
      "Spin: NaN (undefined, no mass number given)"
    end)
    println(io, "Moment: $(momentof(species)) eV/T")
    println(io, "G-factor: $(g_spin(species))")
    if iso_of(species) > 0 
      println(io, "Mass number: $(iso_of(species))")
      println(io, "Atomic Number: $(atomicnumberof(species))")
    end
    println(io, "Kind: $(kindof(species))")
  end

end

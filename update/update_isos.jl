# AtomicAndPhysicalConstants.jl/update/update_isos.jl
#
# Refresh the isotope masses in `src/species_data.jl` from the NIST table of
# atomic weights and isotopic compositions.
#
# Usage, from the package root:
#
#     julia --project=. update/update_isos.jl
#
# This rewrites the ATOMIC_SPECIES literal in place, replacing only the mass
# dictionaries.  Nuclear spins are carried over unchanged; any isotope NIST has
# added since the last run comes in with a spin of `NaN`, so run
# `update/update_spins.jl` afterwards if the isotope list changed.  Then run the
# test suite.

include(joinpath(@__DIR__, "species_table.jl"))

# NIST does not appear to publish earlier releases of this table, so there is
# only ever the current one to fetch.
const NIST_URL = "https://physics.nist.gov/cgi-bin/Compositions/stand_alone.pl?ele=&ascii=ascii2&isotype=all"


"""
    read_nist(path) -> Vector{Dict{String,Any}}

Read the linearized NIST table into one dictionary per isotope, in file order.

Each isotope is a run of `key = value` lines opening with `Atomic Number`.
Uncertainties are given in parentheses (`1.00782503223(9)`) and are dropped;
a blank value — which is how the table reports an isotope with no natural
abundance — parses as `nothing`.
"""
function read_nist(path::AbstractString)
  isos = Dict{String,Any}[]
  for l in eachline(path)
    parts = split(l, " = ")
    length(parts) == 2 || continue
    key, val = parts[1], parts[2]
    key == "Atomic Number" && push!(isos, Dict{String,Any}())
    isempty(isos) && continue
    if key == "Atomic Number" || key == "Mass Number"
      isos[end][key] = tryparse(Int, val)
    elseif key == "Relative Atomic Mass" || key == "Isotopic Composition"
      isos[end][key] = tryparse(Float64, split(val, '(')[1])
    end
  end
  return isos
end


"""
    build_masses(isos) -> Dict{Int,Dict{Int,Float64}}

Collect the parsed isotopes into a mass dictionary per element, keyed by atomic
number.  Key `-1` holds the abundance-weighted average mass, accumulated in file
order; it stays `0.0` for the elements with no naturally occurring isotope.
"""
function build_masses(isos::Vector{Dict{String,Any}})
  masses = Dict{Int,Dict{Int,Float64}}()
  for iso in isos
    Z, A, m = get(iso, "Atomic Number", nothing), get(iso, "Mass Number", nothing),
    get(iso, "Relative Atomic Mass", nothing)
    (Z === nothing || A === nothing || m === nothing) && continue
    element = get!(() -> Dict{Int,Float64}(-1 => 0.0), masses, Z)
    element[A] = m
    abundance = get(iso, "Isotopic Composition", nothing)
    abundance === nothing || (element[-1] += abundance * m)
  end
  return masses
end


function main(; path=SPECIES_DATA)
  println("downloading $NIST_URL")
  masses = build_masses(read_nist(download(NIST_URL)))
  println("elements parsed: ", length(masses),
    ", isotopes parsed: ", sum(length(m) - 1 for m in values(masses)))

  byZ = read_table(path)
  added, dropped = 0, 0
  for Z in 1:118
    haskey(masses, Z) || error("NIST table has no element with Z = $Z")
    atom = byZ[Z]
    mass = masses[Z]
    # The spins are keyed by the same mass numbers as the masses, so an isotope
    # NIST has added has no spin yet, and one it has dropped takes its spin with
    # it.  The atomic symbol stays as the package has it: NIST names hydrogen's
    # heavy isotopes "D" and "T", which are not keys this package uses.
    spin = Dict{Int,Float64}(A => get(atom.spin, A, NaN) for A in keys(mass) if A != -1)
    added += count(A -> !haskey(atom.spin, A), keys(spin))
    dropped += count(A -> !haskey(spin, A), keys(atom.spin))
    byZ[Z] = Atom(Z, atom.speciesname, mass, spin)
  end

  changed = write_table(byZ; path=path)
  println(changed ? "\nwrote $path" : "\n(no change — the table already matches NIST)")
  if added > 0 || dropped > 0
    println("isotopes added: $added, removed: $dropped")
    added > 0 && println("the added ones have no spin yet — run update/update_spins.jl next")
  end
  println("now run the test suite.")
end

if abspath(PROGRAM_FILE) == @__FILE__
  main()
end

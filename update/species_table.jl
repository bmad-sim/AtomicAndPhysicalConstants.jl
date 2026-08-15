# AtomicAndPhysicalConstants.jl/update/species_table.jl
#
# Shared helpers for the scripts that regenerate the ATOMIC_SPECIES literal in
# src/species_data.jl.  Both `update_isos.jl` (isotope masses, from NIST) and
# `update_spins.jl` (nuclear spins, from NUBASE) rewrite that same literal, so
# reading and emitting it live here: running one script must never reformat the
# data owned by the other.
#
# This file is `include`d by those scripts and is not meant to be run directly.

const SPECIES_DATA = normpath(joinpath(@__DIR__, "..", "src", "species_data.jl"))

# The literal is parsed into a local struct so these scripts do not need the
# package loaded, and so they keep working if the field list changes again.
struct Atom
  Z::Int
  speciesname::String
  mass::Dict{Int,Float64}
  spin::Dict{Int,Float64}
end

const LITERAL_RE = r"const ATOMIC_SPECIES::Dict\{String,AtomicSpecies\} = Dict\(\n.*?\n\);"s


"""
    read_table(path = SPECIES_DATA) -> Dict{Int,Atom}

Parse the current ATOMIC_SPECIES literal, keyed by atomic number.
"""
function read_table(path::AbstractString=SPECIES_DATA)
  m = match(LITERAL_RE, read(path, String))
  m === nothing && error("could not locate the ATOMIC_SPECIES literal in $path")
  body = replace(m.match, "const ATOMIC_SPECIES::Dict{String,AtomicSpecies} = " => "",
    "AtomicSpecies(" => "Atom(")
  atoms = eval(Meta.parse(rstrip(body, [';', '\n'])))::Dict{String,Atom}
  length(atoms) == 118 || error("expected 118 elements in $path, found $(length(atoms))")
  return Dict(a.Z => a for a in values(atoms))
end


_fmt(x::Float64) = isnan(x) ? "NaN" : repr(x)


"""
    write_table(byZ; path = SPECIES_DATA) -> Bool

Rewrite the ATOMIC_SPECIES literal from `byZ`, leaving the rest of the file
alone.  Returns `true` if the file changed; re-running a refresh against
unchanged upstream data is expected to be a no-op.

Both dictionaries are emitted in sorted key order (`-1`, the abundance average,
sorts first).  `Dict` iteration order is not stable across rebuilds, so an
unsorted emission would reshuffle the whole table on every run and bury the real
change in the diff.
"""
function write_table(byZ::Dict{Int,Atom}; path::AbstractString=SPECIES_DATA)
  lines = String[]
  for Z in 1:118
    haskey(byZ, Z) || error("no element with Z = $Z")
    atom = byZ[Z]
    masses = join(("$k => $(_fmt(atom.mass[k]))" for k in sort(collect(keys(atom.mass)))), ", ")
    spins = join(("$k => $(_fmt(atom.spin[k]))" for k in sort(collect(keys(atom.spin)))), ", ")
    push!(lines, "    \"$(atom.speciesname)\" => AtomicSpecies($Z, \"$(atom.speciesname)\", " *
                 "Dict{Int,Float64}($masses), Dict{Int,Float64}($spins)),")
  end

  literal = "const ATOMIC_SPECIES::Dict{String,AtomicSpecies} = Dict(\n" *
            join(lines, "\n") * "\n);"

  text = read(path, String)
  occursin(LITERAL_RE, text) || error("could not locate the ATOMIC_SPECIES literal in $path")
  updated = replace(text, LITERAL_RE => literal, count=1)
  write(path, updated)
  return updated != text
end

# AtomicAndPhysicalConstants.jl/update/update_pion_mass.jl
#
# Refresh the pion masses in every `src/CODATA<year>.jl` from the Particle Data
# Group API.
#
# Usage, from the package root:
#
#     julia --project=. update/update_pion_mass.jl
#
# CODATA does not tabulate the pion masses, so each release file carries the
# PDG values, and the same values in all of them.  This rewrites the
# `M_PION_0` and `M_PION_CHARGED` lines in place and touches nothing else.
# `update_constants.jl` copies these values into a new release file, so after
# a PDG edition run this script first.  Then run the test suite.
#
# The stored value is PDG's fit value (`value` in the API), not the rounded
# summary-table number (`value_text`), with the decimal point moved from MeV to
# eV.

const SRC = normpath(joinpath(@__DIR__, "..", "src"))
const PDG_URL = "https://pdgapi.lbl.gov/summaries/%s"

# field => (PDG particle id, PDG id of its mass property)
const PIONS = [
  :M_PION_0       => ("S009", "S009M"),
  :M_PION_CHARGED => ("S008", "S008M"),
]


"""
    read_pdg_mass(path, pdgid) -> (value, edition)

Read the mass property `pdgid` from a PDG API summary saved at `path`, as the
literal text of its first value, in MeV.  Julia has no JSON parser in its
standard library and the package should not depend on one for a maintainer
script, so the property is located by its id and its fields read with regexes;
anything unexpected is an error rather than a guess.
"""
function read_pdg_mass(path::AbstractString, pdgid::AbstractString)
  text = read(path, String)
  edition = match(r"\"edition\":\s*\"(\d{4})\"", text)
  edition === nothing && error("no PDG edition in $path")
  start = findfirst("\"pdgid\": \"$pdgid\"", text)
  start === nothing && error("no property $pdgid in $path")
  # The property runs until the next one starts.
  stop = findnext("\"pdgid\":", text, last(start) + 1)
  block = text[first(start):(stop === nothing ? lastindex(text) : first(stop) - 1)]
  value = match(r"\"value\":\s*(-?[0-9.]+(?:[eE][-+]?\d+)?)", block)
  unit = match(r"\"unit\":\s*\"([^\"]*)\"", block)
  (value === nothing || unit === nothing) && error("no value or unit for $pdgid in $path")
  unit[1] == "MeV" || error("$pdgid is in $(unit[1]), expected MeV")
  return value[1], edition[1]
end


"""
    shift(s, n) -> Float64

Parse the float literal `s` times `10^n`, by moving its exponent rather than
multiplying, so the result is the correctly rounded value of the decimal.
Same as in `update_constants.jl`.
"""
function shift(s::AbstractString, n::Int)
  parts = split(lowercase(s), 'e')
  exponent = length(parts) == 2 ? parse(Int, parts[2]) : 0
  return parse(Float64, "$(parts[1])e$(exponent + n)")
end


"""
    write_pions(masses; dir = SRC) -> Vector{String}

Replace the pion mass lines in every `CODATA<year>.jl` in `dir`.  Returns the
files that changed.
"""
function write_pions(masses::Dict{Symbol,Float64}; dir::AbstractString=SRC)
  files = filter(f -> occursin(r"^CODATA\d{4}\.jl$", f), readdir(dir))
  isempty(files) && error("no CODATA<year>.jl files in $dir")
  changed = String[]
  for f in files
    path = joinpath(dir, f)
    text = read(path, String)
    updated = text
    for (field, m) in masses
      re = Regex("^$field = .*,\$", "m")
      length(collect(eachmatch(re, updated))) == 1 ||
        error("expected exactly one $field line in $path; edit it by hand")
      updated = replace(updated, re => "$field = $(repr(m)),")
    end
    updated == text && continue
    write(path, updated)
    push!(changed, path)
  end
  return changed
end


function main(; dir::AbstractString=SRC)
  masses = Dict{Symbol,Float64}()
  editions = String[]
  for (field, (particle, pdgid)) in PIONS
    url = replace(PDG_URL, "%s" => particle)
    println("downloading $url")
    value, edition = read_pdg_mass(download(url), pdgid)
    masses[field] = shift(value, 6)
    push!(editions, edition)
    println("  $field = $value MeV (PDG $edition)")
  end
  allequal(editions) || error("the PDG summaries come from different editions: $editions")

  changed = write_pions(masses; dir=dir)
  if isempty(changed)
    println("\n(no change — the release files already match PDG $(editions[1]))")
  else
    println("\nwrote:")
    foreach(p -> println("  ", p), changed)
    println("now run the test suite.")
  end
end

if abspath(PROGRAM_FILE) == @__FILE__
  main()
end

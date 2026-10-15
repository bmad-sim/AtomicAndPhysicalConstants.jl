# AtomicAndPhysicalConstants.jl/update/release_files.jl
#
# Shared helpers for the scripts that write the `src/CODATA<year>.jl` release
# files: `update_constants.jl` (the CODATA values, from NIST) and
# `update_pion_mass.jl` (the pion masses, from PDG).
#
# This file is `include`d by those scripts and is not meant to be run directly.

import Downloads

const SRC = normpath(joinpath(@__DIR__, "..", "src"))


"""
    shift(s, n) -> Float64

Parse the float literal `s` times `10^n`, by moving its exponent rather than
multiplying, so the result is the correctly rounded value of the decimal.
"""
function shift(s::AbstractString, n::Int)
  parts = split(lowercase(s), 'e')
  exponent = length(parts) == 2 ? parse(Int, parts[2]) : 0
  return parse(Float64, "$(parts[1])e$(exponent + n)")
end


#####################################################################
# Pion masses from the PDG
#####################################################################

# CODATA does not tabulate the pion masses.  Each release file carries those of
# the Review of Particle Physics edition with the same year as the release; the
# PDG editions from the years the CODATA releases were published (2005, 2008,
# 2012, 2016, 2019, 2024) give the same values.
#
# The PDG REST API serves only the current edition, so the masses are read from
# PDG's "pdgall" SQLite database, which also holds the Summary Table values of
# every past edition.  Julia's standard library has no SQLite reader, so the
# `sqlite3` command-line tool is used.

const PDG_API_INDEX = "https://pdg.lbl.gov/api"

# field => PDG id of the mass property
const PIONS = [
  :M_PION_0       => "S009M",  # pi0 MASS
  :M_PION_CHARGED => "S008M",  # pi+- MASS
]


"""
    pdg_database() -> path

Download the newest "pdgall" database listed on the PDG API page.
"""
function pdg_database()
  index = read(Downloads.download(PDG_API_INDEX), String)
  files = unique(m[1] for m in eachmatch(r"href=\"(pdgall-(\d{4})[^\"]*\.sqlite)\"", index))
  isempty(files) && error("no pdgall-*.sqlite database listed at $PDG_API_INDEX")
  file = last(sort(files; by=f -> parse(Int, match(r"pdgall-(\d{4})", f)[1])))
  edition = match(r"pdgall-(\d{4})", file)[1]
  url = "https://pdg.lbl.gov/$edition/api/$file"
  println("downloading $url")
  return Downloads.download(url)
end


"""
    pdg_pion_masses(db, editions) -> Dict{Int,Dict{Symbol,Float64}}

The pion masses in eV/c^2 for each edition year in `editions`, read from the
PDG database at `db`.  These are the Summary Table values, which are PDG's fit
values (`value`), not the rounded numbers printed in the table (`value_text`).
"""
function pdg_pion_masses(db::AbstractString, editions)
  sqlite = Sys.which("sqlite3")
  sqlite === nothing && error("the sqlite3 command-line tool is needed to read the PDG database")
  masses = Dict(Int(e) => Dict{Symbol,Float64}() for e in editions)
  for (field, pdgid) in PIONS
    # %.17g prints every digit of the stored double, so the parse is exact.
    query = "select edition, printf('%.17g', value), unit_text from pdgdata " *
            "where pdgid = '$pdgid' and in_summary_table = 1;"
    rows = [split(l, '|') for l in eachline(`$sqlite -readonly -separator '|' $db $query`)]
    for e in editions
      hits = filter(r -> r[1] == string(e), rows)
      length(hits) == 1 || error("expected one Summary Table $pdgid value for the $e edition, found $(length(hits))")
      _, value, unit = hits[1]
      unit == "MeV" || error("$pdgid in the $e edition is in $unit, expected MeV")
      masses[e][field] = shift(value, 6)
    end
  end
  return masses
end

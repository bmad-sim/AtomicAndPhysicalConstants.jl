# AtomicAndPhysicalConstants.jl/update/update_constants.jl
#
# Generate `src/CODATA<year>.jl` from the NIST ASCII table of a CODATA release
# and register it with the package.
#
# Usage, from the package root:
#
#     julia --project=update update/update_constants.jl 2026            # add a release
#     julia --project=update update/update_constants.jl 2018 --force    # regenerate one
#     julia --project=update update/update_constants.jl 2026 --db pdgall-2026.0.sqlite
#
# NIST serves the newest release at Table/allascii.txt and moves it to
# ArchiveASCII/allascii_<year>.txt once a newer one is published, so the archive
# is tried first and the current table is accepted only if its header names the
# requested year.
#
# Adding a release also inserts it into the include list, `CODATA_MAP`, and the
# exports in `src/AtomicAndPhysicalConstants.jl`.  It does not change the
# default release; the script prints the remaining manual steps when it is done.
#
# The pion masses are not CODATA quantities: they are taken from the PDG Review
# of Particle Physics edition of the same year (see release_files.jl).  That
# downloads PDG's historical database, about 70 MB, unless `--db` names a local
# copy.

using AtomicAndPhysicalConstants
include(joinpath(@__DIR__, "release_files.jl"))

const MODULE_FILE = joinpath(SRC, "AtomicAndPhysicalConstants.jl")
const ARCHIVE_URL = "https://physics.nist.gov/cuu/Constants/ArchiveASCII/allascii_%s.txt"
const CURRENT_URL = "https://physics.nist.gov/cuu/Constants/Table/allascii.txt"


"""
    read_codata(path) -> (year, values)

Read a NIST "allascii" table into the release year named in its header and a
dictionary from quantity name to value string.  The value strings are cleaned
to plain Julia float literals: digit-group spaces and the parenthesised
uncertainty that the 2002 and 2006 tables print inline are dropped.  The `...`
that marks an exact value NIST prints truncated is kept, so that `extract` can
tell it apart from a complete one.

The tables are fixed width, but the 2002 and 2006 headers do not line up with
their data, so the value column is taken as the first one after a gap of two or
more spaces, and every row must agree on it.  A name followed by a single space
would otherwise be read as part of the value.
"""
function read_codata(path::AbstractString)
  lines = readlines(path)
  m = match(r"\b(20\d\d)\b", join(first(lines, 5), "\n"))
  m === nothing && error("no release year in the header of $path")
  year = parse(Int, m[1])
  h = findfirst(startswith("-----"), lines)
  h === nothing && error("no column header in $path")
  values = Dict{String,String}()
  vcol = nothing
  for l in lines[h+1:end]
    row = match(r"^(\s*\S.*?)\s{2,}(\S)", l)
    row === nothing && continue
    col = row.offsets[2]
    vcol = something(vcol, col)
    col == vcol || error("value column misaligned in $path:\n$l")
    raw = split(l[col:end], r"\s{2,}")[1]
    values[strip(row[1])] = replace(raw, r"\(\d+\)" => "", " " => "")
  end
  return year, values
end


"""
    fetch_codata(year) -> path

Download the table for `year`, from the archive if it is there and otherwise
from the current table, provided that one is the requested release.
"""
function fetch_codata(year::Int)
  url = replace(ARCHIVE_URL, "%s" => string(year))
  try
    println("downloading $url")
    return Downloads.download(url)
  catch e
    e isa Downloads.RequestError || rethrow()
  end
  println("not in the archive; downloading $CURRENT_URL")
  path = Downloads.download(CURRENT_URL)
  current = read_codata(path)[1]
  current == year || error("NIST has not published the $year release: " *
                           "the archive has no table for it and the current table is $current.")
  return path
end

# The fields of `CODATA_release` taken from the table.  Each names the table
# quantities it is read from, newest name first, and the power of ten that
# brings the tabulated unit to the package's (kg -> g).  NIST renamed a number
# of quantities over the releases; a quantity a release does not tabulate under
# any of the names becomes NaN.
#
# All energies and masses are stored in eV (eV/c^2 for masses).  NIST does not
# tabulate particle masses in eV, only in kg, J, u, and "energy equivalent in
# MeV"; the MeV row is used and moved to eV by `shift(..., 6)`, which is exact,
# so the stored value is NIST's published digits and not a product of two
# rounded quantities.
#
# The exception is an exact value that NIST prints truncated, marked `...`
# (e.g. "1.782 661 921... e-36"): its digits are not the value, so it is derived
# from the release's defining constants by `EXACT` instead.
const FIELDS = [
  :M_ELECTRON         => (["electron mass energy equivalent in MeV"], 6),
  :M_PROTON           => (["proton mass energy equivalent in MeV"], 6),
  :M_NEUTRON          => (["neutron mass energy equivalent in MeV"], 6),
  :M_MUON             => (["muon mass energy equivalent in MeV"], 6),
  :M_HELION           => (["helion mass energy equivalent in MeV"], 6),
  :M_DEUTERON         => (["deuteron mass energy equivalent in MeV"], 6),
  :M_TRITON           => (["triton mass energy equivalent in MeV"], 6),
  :MU_DEUTERON_SI        => (["deuteron mag. mom.", "deuteron magnetic moment"], 0),
  :MU_ELECTRON_SI        => (["electron mag. mom.", "electron magnetic moment"], 0),
  :MU_HELION_SI          => (["helion mag. mom.", "helion magnetic moment"], 0),
  :MU_MUON_SI            => (["muon mag. mom.", "muon magnetic moment"], 0),
  :MU_NEUTRON_SI         => (["neutron mag. mom.", "neutron magnetic moment"], 0),
  :MU_PROTON_SI          => (["proton mag. mom.", "proton magnetic moment"], 0),
  :MU_TRITON_SI          => (["triton mag. mom.", "triton magnetic moment"], 0),
  :AVOGADRO           => (["Avogadro constant"], 0),
  :FINE_STRUCTURE     => (["fine-structure constant"], 0),
  :ANOMALY_ELECTRON   => (["electron mag. mom. anomaly", "electron magnetic moment anomaly"], 0),
  :ANOMALY_MUON       => (["muon mag. mom. anomaly", "muon magnetic moment anomaly"], 0),
  :G_DEUTERON_NUCLEAR_MAGNETON => (["deuteron g factor"], 0),
  :G_ELECTRON         => (["electron g factor"], 0),
  :G_HELION_NUCLEAR_MAGNETON   => (["helion g factor"], 0),
  :G_MUON             => (["muon g factor"], 0),
  :G_NEUTRON_NUCLEAR_MAGNETON => (["neutron g factor"], 0),
  :G_PROTON           => (["proton g factor"], 0),
  :G_TRITON_NUCLEAR_MAGNETON   => (["triton g factor"], 0),
  # The 2002 and 2006 tables list no bare "elementary charge"; 1 eV = e J, so the
  # eV-J relationship is the same number.
  :E_CHARGE           => (["elementary charge", "electron volt-joule relationship"], 0),
  :R_ELECTRON         => (["classical electron radius"], 0),
  :C_LIGHT            => (["speed of light in vacuum"], 0),
  :H_PLANCK           => (["Planck constant in eV/Hz", "Planck constant in eV s"], 0),
  :H_BAR              => (["reduced Planck constant in eV s", "Planck constant over 2 pi in eV s"], 0),
  :K_BOLTZMANN        => (["Boltzmann constant in eV/K"], 0),
  :EPS_0_SI           => (["vacuum electric permittivity", "electric constant"], 0),
  :MU_0_SI            => (["vacuum mag. permeability", "mag. constant", "magnetic constant"], 0),
  :G_PER_AMU          => (["atomic mass unit-kilogram relationship"], 3),
  :EV_PER_AMU         => (["atomic mass unit-electron volt relationship"], 0),
  :J_PER_EV           => (["electron volt-joule relationship"], 0),
  :EV_PER_J           => (["joule-electron volt relationship"], 0),
  :G_PER_EV           => (["electron volt-kilogram relationship"], 3),
]

# The exact values NIST prints truncated, each derived in BigFloat from the
# release's defining constants and rounded once, in the package's units.  Before
# the 2019 SI, mu_0 = 4 pi 1e-7 N/A^2 and eps_0 = 1/(mu_0 c^2) are exact; from
# the 2018 release on, e, h, k, and c are.  `t(name)` is the table's value.
const EXACT = Dict{Symbol,Function}(
  :MU_0_SI     => t -> 4 * big(pi) * big"1e-7",
  :EPS_0_SI    => t -> 1 / (4 * big(pi) * big"1e-7" * t("speed of light in vacuum")^2),
  :H_PLANCK    => t -> t("Planck constant") / t("elementary charge"),
  :H_BAR       => t -> t("Planck constant") / (2 * big(pi) * t("elementary charge")),
  :K_BOLTZMANN => t -> t("Boltzmann constant") / t("elementary charge"),
  :EV_PER_J    => t -> 1 / t("elementary charge"),
  :G_PER_EV    => t -> 1000 * t("elementary charge") / t("speed of light in vacuum")^2,
)


"""
    extract(table) -> (consts, missing)

Read the `FIELDS` from a parsed table, converted to the package's units, and
derive the fields NIST does not tabulate in them.  `missing` lists the fields
that came out NaN.
"""
function extract(table::Dict{String,String})
  consts = Dict{Symbol,Float64}()
  t(name) = parse(BigFloat, table[name])
  for (field, (names, n)) in FIELDS
    i = findfirst(k -> haskey(table, k), names)
    consts[field] = if i === nothing
      NaN
    elseif occursin("...", table[names[i]])
      haskey(EXACT, field) || error("\"$(names[i])\" is printed truncated, and $field has no EXACT rule")
      Float64(EXACT[field](t))
    else
      shift(table[names[i]], n)
    end
  end
  # EPS_0_SI [F/m] and MU_0_SI [N/A^2] are stored as published; src/constants.jl
  # divides and multiplies by E_CHARGE to export them in 1/(eV m) and eV s^2/m.
  consts[:R_PROTON] = consts[:R_ELECTRON] * consts[:M_ELECTRON] / consts[:M_PROTON]
  missing = sort([f for (f, v) in consts if isnan(v)])
  return consts, missing
end


"""
    render(year, consts, missing, pions) -> String

The text of `src/CODATA<year>.jl`, laid out like the hand-written release files.
"""
function render(year::Int, consts::Dict{Symbol,Float64}, missing::Vector{Symbol}, pions)
  v(f) = f in missing ? "NaN,\n# not tabulated in the $year release" : "$(repr(consts[f])),"
  return """
# AtomicAndPhysicalConstants/src/CODATA$year.jl
# Constants pulled from the NIST table of
# the $year CODATA release
# Generated by update/update_constants.jl; masses are NIST's
# "energy equivalent in MeV" values with the decimal point moved to eV.



#####################################################################
# Physical constants
#####################################################################


\"\"\"
    CODATA$year :: CODATA_release

Fundamental constants from the $year CODATA release.

See [NIST CODATA](https://physics.nist.gov/cuu/Constants/) for the
primary source values.
\"\"\"
const CODATA$year = CODATA_release(

#######################################
# constants with dimension [mass]
#######################################


M_ELECTRON = $(v(:M_ELECTRON))
# Electron Mass [eV]/c^2
M_PROTON = $(v(:M_PROTON))
# Proton Mass [eV]/c^2
M_NEUTRON = $(v(:M_NEUTRON))
# Neutron Mass [eV]/c^2
M_MUON = $(v(:M_MUON))
# Muon Mass [eV]/c^2
M_HELION = $(v(:M_HELION))
# Helion Mass He3 nucleus [eV]/c^2
M_DEUTERON = $(v(:M_DEUTERON))
# Deuteron Mass [eV]/c^2
M_TRITON = $(v(:M_TRITON))
# Triton Mass [eV]/c^2

# not tabulated by CODATA; fit values from the $year edition of the
# PDG Review of Particle Physics
M_PION_0 = $(repr(pions[:M_PION_0])),
# uncharged pion mass [eV]/c^2
M_PION_CHARGED = $(repr(pions[:M_PION_CHARGED])),
# charged pion mass [eV]/c^2


#######################################
# constants with dimension [magnetic moment]
#######################################


MU_DEUTERON_SI = $(v(:MU_DEUTERON_SI))
# deuteron magnetic moment in [J/T]
MU_ELECTRON_SI = $(v(:MU_ELECTRON_SI))
# electron magnetic moment in [J/T]
MU_HELION_SI = $(v(:MU_HELION_SI))
# helion magnetic moment in [J/T]
MU_MUON_SI = $(v(:MU_MUON_SI))
# muon magnetic moment in [J/T]
MU_NEUTRON_SI = $(v(:MU_NEUTRON_SI))
# neutron magnetic moment in [J/T]
MU_PROTON_SI = $(v(:MU_PROTON_SI))
# proton magnetic moment in [J/T]
MU_TRITON_SI = $(v(:MU_TRITON_SI))
# triton magnetic moment in [J/T]


#######################################
# dimensionless constants
#######################################


AVOGADRO = $(v(:AVOGADRO))
# Avogadro's constant: Number / mole (exact)
FINE_STRUCTURE = $(v(:FINE_STRUCTURE))
# fine structure constant

ANOMALY_ELECTRON = $(v(:ANOMALY_ELECTRON))
# electron magnetic moment anomaly
ANOMALY_MUON = $(v(:ANOMALY_MUON))
# muon magnetic moment anomaly

G_DEUTERON_NUCLEAR_MAGNETON = $(v(:G_DEUTERON_NUCLEAR_MAGNETON))
# deuteron g factor
G_ELECTRON = $(v(:G_ELECTRON))
# electron g factor
G_HELION_NUCLEAR_MAGNETON = $(v(:G_HELION_NUCLEAR_MAGNETON))
# helion g factor
G_MUON = $(v(:G_MUON))
# muon g factor
G_NEUTRON_NUCLEAR_MAGNETON = $(v(:G_NEUTRON_NUCLEAR_MAGNETON))
# neutron g factor
G_PROTON = $(v(:G_PROTON))
# proton g factor
G_TRITON_NUCLEAR_MAGNETON = $(v(:G_TRITON_NUCLEAR_MAGNETON))
# triton g factor


#######################################
# constants with miscellaneous dimension
#######################################


E_CHARGE = $(v(:E_CHARGE))
# elementary charge [C]
R_ELECTRON = $(v(:R_ELECTRON))
# classical electron radius [m]
R_PROTON = $(v(:R_PROTON))
# classical proton radius [m], R_ELECTRON * M_ELECTRON / M_PROTON
C_LIGHT = $(v(:C_LIGHT))
# speed of light [m/s]
H_PLANCK = $(v(:H_PLANCK))
# Planck's constant [eV*s]
H_BAR = $(v(:H_BAR))
# h_planck/twopi [eV*s]

K_BOLTZMANN = $(v(:K_BOLTZMANN))
#k_B in eV/K

EPS_0_SI = $(v(:EPS_0_SI))
# Permittivity of free space in [F/m]
MU_0_SI = $(v(:MU_0_SI))
# Vacuum permeability in [N/A^2]


G_PER_AMU = $(v(:G_PER_AMU))
# grams per standard atomic mass unit (dalton)

EV_PER_AMU = $(v(:EV_PER_AMU))
# eV/c^2 per standard atomic mass unit (dalton)

J_PER_EV = $(v(:J_PER_EV))
# Joules per eV

EV_PER_J = $(v(:EV_PER_J))
# eV per Joule

G_PER_EV = $(v(:G_PER_EV))
# grams per eV/c^2

RELEASE_YEAR = $year


)

#---------------------------------------------------------------------------------------------------
"""
end


"""
    register(years; path = MODULE_FILE) -> Bool

Rewrite the CODATA include list, `CODATA_MAP`, and the `CODATA<year>` export
line of the module file to cover `years`, sorted.  Returns `true` if the file
changed.
"""
function register(years; path::AbstractString=MODULE_FILE)
  years = sort(unique(years))
  src = read(path, String)
  blocks = [
    r"(include\(\"CODATA\d{4}\.jl\"\)\n)+" =>
      join(["include(\"CODATA$y.jl\")\n" for y in years]),
    r"const CODATA_MAP = Dict\{String,CODATA_release\}\([^)]*\)" =>
      "const CODATA_MAP = Dict{String,CODATA_release}(\n" *
      join(["  \"$y\" => CODATA$y" for y in years], ",\n") * ")",
    r"export CODATA\d{4}(, CODATA\d{4})*" =>
      "export " * join(["CODATA$y" for y in years], ", "),
  ]
  updated = src
  for (re, text) in blocks
    length(collect(eachmatch(re, updated))) == 1 ||
      error("expected exactly one match for $re in $path; edit it by hand")
    updated = replace(updated, re => text)
  end
  updated == src && return false
  write(path, updated)
  return true
end


"""
    todo(year, latest) -> Vector{String}

The edits that adding release `year` leaves to be made by hand.  `latest` is
whether it is the most recent release, and so the new default.
"""
function todo(year::Int, latest::Bool)
  items = [
    "test/values_test.jl: add \"$year\" to the set of release years and to the pion table, " *
    "and to the untabulated table if any field above is NaN",
    "docs/src/codata.md: the supported releases table, the pion mass table, and the " *
    "quantities missing from a release",
    "the release lists in the CODATA_release docstring (src/types.jl), the set_release " *
    "docstring (src/functions.jl), and README.md",
  ]
  latest && append!(items, [
    "test/values_test.jl: the \"Constant Access and Values\" testset checks the default " *
    "release's values; change them to those of $year",
    "the \"currently <year>\" default in docs/src/codata.md and docs/src/constants.md, " *
    "and the year range in docs/src/index.md",
  ])
  return items
end


function main(year::Int; force::Bool=false, db::Union{Nothing,AbstractString}=nothing,
              outdir::AbstractString=SRC, register_release::Bool=true)
  path = joinpath(outdir, "CODATA$year.jl")
  isfile(path) && !force && error("$path exists; pass --force to regenerate it")

  release_year, table = read_codata(fetch_codata(year))
  release_year == year || error("the downloaded table is the $release_year release, not $year")
  consts, missing = extract(table)
  println("quantities parsed: ", length(table))
  isempty(missing) || println("not tabulated in $year, written as NaN: ", join(missing, ", "))

  pions = pdg_pion_masses(db === nothing ? pdg_database() : db, [year])[year]

  known = AtomicAndPhysicalConstants.CODATA_MAP

  write(path, render(year, consts, missing, pions))
  println("wrote $path")

  register_release || return
  years = [parse.(Int, collect(keys(known))); year]
  changed = register(years)
  println(changed ? "registered CODATA$year in $MODULE_FILE" : "CODATA$year was already registered")
  if !haskey(known, string(year))
    latest = year == maximum(years)
    latest && println("\nCODATA$year is the most recent release, so it is now the default for\n" *
                      "every environment that has not set one with set_release.")
    println("\nstill to do by hand:")
    foreach(t -> println("  - ", t), todo(year, latest))
    println("then run the test suite.")
  else
    println("now review the diff and run the test suite.")
  end
end

if abspath(PROGRAM_FILE) == @__FILE__
  i = findfirst(==("--db"), ARGS)
  db = i === nothing ? nothing : ARGS[i+1]
  args = filter(a -> !startswith(a, "--") && a != db, ARGS)
  length(args) == 1 ||
    error("usage: julia --project=update update/update_constants.jl <year> [--force] [--db <pdgall.sqlite>]")
  main(parse(Int, args[1]); force="--force" in ARGS, db=db)
end

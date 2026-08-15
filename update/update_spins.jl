# AtomicAndPhysicalConstants.jl/update/update_spins.jl
#
# Refresh the ground-state nuclear spins in `src/species_data.jl` from NUBASE.
#
# Nuclear spin cannot be computed from the mass number — nucleons pair off with
# opposite spins, so every even-even nucleus has spin 0 — and so it has to be
# tabulated.  NUBASE is the evaluated compilation that carries these values.
#
# Usage, from the package root:
#
#     julia --project=. update/update_spins.jl
#
# This rewrites the ATOMIC_SPECIES literal in place, keeping every mass exactly as
# it was and replacing only the spin dictionaries.  Run the test suite afterwards.

include(joinpath(@__DIR__, "species_table.jl"))

const NUBASE_URL = "https://www-nds.iaea.org/amdc/ame2020/nubase_4.mas20.txt"


"""
    parse_jpi(raw) -> (J, quality)

Parse the NUBASE `Jpi` field (columns 89:102) into a spin.

`quality` is `:measured`, `:tentative` (NUBASE parenthesises an uncertain
assignment), `:systematics` (`#`, estimated from neighbouring nuclei), or
`:unknown`.  `J` is `NaN` whenever NUBASE gives no single unambiguous value.
"""
function parse_jpi(raw::AbstractString)
  s = strip(raw)
  isempty(s) && return (NaN, :unknown)

  # Drop the isospin annotation, e.g. "0+      T=1".
  s = strip(split(s, "T=")[1])
  isempty(s) && return (NaN, :unknown)

  quality = occursin('#', s) ? :systematics :
            occursin('(', s) ? :tentative : :measured
  s = strip(replace(s, '*' => "", '#' => "", '(' => "", ')' => ""))

  # Ambiguous assignments list several candidates ("1/2+,3/2+", "1 TO 4"); these
  # carry no single value, so report them as unknown rather than picking one.
  (occursin(',', s) || occursin(" TO ", uppercase(s)) || occursin(" OR ", uppercase(s))) &&
    return (NaN, :unknown)

  s = strip(replace(s, r"[+-]\s*$" => ""))   # strip the parity sign
  isempty(s) && return (NaN, :unknown)

  J = if occursin('/', s)
    parts = split(s, '/')
    length(parts) == 2 || return (NaN, :unknown)
    n, d = tryparse(Float64, parts[1]), tryparse(Float64, parts[2])
    (n === nothing || d === nothing || d == 0) && return (NaN, :unknown)
    n / d
  else
    v = tryparse(Float64, s)
    v === nothing && return (NaN, :unknown)
    v
  end

  (J < 0 || !isfinite(J)) && return (NaN, :unknown)
  return (J, quality)
end


"""
    read_nubase(path) -> Dict{(Z, A), (J, quality)}

Read ground-state entries only.  Column 8 of the `ZZZi` field is the isomer
index; `i == 0` is the ground state.  Z = 0 (the free neutron) is skipped, as it
is not an element.
"""
function read_nubase(path::AbstractString)
  out = Dict{Tuple{Int,Int},Tuple{Float64,Symbol}}()
  for line in eachline(path)
    startswith(line, '#') && continue
    length(line) < 102 && continue
    line[8] == '0' || continue
    A = tryparse(Int, strip(line[1:3]))
    Z = tryparse(Int, strip(line[5:7]))
    (A === nothing || Z === nothing || Z == 0) && continue
    out[(Z, A)] = parse_jpi(line[89:102])
  end
  return out
end


function main(; path = SPECIES_DATA)
  println("downloading $NUBASE_URL")
  nub = read_nubase(download(NUBASE_URL))
  println("ground states parsed: ", length(nub))

  byZ = read_table(path)
  stats = Dict(:measured => 0, :tentative => 0, :systematics => 0, :unknown => 0, :absent => 0)
  for Z in 1:118
    atom = byZ[Z]
    # The spins are keyed by the same mass numbers as the masses, which NIST
    # owns; `update_isos.jl` is what adds or removes an isotope.
    spin = Dict{Int,Float64}()
    for A in keys(atom.mass)
      A == -1 && continue
      J, q = get(nub, (Z, A), (NaN, :absent))
      stats[q] += 1
      spin[A] = J
    end
    byZ[Z] = Atom(Z, atom.speciesname, atom.mass, spin)
  end

  changed = write_table(byZ; path = path)
  println(changed ? "\nwrote $path" : "\n(no change — the table already matches NUBASE)")

  println("\nisotopes written: ", sum(values(stats)))
  for q in (:measured, :tentative, :systematics, :unknown, :absent)
    println("  ", rpad(q, 13), stats[q])
  end
  println("\nnow run the test suite.")
end

if abspath(PROGRAM_FILE) == @__FILE__
  main()
end

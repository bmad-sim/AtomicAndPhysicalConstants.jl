# AtomicAndPhysicalConstants.jl/update/update_pion_mass.jl
#
# Set the pion masses in every `src/CODATA<year>.jl` to those of the PDG
# Review of Particle Physics edition of the same year.
#
# Usage, from the package root:
#
#     julia --project=. update/update_pion_mass.jl
#     julia --project=. update/update_pion_mass.jl --db pdgall-2026.0.sqlite
#
# Without `--db` this downloads PDG's historical database (about 70 MB); pass a
# local copy to skip that.  Needs the `sqlite3` command-line tool.  This
# rewrites the `M_PION_0` and `M_PION_CHARGED` lines in place and touches
# nothing else.  `update_constants.jl` sets the pion masses of a release it
# writes the same way, so this is only needed if PDG revises a past edition.
# Then run the test suite.

include(joinpath(@__DIR__, "release_files.jl"))


"""
    write_pions(masses; dir = SRC) -> Vector{String}

Replace the pion mass lines in every `CODATA<year>.jl` in `dir` with
`masses[year]`.  Returns the files that changed.
"""
function write_pions(masses::Dict{Int,Dict{Symbol,Float64}}; dir::AbstractString=SRC)
  changed = String[]
  for year in sort(collect(keys(masses)))
    fields = masses[year]
    path = joinpath(dir, "CODATA$year.jl")
    text = read(path, String)
    updated = text
    for (field, m) in fields
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


function main(; db::Union{Nothing,AbstractString}=nothing, dir::AbstractString=SRC)
  years = sort([parse(Int, m[1]) for m in (match(r"^CODATA(\d{4})\.jl$", f) for f in readdir(dir))
                if m !== nothing])
  isempty(years) && error("no CODATA<year>.jl files in $dir")
  masses = pdg_pion_masses(something(db, pdg_database()), years)
  for y in years
    println("  CODATA$y <- PDG $y: M_PION_0 = $(masses[y][:M_PION_0]), ",
            "M_PION_CHARGED = $(masses[y][:M_PION_CHARGED]) eV/c^2")
  end

  changed = write_pions(masses; dir=dir)
  if isempty(changed)
    println("\n(no change — the release files already match PDG)")
  else
    println("\nwrote:")
    foreach(p -> println("  ", p), changed)
    println("now run the test suite.")
  end
end

if abspath(PROGRAM_FILE) == @__FILE__
  i = findfirst(==("--db"), ARGS)
  main(; db=i === nothing ? nothing : ARGS[i+1])
end

"""downloadisos() downloads the current  \n\
ascii table of isotopic data as NIST  \n\
doesn't appear to make old releases  \n\
available"""
downloadisos

function downloadisos()
  url = "https://physics.nist.gov/cgi-bin/Compositions/stand_alone.pl?ele=&ascii=ascii2&isotype=all"
  path = download(url)
  return path
end;


"""getisos(path::String) opens the file at  \n\
path (which is expected to be a linearized table  \n\
of isotopes from NIST) and writes the information  \n\
for each isotope to a dictionary. The function  \n\
returns a vector containing all these dictionaries  \n\
for further processing."""
getisos

function getisos(path::String)
  f = open(path)
  everyline = readlines(f)
  isos = []
  i = 0
  for l in everyline
    line = split(l, " = ")
    if line[1] == "Atomic Number"
      i += 1
      push!(isos, Dict{String,Any}(line[1] => tryparse(Int64, line[2])))
    elseif line[1] == "Atomic Symbol"
      isos[i][line[1]] = line[2]
    elseif line[1] == "Mass Number"
      isos[i][line[1]] = tryparse(Int64, line[2])
    elseif line[1] == "Relative Atomic Mass"
      ram = split(line[2], '(')[1]
      isos[i][line[1]] = tryparse(Float64, ram) # get mass in amu
    elseif line[1] == "Isotopic Composition"
      num = split(line[2], '(')[1]
      isos[i][line[1]] = tryparse(Float64, num)
    end
  end
  return isos
end;



"""buildIsoDict(List::Vector{Any}) takes the list  \n\
of individual isotopes and builds a dictionary of  \n\
the elements with each of their isotopes listed  \n\
by mass, as well as the isotopic average mass:  \n\
specifically what is written out is a dictionary  \n\
with Atomic Numbers as keys, and AtomicSpecies  \n\
structs as values"""
buildIsoDict

function buildIsoDict(List::Vector{Any})
  Elements = Dict{Int64,AtomicSpecies}()

  for isotope in List
    # first check if the list has an entry for the appropriate element
    if haskey(Elements, isotope["Atomic Number"]) == false
      # if not, create one
      (Elements[isotope["Atomic Number"]] =
        AtomicSpecies(
          isotope["Atomic Number"],
          isotope["Atomic Symbol"],
          Dict(-1 => 0, isotope["Mass Number"] => isotope["Relative Atomic Mass"])))
      # update the average mass entry
      if typeof(isotope["Isotopic Composition"]) == Float64
        (Elements[isotope["Atomic Number"]].mass[-1] +=
          isotope["Isotopic Composition"] * isotope["Relative Atomic Mass"])
      end

    else # if the element exists, update the list of isotopes
      (Elements[isotope["Atomic Number"]].mass[isotope["Mass Number"]] =
        isotope["Relative Atomic Mass"])
      if typeof(isotope["Isotopic Composition"]) == Float64
        (Elements[isotope["Atomic Number"]].mass[-1] +=
          isotope["Isotopic Composition"] * isotope["Relative Atomic Mass"])
      end
    end
  end
  return Elements
end;


"""writeisos(Elements::Dict{Int64, AtomicSpecies}) takes \n\
as input a dictionary of the elements with nuclear charges \n\
as keys, and writes the same dictionary with the keys swapped \n\
for the atomic symbol (eg "H", "He", etc.) to a file named \n\
yyyy-mm-dd_AtomicSpecies.jl located in the src folder."""
writeisos

function writeisos(Elements::Dict{Int64,AtomicSpecies})
  date = today()

  Z_eles = 1:1:118
  topmat = f"""\n# AtomicAndPhysicalConstants.jl/src/{date}_isotopes.jl\n\n\n"""
  brek = """#########################################################\n\n\n"""
  qs = '"'
  docplus = qs * qs * qs * """ATOMIC_SPECIES \n\
        Isotopes from NIST data $date \n\
        a dictionary of all the available atomic species, \n\
        with all the NIST isotopes included; \n\
        the key is the element's atomic symbol \n\
        n the periodic table, and the value is the relevant \n\
        AtomicSpecies struct, _eg_  \n\
          \n\
        ATOMIC_SPECIES["He"] = AtomicSpecies(2, "He", ...)""" * qs * qs * qs * " ATOMIC_SPECIES \n\
                \n\
                ATOMIC_SPECIES = Dict{String, AtomicSpecies}(\n"

  f = open(pwd() * f"/src/{date}_isotopes.jl", "w")
  write(f, topmat)
  write(f, brek)
  write(f, docplus)
  for Z in Z_eles
    sym = Elements[Z].species_name
    nlen = length(sym)
    space = repeat(" ", 7 - nlen)

    atom_entry = qs * Elements[Z].species_name * qs * space#*f"=>    {Elements[Z]}"
    atom_entry *= f"=>    AtomicSpecies({Elements[Z].Z},"
    atom_entry *= f""" "{Elements[Z].species_name}", """
    atom_entry *= "Dict{}("
    for (k, v) in Elements[Z].mass
      atom_entry *= f"""{k} => {v}*u"amu", """
    end
    atom_entry *= "))"
    write(f, atom_entry)

    if Z < 118
      write(f, ",\n\n")
    else
      write(f, "\n); export ATOMIC_SPECIES")
    end
  end

  close(f)

end;


"""setisos() uses the functions \n\
downloadisos(), \n\
getisos(path), \n\
buildIsoDict(List), and \n\
writeisos(Elements) \n\
to write a Julia file containing a \n\
usable dictionary of each element  \n\
with all of their isotopes"""
setisos

function setisos()
  # println(eV_per_amu)
  path = downloadisos()
  vec = getisos(path)
  numdict = buildIsoDict(vec)
  writeisos(numdict)
end;



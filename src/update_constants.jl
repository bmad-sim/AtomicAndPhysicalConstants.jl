

"""
    CODATA_Consts

This is a dictionary that associates 
named constants in any CODATA release to 
their stored values; it's used to store  
fetched values so they can be written to 
file"""
CODATA_Consts

CODATA_Consts = Dict{AbstractString,Dict{}}(
	"electron mass energy equivalent in MeV" => Dict("__b_m_electron" => __b_m_electron),
	"proton mass energy equivalent in MeV" => Dict("__b_m_proton" => __b_m_proton),
	"neutron mass energy equivalent in MeV" => Dict("__b_m_neutron" => __b_m_neutron),
	"muon mass energy equivalent in MeV" => Dict("__b_m_muon" => __b_m_muon),
	"helion mass energy equivalent in MeV" => Dict("__b_m_helion" => __b_m_helion),
	"deuteron mass energy equivalent in MeV" => Dict("__b_m_deuteron" => __b_m_deuteron),
	"speed of light in vacuum" => Dict("__b_c_light" => __b_c_light),
	"Planck constant in eV/Hz" => Dict("__b_h_planck" => __b_h_planck),
	"classical electron radius" => Dict("__b_r_e" => __b_r_e),
	"Avogadro constant" => Dict("__b_N_avogadro" => __b_N_avogadro),
	"vacuum electric permittivity" => Dict("__b_eps_0_vac" => __b_eps_0_vac),
	"vacuum mag. permeability" => Dict("__b_mu_0_vac" => __b_mu_0_vac),
	"fine-structure constant" => Dict("__b_fine_structure" => __b_fine_structure),
	"deuteron mag. mom." => Dict("__b_mu_deuteron" => __b_mu_deuteron),
	"electron mag. mom." => Dict("__b_mu_electron" => __b_mu_electron),
	"helion mag. mom." => Dict("__b_mu_helion" => __b_mu_helion),
	"muon mag. mom." => Dict("__b_mu_muon" => __b_mu_muon),
	"neutron mag. mom." => Dict("__b_mu_neutron" => __b_mu_neutron),
	"proton mag. mom." => Dict("__b_mu_proton" => __b_mu_proton),
	"triton mag. mom." => Dict("__b_mu_triton" => __b_mu_triton),
	"elementary charge" => Dict("__b_e_charge" => __b_e_charge),
	"atomic mass unit-kilogram relationship" => Dict("__b_kg_per_amu" => __b_kg_per_amu),
	"atomic mass unit-electron volt relationship" => Dict("__b_eV_per_amu" => __b_eV_per_amu),
	"electron volt-joule relationship" => Dict("__b_J_per_eV" => __b_J_per_eV)
); export CODATA_Consts



"""
     downloadCODATA(year::Int)

Takes the desired year of the release as an argument,
then downloads the ascii table of fundamental physical constants and 
returns the path to the local copy"""
downloadCODATA

function downloadCODATA(year::Int)
	myYear = year
	NIST_releases = [1969, 1973, 1986, 1998, 2002, 2006, 2010, 2014, 2018, 2022]
	ixyear = findmin(myYear .- NIST_releases)
	year = NIST_releases[ixyear[2]]
	if ixyear[1] != 0
			println(f"The year requested isn't available: downloading the {year} CODATA release instead.")
	end
	if year != 2022
			url = "https://physics.nist.gov/cuu/Constants/ArchiveASCII/allascii_" * string(year) * ".txt"
	else
			url = "https://physics.nist.gov/cuu/Constants/Table/allascii.txt"
	end
	path = download(url)
	return path
end; 


"""
    getCODATA(path::String, CODATA_Consts::Dict)

accesses the file at "path" (which is expected to be 
the ascii table of CODATA constants) and 
tries to extract the constants named in the 
dictionary CODATA_Consts and write them to 
that same dictionary"""
getCODATA

function getCODATA(path::String, CODATA_Consts::Dict)
	f = open(path)
	everyline = readlines(f)
	for l in everyline
		line = split(l, "  ")
		sp = findall(x -> x == "", line)
		line = deleteat!(line, sp)
		if length(line) != 0
			if haskey(CODATA_Consts, line[1]) == true
				if occursin(' ', line[2]) == true
						line[2] = replace(line[2], ' ' => "")
				end
				if occursin("...", line[2]) == true
						line[2] = replace(line[2], "..." => "")
				end

				if occursin("elementary", line[1]) == true
					CODATA_Consts[line[1]][first(keys(CODATA_Consts[line[1]]))] = parse(Float64, line[2])*u"C"
					# println("1")
				elseif occursin("speed", line[1]) == true
					CODATA_Consts[line[1]][first(keys(CODATA_Consts[line[1]]))] = parse(Float64, line[2])*u"m/s"
					# println("2")
				elseif occursin("radius", line[1]) == true
					CODATA_Consts[line[1]][first(keys(CODATA_Consts[line[1]]))] = parse(Float64, line[2])*u"m"
					# println("3")
				elseif occursin("permittivity", line[1]) == true
					CODATA_Consts[line[1]][first(keys(CODATA_Consts[line[1]]))] = parse(Float64, line[2])*u"F/m"
					# println("4")
				elseif occursin("permeability", line[1]) == true
					# println("5")
					CODATA_Consts[line[1]][first(keys(CODATA_Consts[line[1]]))] = parse(Float64, line[2])*u"N/A^2"
				elseif occursin("Planck", line[1]) == true
					# println("6")
					CODATA_Consts[line[1]][first(keys(CODATA_Consts[line[1]]))] = parse(Float64, line[2])*u"eV/Hz"
				elseif occursin("mag. mom.", line[1]) == true
					# println("7")
					CODATA_Consts[line[1]][first(keys(CODATA_Consts[line[1]]))] = parse(Float64, line[2])*u"J/T"
				elseif occursin("mass energy", line[1]) == true
					# println("8")
					CODATA_Consts[line[1]][first(keys(CODATA_Consts[line[1]]))] = parse(Float64, line[2])*u"MeV/c^2"
				elseif occursin("relationship", line[1]) == true
					# println("9")
					if occursin("kilogram", line[1]) == true
						# println("a")
						CODATA_Consts[line[1]][first(keys(CODATA_Consts[line[1]]))] = parse(Float64, line[2])*u"kg/amu"
					elseif occursin("joule", line[1]) == true
						# println("b")
						CODATA_Consts[line[1]][first(keys(CODATA_Consts[line[1]]))] = parse(Float64, line[2])*u"(eV/c^2)/amu"
					else
						# println("b")
						CODATA_Consts[line[1]][first(keys(CODATA_Consts[line[1]]))] = parse(Float64, line[2])*u"J/eV"
					end
				else
					CODATA_Consts[line[1]][first(keys(CODATA_Consts[line[1]]))] = parse(Float64, line[2])

				end
			end
		end
	end
	close(f)
	return CODATA_Consts
end; 



"""
    writeCODATA(year::Int, new_consts)

writes a julia file called
"yyyy_constants.jl", where yyyy is the year
of the release. The contents of this
file are the fundamental constants extracted
from the CODATA set of the year given in the
argument"""
writeCODATA

function writeCODATA(year::Int, new_consts)
	yearregex = r"[1-2][0-9][0-9][-0-9]"
	f = open(pwd() * "/src/physical_constants.jl", "r")
	everyline = readlines(f)
	newf = open(pwd() * f"/src/{year}_constants.jl", "a+")
	newlines = []

	# add th pion masses to the list
	pion_masses = download_pdg_pion_masses()
	new_consts["Neutral pion mass equivalent in MeV"] = Dict{}("__b_m_pion_0" => pion_masses[1])
	new_consts["Charged pion mass equivalent in MeV"] = Dict{}("__b_m_pion_charged" => pion_masses[2])
	for l in everyline

		if match(r"CODATA", l) !== nothing
			line = ["#", "the", f"{year}", "CODATA release"]
			push!(newlines, line)
				continue
		end
		if split(l) == SubString{String}[]
			line = "\n"
			push!(newlines, line)
			continue
		else
			line = split(l)
		end


		for (k, v) in new_consts
			# eqspace = repeat(" ", 28 - length(first(keys(v))))
			if size(line, 1) >= 1
				if line[1] == first(keys(v))
					line = [line[1]]
					push!(line, eqspace * "= " * f"{v[first(keys(v))]}")
					break

				elseif line[1] == "__b_m_pion_0"
					line = [line[1]]
					push!(line, eqspace * "= " * f"{pion_masses[1]}")
				elseif line[1] == "__b_m_pion_charged"
					line = [line[1]]
					push!(line, eqspace * "= " * f"{pion_masses[2]}")
				end
			end
		end
		push!(newlines, line)
	end

	seekstart(newf)
	
	newlines[1] = ["#", f"AtomicAndPhysicalConstants/src/{year}_constants.jl"]
	for line in newlines
		if length(line) >= 1
			if line == "\n"
				println(newf, "\n")
			elseif line[1] == "#"
				line = join(pushfirst!(line, repeat(" ", 28)), " ")
				println(newf, line)
			else
				newl = join(line, " ")
				println(newf, newl)
			end
		end
	end
	close(f)
	close(newf)
end;



"""
    setCODATA(year::Int)

Combines the functions
`downloadCODATA`
`getCODATA`, and
`writeCODATA`
to do a complete fetch of the updated
CODATA constants and stores them in a
Julia code file in the src directory"""
setCODATA

function setCODATA(year::Int)
    table_path = downloadCODATA(year)
    new_consts = getCODATA(table_path, CODATA_Consts)
    writeCODATA(year, new_consts)

end;


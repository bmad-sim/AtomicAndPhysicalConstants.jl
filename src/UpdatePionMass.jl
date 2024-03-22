
# Including packages
import Pkg; 
Pkg.add("HTTP")
Pkg.add("JSON")
using HTTP
using JSON

"""
pdg_pion_masses() gets the masses of pion from Particle Data Group.
It returns the mass of pion 0, pion +- in order as a tuple, the unit is eV/c^2
"""
function download_pdg_pion_masses()
    # data of pi0, pi+- mass are stored in S009M, S008M json file
    # return the mass of pion 0, pion +-, converting the units to eV/c^2
    return [download_values("S009M")*10^6,download_values("S009M")*10^6] 

end

"""
download_values() downloads the value stores in 'pdgid' jason file from Particle Data Group
"""
function download_values(pdgid::AbstractString)
    url = "https://pdgapi.lbl.gov/summaries/"*pdgid
    response = HTTP.get(url)
    info = JSON.parse(String(response.body))
    return info["pdg_values"][1]["value"]
end

export download_pdg_pion_masses

"""
pdg_pion_masses() gets the masses of pion from Particle Data Group.
It returns the mass of pion 0, pion +, pion - in order as a tuple, the unit is eV/c^2
"""
function download_pdg_pion_masses()
    # extracting informations from the S009 json file
    url = "https://pdgapi.lbl.gov/summaries/S009"
    response = HTTP.get(url)
    info = JSON.parse(String(response.body))

    # the dictionary that maps the name of the particle to the mass unit is eV/c^2
    mass = Dict{String, Float64}()

    # the information of the mass is only at 1
    for i in [1]
        mass[info["summaries"]["properties"][i]["description"]] = info["summaries"]["properties"][i]["pdg_values"][1]["value"]
    end

    # extracting informations from the S008 json file
    url = "https://pdgapi.lbl.gov/summaries/S008"
    response = HTTP.get(url)
    info= JSON.parse(String(response.body))

    # the information of the mass is only at 1
    for i in [1]
        mass[info["summaries"]["properties"][i]["description"]] = info["summaries"]["properties"][i]["pdg_values"][1]["value"]
    end

    # return the mass of pion 0, pion +, pion -
    return [mass["pi0 MASS"]*u"MeV/c^2",mass["pi+- MASS"]*u"MeV/c^2"] 

end
"""
    showconst(
        query::Symbol = :constants
    )

## Description:
list available constants in the package

## parameters:
- `query`     -- type:`Symbol`, the type of constants you want to know about

## options:
- `:constants`      -- list all physical constants
- `:subatomic`      -- list all possible subatomic particles
- `:(atomic symbol)`-- list all isotopes of that atomic species, e.g. :Fe

"""
showconst

function showconst(query::Symbol=:constants)
    # list all the physical constants and their values
    if (query == :constants)
        for (key, dict) in CODATA_Consts
            for (name, value) in dict
                println("- $key")
                println("\t- base value: $value")
                if (occursin("_m_", name)) # if the variable is the mass of a particle
                    speciesname = split(name, "_m_")[2]
                    println("\t- access by: massof(\"$speciesname\")")
                elseif (occursin("_mu_", name)) # if the variable is the magnetic moment of a particle
                    speciesname = split(name, "_mu_")[2]
                    println("\t- access by: Species(\"$speciesname\").moment")
                else #a physical constant
                    constantname = uppercase(name[5:end])
                    println("\t- access by: @APCdef; APC.$constantname")
                end
            end
        end
        return
    end
    # list all the subatomic species
    if (query == :subatomic)
        for (key, _) in SUBATOMIC_SPECIES
            println("- $key")
            println("\t- access by: Species(\"$key\")")
        end
        return
    end
    if (haskey(ATOMIC_SPECIES, string(query)))
        #the dictionary that stores all the isotopes
        dict = ATOMIC_SPECIES[string(query)].mass
        #sort the dictionary with isotopes mass number 
        sorted_dict = sort(collect(dict))
        for (key, value) in sorted_dict
            if key == -1
                println("- Average mass: $value")
                println("\t- access by: Species(\"$query\")")
            else
                println("- $query-$key : $value")
                println("\t- access by: Species(\"$query#$key\")")
            end
        end
    else
        error("$query is not an available option")
    end
    return
end
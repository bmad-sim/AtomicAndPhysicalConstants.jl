# CODATA_preference.jl

CODATA_MAP = Dict{String, CODATA_release}(
  "2002" => CODATA2002,
  "2006" => CODATA2006,
  "2010" => CODATA2010,
  "2014" => CODATA2014,
  "2018" => CODATA2018,
  "2022" => CODATA2022

)

function set_release(year::String)
  if !(year in ["2002","2006","2010","2014","2018","2022"])
    throw(ArgumentError("You have provided an invalid release year: 
                         options are currently 
                         2002, 2006, 2010, 2014, 2018, or 2022."))
  end
  @set_preferences!("release" => year)
end

const release::CODATA_release = @load_preference("release", "2022")
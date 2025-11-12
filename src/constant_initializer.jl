# AtomicAndPhysicalConstants/src/constant_initializer.jl
struct units
  baryon_mass::String
  atomic_mass::String
  length::String
  time::String
  energy::String
  charge::String
  magnetic_field::String
  spin::String

  function units(; baryon_mass::String = "MeV", atomic_mass::String = "amu", length::String = "m", 
                  time::String = "s", energy::String = "MeV", 
                  charge::String = "e", magnetic_field::String = "T",
                  spin::String = "hbar")

    new(baryon_mass, atomic_mass, length, time, energy, charge, magnetic_field, spin)
  end
end

accelerator::units = units(baryon_mass = "eV", energy = "eV")

##############################################################
##############################################################
##############################################################

# DON'T BE STUPID, USE UCONVERT(u"UNIT", OBJ).VAL

##############################################################
##############################################################
##############################################################

function unit_name(unit::String)::String

  metric_prefix = Dict{String, String}("femto"=>"f", "pico"=>"p", "nano"=>"n", 
  "micro"=>"μ", "milli"=>"m", "centi"=>"c", "kilo"=>"k", "mega"=>"M", "giga"=>"G", 
  "terra"=>"T") 

  ex_units = Dict{String, String}("gram"=>"g", "electron-volt"=>"eV", "dalton"=>"amu", 
  "meter"=>"m", "second"=>"s", "Coulomb"=>"C", "Tesla"=>"T", "Gauss"=>"Ga", "Joule"=>"J")

  p1 = Regex(join(keys(metric_prefix), "|"))
  p2 = Regex(join(keys(ex_units), "|"))

  newu = lowercase(unit)
  newu = replace(newu, p1 => pfx -> metric_prefix[pfx])
  newu = replace(newu, p2 => nm -> ex_units[nm])

  return newu

end

function define_conversion(my_units::units, convert::conversion_consts)

  metric_abbr = Dict{String, Float64}("fm"=>10e-15, "p"=>10e-12, "n"=>10e-9, 
  "μ"=>10e-6, "m"=>10e-3, "c"=>0.01, ""=>1, "k"=>1e3, "M"=>1e6, "G"=>1e9, "T"=>1e12) 

  if occursin(my_units.baryon_mass, "g")
    # factor of 1e6 to account for base unit MeV
    bmass_con = convert.g_per_eV/1e6
    bmpfx = rsplit(my_units.baryon_mass, "g", limit=2)
    bmass_con = bmass_con/metric_abbr[bmpfx]
  elseif occursin(my_units.baryon_mass, "eV")
    bmpfx = rsplit(my_units.baryon_mass, "eV", limit=2)
    bmass_con = 1e6/metric_abbr[bmpfx]
  end

  if occursin(myunits.atomic_mass, "g")
    amass_con = convert.g_per_amu
    ampfx = rsplit(my_units.atomic_mass, "g", limit=2)
    amass_con = amass_con/metric_abbr[ampfx]
  elseif occursin(my_units.atomic_mass, "eV")
    amass_con = convert.eV_per_amu
    ampfx = rsplit(my_units.atomic_mass, "eV", limit=2)
    amass_con = amass_con/metric_abbr[ampfx]
  else
    amass_con = 1.0
  end


  charge_con = 1/convert.e_coulomb
  if occursin(my_units.charge, "C")
    charge_con = 1.0
  end


  if occursin(my_units.magnetic_field, "Ga")
    cpfx = rsplit(my_units.magnetic_field, "Ga", limit=2)
    field_con = 1e4/metric_abbr[cpfx]
  else
    cpfx = rsplit(my_units.charge, "T", limit=2)
    field_con = 1.0/metric_abbr[pfx]
  end

  
  lpfx = rsplit(my_units.length, "m", limit=2)
  length_con = 1.0/metric_abbr[lpfx]

  tpfx = rsplit(my_units.time, "s", limit=2)
  time_con = 1.0/metric_abbr[tpfx]


  if occursin(my_units.energy, "J")
    epfx = rsplit(my_units.energy, "J", limit=2)
    energy_con = 1.0/metric_abbr[epfx]
  else
    epfx = rsplit(my_units.energy, "eV")
    energy_con = 1.0/convert.J_per_eV/metric_abbr[epfx]
  end

  moment_con = energy_con/field_con
  action_con = energy_con*time_con
  velocity_con = length_con/time_con
  
  return Dict{String, Float64}("baryonmass"=>bmass_con, "atomicmass"=>amass_con, 
                              "length"=>length_con, "time"=>time_con, 
                              "energy"=>energy_con, "charge"=>charge_con, 
                              "field"=>field_con, "moment"=>moment_con, 
                              "action"=>action_con, "velocity"=>velocity_con)
    
end


function define_consts(; year::Int64 = 2022, my_units::units = accelerator)
  

  metric_abbr = Dict{String, Float64}("fm"=>10e-15, "p"=>10e-12, "n"=>10e-9, 
  "μ"=>10e-6, "m"=>10e-3, "c"=>0.01, ""=>1, "k"=>1e3, "M"=>1e6, "G"=>1e9, "T"=>1e12) 
  


  mass_base = [:__b_m_electron, :__b_m_proton, :__b_m_neutron, :__b_m_muon, :__b_m_helion, :__b_m_deuteron, :__b_m_pion_0, :__b_m_pion_charged]

  moment_base = [:__b_mu_deuteron, :__b_mu_electron, :__b_mu_helion, :__b_mu_muon, :__b_mu_neutron, :__b_mu_proton, :__b_mu_triton]

  length_base = [:__b_r_e, :__b_r_p]
  actions_consts = [:__b_h_planck, :__b_h_bar_planck]
  clight = :__b_c_light
  echarge = :__b_e_charge
  eps0 = :__b_eps_0_vac
  mu0 = :__b_mu_0_vac

  if year ∉ [2002, 2006, 2010, 2014, 2018, 2022]
    error("You have chosen a year which did not have a CODATA release.")
  else
    symname = Symbol("CODATA"*String(year))
    symconv = Symbol("convert_"*String(year))
  end

  consts = getfield(@__MODULE__, symname)
  convert = getfield(@__MODULE__, symconv)


  # define unit conversions 
  ucs = define_conversion(my_units, convert)


  for name in fieldnames(CODATA_vals)

  end

end
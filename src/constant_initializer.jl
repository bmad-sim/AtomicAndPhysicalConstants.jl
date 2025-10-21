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

  function units(; baryon_mass::String = "MeV/c^2", atomic_mass::String = "amu", length::String = "m", 
                  time::String = "s", energy::String = "MeV", 
                  charge::String = "e", magnetic_field::String = "T",
                  spin::String = "hbar")

    new(baryon_mass, atomic_mass, length, time, energy, charge, magnetic_field, spin)
  end
end

accelerator::units = units(baryon_mass = "eV/c^2", energy = "eV")

function define_consts(; year::Int64 = 2022, my_units::units = accelerator)
  
  metric_prefix = Dict{String, Float64}("femto"=>10e-15, "pico"=>10e-12, "nano"=>10e-9, 
  "micro"=>10e-6, "milli"=>10e-3, "centi"=>0.01, "kilo"=>1e3, "mega"=>1e6, "giga"=>1e9, "terra"=>1e12) 
  metric_abbr = Dict{String, Float64}("fm"=>10e-15, "p"=>10e-12, "n"=>10e-9, 
  "μ"=>10e-6, "m"=>10e-3, "c"=>0.01, "k"=>1e3, "M"=>1e6, "G"=>1e9, "T"=>1e12) 
  

  mass_consts = [:__b_m_electron, :__b_m_proton, :__b_m_neutron, :__b_m_muon, :__b_m_helion, :__b_m_deuteron, :__b_m_pion_0, :__b_m_pion_charged]
  moment_consts = [:__b_mu_deuteron, :__b_mu_electron, :__b_mu_helion, :__b_mu_muon, :__b_mu_neutron, :__b_mu_proton, :__b_mu_triton]
  lengths_consts = [:__r_e, :__b_r_p]
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
end
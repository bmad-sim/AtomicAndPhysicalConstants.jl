


function redef_consts(; year::Int64 = 2022, my_units::apc_units = accelerator_units)

  mass_consts = [:__b_m_electron, :__b_m_proton, :__b_m_neutron, :__b_m_muon, :__b_m_helion, :__b_m_deuteron, :__b_m_pion_0, :__b_m_pion_charged]
  moment_consts = [:__b_mu_deuteron, :__b_mu_electron, :__b_mu_helion, :__b_mu_muon, :__b_mu_neutron, :__b_mu_proton, :__b_mu_triton]
  length_consts = [:__b_r_e, :__b_r_p]
  action_consts = [:__b_h_planck, :__b_h_bar_planck]
  scalar_consts = [:__b_N_avogadro, :__b_fine_structure, :__b_gyro_anom_electron, :__b_gyro_anom_muon, :__b_gspin_deuteron, :__b_gspin_electron, :__b_gspin_helion, :__b_gspin_muon, :__b_gspin_neutron, :__b_gspin_proton, :__b_gspin_triton, :__b_classical_radius_factor, :__b_RELEASE_YEAR]
  clight = :__b_c_light
  echarge = :__b_e_charge
  eps0 = :__b_eps_0_vac
  mu0 = :__b_mu_0_vac

  vname(s::Symbol) = replace(String(s), "__b_" => "")

  if year ∉ [2002, 2006, 2010, 2014, 2018, 2022]
    error("You have chosen a year which did not have a CODATA release.")
  else
    symname = Symbol("CODATA"*string(year))
  end

  consts = getfield(@__MODULE__, symname)
  nglobs = Dict{String, Float32}()
  for s in mass_consts
    nglobs[vname(s)] = uconvert(my_units.baryon_mass, getfield(consts, s) * u"MeV/c^2").val
  end
  for s in moment_consts
    nglobs[vname(s)] = uconvert(my_units.magnetic_moment, getfield(consts, s) * u"J/T").val
  end
  for s in length_consts
    nglobs[vname(s)] = uconvert(my_units.length, getfield(consts, s) * u"m").val
  end
  for s in action_consts
    nglobs[vname(s)] = uconvert(my_units.action, getfield(consts, s) * u"J*s").val
  end
  for s in scalar_consts
    nglobs[vname(s)] = getfield(consts, s)
  end
  nglobs[vname(clight)] = uconvert(my_units.velocity, getfield(consts, clight) * u"m/s").val
  nglobs[vname(echarge)] = getfield(consts, echarge)
  nglobs[vname(eps0)] = uconvert(my_units.permittivity, getfield(consts, eps0) * u"F/m").val
  nglobs[vname(mu0)] = uconvert(my_units.permeability, getfield(consts, mu0) * u"N/A^2").val

  
  m_electron[] = nglobs["m_electron"]
  m_proton[] = nglobs["m_proton"]
  m_neutron[] = nglobs["m_neutron"]
  m_muon[] = nglobs["m_muon"]
  m_helion[] = nglobs["m_helion"]
  m_deuteron[] = nglobs["m_deuteron"]
  m_pion_0[] = nglobs["m_pion_0"]
  m_pion_charged[] = nglobs["m_pion_charged"]
  mu_deuteron[] = nglobs["mu_deuteron"]
  mu_electron[] = nglobs["mu_electron"]
  mu_helion[] = nglobs["mu_helion"]
  mu_muon[] = nglobs["mu_muon"]
  mu_neutron[] = nglobs["mu_neutron"]
  mu_proton[] = nglobs["mu_proton"]
  mu_triton[] = nglobs["mu_triton"]
  N_avogadro[] = nglobs["N_avogadro"]
  fine_structure[] = nglobs["fine_structure"]
  gyro_anom_electron[] = nglobs["gyro_anom_electron"]
  gyro_anom_muon[] = nglobs["gyro_anom_muon"]
  gspin_deuteron[] = nglobs["gspin_deuteron"]
  gspin_electron[] = -nglobs["gspin_electron"]
  gspin_helion[] = nglobs["gspin_helion"]
  gspin_muon[] = nglobs["gspin_muon"]
  gspin_neutron[] = nglobs["gspin_neutron"]
  gspin_proton[] = nglobs["gspin_proton"]
  gspin_triton[] = nglobs["gspin_triton"]
  e_charge[] = nglobs["e_charge"]
  r_e[] = nglobs["r_e"]
  r_p[] = nglobs["r_p"]
  c_light[] = nglobs["c_light"]
  h_planck[] = nglobs["h_planck"]
  h_bar_planck[] = nglobs["h_bar_planck"]
  classical_radius_factor[] = nglobs["classical_radius_factor"]
  eps_0_vac[] = nglobs["eps_0_vac"]
  mu_0_vac[] = nglobs["mu_0_vac"]
  RELEASE_YEAR[] = nglobs["RELEASE_YEAR"]

  SUBATOMIC_SPECIES[] = subatomic_species()


end




# ------------------------------------------------------------------------------------------------------------
"""
    g_spin(species::Species)

Compute and return the value of g_s for a particle in [1/(T*s)] == [C/kg]
For atomic particles, will currently return 0. Will be updated in a future patch
"""
g_spin

function g_spin(species::Species; signed::Bool=false)

  vtypes = [Kind.LEPTON, Kind.HADRON]
  known = ["deuteron", "electron", "helion", "muon", "neutron", "proton", "triton"]

  if getfield(species, :kind) ∉ vtypes
    error("Only massive subatomic particles have available gyromagnetic factors in this package.")
  end
  if lowercase(getfield(species, :name)) ∈ known
    if signed == false 
      return abs(getfield(@__MODULE__, "gspin_"*lowercase(getfield(species, :name))))
    else
      return getfield(@__MODULE__, "gspin_"*lowercase(getfield(species, :name)))
    end
  else
    m_s = getfield(species, :mass) * g_per_eV * 1e3
    mu_s = getfield(species, :moment)
    spin_s = getfield(species, :spin) * h_bar_Planck 
    if signed == false
      charge_s = abs(getfield(species, :charge) * e_charge)
    else
      charge_s = getfield(species, :charge) * e_charge
    end
    gs = m_s * mu_s / (charg_s * spin_s)
    return gs
  end
end;



"""
    gyromagnetic_anomaly(species::Species)

Compute and deliver the gyromagnetic anomaly for a lepton given its g factor

# Arguments:
1. `gs::Float64': the g_factor for the particle
"""
gyromagnetic_anomaly

function gyromagnetic_anomaly(species::Species; signed::Bool=false)

    vtypes = [Kind.LEPTON, Kind.HADRON]
    if getfield(species, :name) == "electron"
      return CODATA2022.__b_gyro_anom_electron
    elseif getfield(species, :name) == "muon"
      return CODATA2022.__b_gyro_anom_muon
    elseif getfield(species, :kind) ∉ vtypes
      error("Only subatomic particles have computable gyromagnetic anomalies in this package.")
    else
      if signed == true
        gs = g_spin(species; signed = true)
      else
        gs = g_spin(species)
      end
      return (gs - 2) / 2
    end

end;



"""
    g_nucleon(gs::Float64, Z::Int, mass::Float64)

Compute and deliver the gyromagnetic anomaly for a baryon given its g factor


"""
g_nucleon

function g_nucleon(species::Species)

  e = 1u"h_bar"
  m = getfield(species, :mass).val
  gs = g_spin(species)
  m_p = getfield(Species("proton"), :mass).val

  return gs * e * m_p / m
end;











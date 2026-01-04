# Gyro Vals

The spin g-factor, g-spin, or $$g_s$$, a dimensionless constant that relates a particle's intrinsic magnetic moment to its spin angular momentum. 

The gyromagnetic anomaly, is the small difference between the experimentally measured g-factor and the theoretical value predicted by the Dirac equation.

In `gyrovals.jl`, the spin g-factor (g-spin) and gyromagnetic anomoly values are computed for Leptons, Hadrons and Nucleons.

## Gyro Vals for Leptons and Hadrons 
### Spin g-Factor (g-spin)
* `g_spin(species::Species, signed::Bool=false)` computes and returns the value of g_s for a particle in [1/(T*s)] == [C/kg].
  * Note:
    * Currently, for atomic particles, g_spin() will return a value of 0. This will be updated in a future patch.
    * If the particle type is not a lepton on hadron, the user will get the following error: "Only massive subatomic particles have available gyromagnetic factors in this package."
    * The paricles with known g-factors are the deuteron, "electron, helion, muon, neutron, proton, and triton.

The values for the g-factor are calculated as: 
$$g_s = \frac{m_s codot mu_s}{spin_s \cdot charge_s}$$

as per Abell et al. (2024) and is of datatype Float64.

### Gyromagnetic Anomaly 
* `gyromagnetic_anomaly(species::Species, signed::Bool=false)` computes and delivers the gyromagnetic anomaly for a lepton given its g factor
* If the particle type is not a lepton on hadron, the user will get the following error: 
"Only subatomic particles have computable gyromagnetic anomalies in this package"

The values for the leptonian factors are calculated as: 
$$\frac{(g_s - 2)}{2}$$

## Gyro Vals for Nucleons 
### Gyromagnetic Anomaly 
`g_nucleon(species::Species)` computes and delivers the gyromagnetic anomaly for a baryon given its g factor.

g_nucleon is calulated as such:
$$g_nucleon = \frac{g_spin(species) \cdot e \cdot massof(proton)}{massof(species)}$$
where e = 1u"h_bar"



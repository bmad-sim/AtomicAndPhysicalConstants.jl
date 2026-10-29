# AtomicAndPhysicalConstants/src/defaults.jl
"""
    _LATEST_RELEASE::String

The most recent CODATA release year in `CODATA_MAP`,
used when no release preference is set.
"""
const _LATEST_RELEASE::String = string(maximum(parse.(Int, keys(CODATA_MAP))))

"""
    release::String

The release year of the currently selected CODATA values.
"""
const release::String = @load_preference("release", _LATEST_RELEASE)
haskey(CODATA_MAP, release) || error(
  "Invalid CODATA release \"$release\"; valid: $(sort(collect(keys(CODATA_MAP)))). Use set_release().")
const _ACTIVE = CODATA_MAP[release]
#######################################
# constants with dimension [mass]
#######################################

"""
    M_ELECTRON::Float64

Mass of the electron in eV/c² from the selected CODATA release.
"""
const M_ELECTRON::Float64 = _ACTIVE.M_ELECTRON

"""
    M_PROTON::Float64

Mass of the proton in eV/c² from the selected CODATA release.
"""
const M_PROTON::Float64 = _ACTIVE.M_PROTON

"""
    M_NEUTRON::Float64

Mass of the neutron in eV/c² from the selected CODATA release.
"""
const M_NEUTRON::Float64 = _ACTIVE.M_NEUTRON

"""
    M_MUON::Float64

Mass of the muon in eV/c² from the selected CODATA release.
"""
const M_MUON::Float64 = _ACTIVE.M_MUON
# Muon Mass [eV]/c^2
"""
    M_HELION::Float64

Mass of the helion in eV/c² from the selected CODATA release.
"""
const M_HELION::Float64 = _ACTIVE.M_HELION
# Helion Mass He3 nucleus [eV]/c^2
"""
    M_DEUTERON::Float64

Mass of the deuteron in eV/c² from the selected CODATA release.
"""
const M_DEUTERON::Float64 = _ACTIVE.M_DEUTERON
# Deuteron Mass [eV]/c^2
"""
    M_TRITON::Float64

Mass of the triton in eV/c² from the selected CODATA release.
"""
const M_TRITON::Float64 = _ACTIVE.M_TRITON
# Triton Mass [eV]/c^2

# The pion masses are not published in any CODATA release; each release file
# carries the Particle Data Group values of the edition of the same year.
"""
    M_PION_0::Float64

Mass of the neutral pion in eV/c², from the Particle Data Group edition of the
same year as the selected CODATA release.
"""
const M_PION_0::Float64 = _ACTIVE.M_PION_0
# uncharged pion mass [eV]/c^2
"""
    M_PION_CHARGED::Float64

Mass of a charged pion in eV/c², from the Particle Data Group edition of the
same year as the selected CODATA release.
"""
const M_PION_CHARGED::Float64 = _ACTIVE.M_PION_CHARGED
# charged pion mass [eV]/c^2


#######################################
"""
    EV_PER_J::Float64

eV per Joule in the selected CODATA release.
"""
const EV_PER_J::Float64 = _ACTIVE.EV_PER_J
# Joules per eV

# constants with dimension [magnetic moment]
#######################################


"""
    MU_DEUTERON::Float64

Magnetic moment of the deuteron in eV/T (converted) from the selected CODATA release.
"""
const MU_DEUTERON::Float64 = EV_PER_J*_ACTIVE.MU_DEUTERON_SI
# deuteron magnetic moment in [eV/T]
"""
    MU_ELECTRON::Float64

Magnetic moment of the electron in eV/T (converted) from the selected CODATA release.
"""
const MU_ELECTRON::Float64 = EV_PER_J*_ACTIVE.MU_ELECTRON_SI
# electron magnetic moment in [eV/T]
"""
    MU_HELION::Float64

Magnetic moment of the helion in eV/T (converted) from the selected CODATA release.
"""
const MU_HELION::Float64 = EV_PER_J*_ACTIVE.MU_HELION_SI
# helion magnetic moment in [eV/T],
"""
    MU_MUON::Float64

Magnetic moment of the muon in eV/T (converted) from the selected CODATA release.
"""
const MU_MUON::Float64 = EV_PER_J*_ACTIVE.MU_MUON_SI
# muon magnetic moment in [eV/T]
"""
    MU_NEUTRON::Float64

Magnetic moment of the neutron in eV/T (converted) from the selected CODATA release.
"""
const MU_NEUTRON::Float64 = EV_PER_J*_ACTIVE.MU_NEUTRON_SI
# neutron magnetic moment in [eV/T]
"""
    MU_PROTON::Float64

Magnetic moment of the proton in eV/T (converted) from the selected CODATA release.
"""
const MU_PROTON::Float64 = EV_PER_J*_ACTIVE.MU_PROTON_SI
# proton magnetic moment in [eV/T]
"""
    MU_TRITON::Float64

Magnetic moment of the triton in eV/T (converted) from the selected CODATA release.
"""
const MU_TRITON::Float64 = EV_PER_J*_ACTIVE.MU_TRITON_SI
# triton magnetic moment in [eV/T]


#######################################
# dimensionless constants
#######################################


"""
    AVOGADRO::Float64

Avogadro's constant in mol⁻¹ (exact) from the selected CODATA release.
"""
const AVOGADRO::Float64 = _ACTIVE.AVOGADRO
# Avogadro's constant: Number / mole (exact)
"""
    FINE_STRUCTURE::Float64

Fine-structure constant from the selected CODATA release.
"""
const FINE_STRUCTURE::Float64 = _ACTIVE.FINE_STRUCTURE
# fine structure constant

"""
    ANOMALY_ELECTRON::Float64

The electron gyromagnetic anomaly per the selected CODATA release.
"""
const ANOMALY_ELECTRON::Float64 = _ACTIVE.ANOMALY_ELECTRON
# electron magnetic moment anomaly
"""
    ANOMALY_MUON::Float64

The muon gyromagnetic anomaly per the selected CODATA release.
"""
const ANOMALY_MUON::Float64 = _ACTIVE.ANOMALY_MUON
# muon magnetic moment anomaly

"""
    _G_DEUTERON_NUCLEAR_MAGNETON::Float64

The deuteron spin g-factor exactly as tabulated by NIST for the selected
CODATA release, i.e. normalized to the nuclear magneton `mu_N = e*hbar/(2*M_PROTON)`.
Internal: use `G_DEUTERON` instead.
"""
const _G_DEUTERON_NUCLEAR_MAGNETON::Float64 = _ACTIVE.G_DEUTERON_NUCLEAR_MAGNETON
# deuteron g factor
"""
    G_DEUTERON::Float64

The deuteron spin g-factor renormalized to the deuteron magneton
`e*hbar/(2*M_DEUTERON)`, the convention in which the gyromagnetic anomaly `a = (|g|-2)/2` holds.
"""
const G_DEUTERON::Float64 = _G_DEUTERON_NUCLEAR_MAGNETON * M_DEUTERON / M_PROTON
# deuteron g factor 
"""
    G_ELECTRON::Float64

The electron spin g-factor per the selected CODATA release.
"""
const G_ELECTRON::Float64 = _ACTIVE.G_ELECTRON
# electron g factor 
"""
    _G_HELION_NUCLEAR_MAGNETON::Float64

The helion spin g-factor exactly as tabulated by NIST for the selected
CODATA release, i.e. normalized to the nuclear magneton `mu_N = e*hbar/(2*M_PROTON)`.
Internal: use `G_HELION` instead.
"""
const _G_HELION_NUCLEAR_MAGNETON::Float64 = _ACTIVE.G_HELION_NUCLEAR_MAGNETON
# helion g factor
"""
    G_HELION::Float64

The helion spin g-factor renormalized to the helion magneton
`e*hbar/(2*M_HELION)`, the convention in which the gyromagnetic anomaly `a = (|g|-2)/2` holds.
"""
const G_HELION::Float64 = _G_HELION_NUCLEAR_MAGNETON * M_HELION / M_PROTON
# helion g factor 
"""
    G_MUON::Float64

The muon spin g-factor per the selected CODATA release.
"""
const G_MUON::Float64 = _ACTIVE.G_MUON
# muon g factor 
"""
    _G_NEUTRON_NUCLEAR_MAGNETON::Float64

The neutron spin g-factor exactly as tabulated by NIST for the selected
CODATA release, i.e. normalized to the nuclear magneton `mu_N = e*hbar/(2*M_PROTON)`.
Internal: use `G_NEUTRON` instead.
"""
const _G_NEUTRON_NUCLEAR_MAGNETON::Float64 = _ACTIVE.G_NEUTRON_NUCLEAR_MAGNETON
# neutron g factor
"""
    G_NEUTRON::Float64

The neutron spin g-factor renormalized to the neutron magneton
`e*hbar/(2*M_NEUTRON)`, the convention in which the gyromagnetic anomaly `a = (|g|-2)/2` holds.
"""
const G_NEUTRON::Float64 = _G_NEUTRON_NUCLEAR_MAGNETON * M_NEUTRON / M_PROTON
# neutron g factor 
"""
    G_PROTON::Float64

The proton spin g-factor per the selected CODATA release.
"""
const G_PROTON::Float64 = _ACTIVE.G_PROTON
# proton g factor 
"""
    _G_TRITON_NUCLEAR_MAGNETON::Float64

The triton spin g-factor exactly as tabulated by NIST for the selected
CODATA release, i.e. normalized to the nuclear magneton `mu_N = e*hbar/(2*M_PROTON)`.
Internal: use `G_TRITON` instead.
"""
const _G_TRITON_NUCLEAR_MAGNETON::Float64 = _ACTIVE.G_TRITON_NUCLEAR_MAGNETON
# triton g factor
"""
    G_TRITON::Float64

The triton spin g-factor renormalized to the triton magneton
`e*hbar/(2*M_TRITON)`, the convention in which the gyromagnetic anomaly `a = (|g|-2)/2` holds.
"""
const G_TRITON::Float64 = _G_TRITON_NUCLEAR_MAGNETON * M_TRITON / M_PROTON
# triton g factor


#######################################
# constants with miscellaneous dimension
#######################################


"""
    E_CHARGE::Float64

Magnitude of the charge on the electron in C per the selected CODATA release.
"""
const E_CHARGE::Float64 = _ACTIVE.E_CHARGE
# elementary charge [C]
"""
    R_ELECTRON::Float64

Classical electron radius in m per the selected CODATA release.
"""
const R_ELECTRON::Float64 = _ACTIVE.R_ELECTRON
# classical electron radius [m],
"""
    R_PROTON::Float64

Classical proton radius in m per the selected CODATA release.
"""
const R_PROTON::Float64 = _ACTIVE.R_PROTON #R_ELECTRON * m_electron / m_proton,
# classical proton radius [m]
"""
    C_LIGHT::Float64

Speed of light in m/s per the selected CODATA release.
"""
const C_LIGHT::Float64 = _ACTIVE.C_LIGHT
# speed of light [m/s]
"""
    H_PLANCK::Float64

Planck's constant ``h`` in eV·s per the selected CODATA release.
"""
const H_PLANCK::Float64 = _ACTIVE.H_PLANCK
# Planck's constant [eV*s]
"""
    H_BAR::Float64

Reduced Planck constant ``\\hbar`` in eV·s per the selected CODATA release.
"""
const H_BAR::Float64 = _ACTIVE.H_BAR
# h_planck/twopi [eV*s]
"""
    CLASSICAL_RADIUS_FACTOR::Float64

Classical radius factor ``e^2/(4 \\pi \\varepsilon_0) = r_e m_e c^2`` in eV·m.

Not a tabulated CODATA value: it is derived from the selected release as
`R_ELECTRON * M_ELECTRON`, and so is not a field of [`CODATA_release`](@ref).
It is the same for all particles of charge ±1.
"""
const CLASSICAL_RADIUS_FACTOR::Float64 = _ACTIVE.R_ELECTRON * _ACTIVE.M_ELECTRON # R_ELECTRON * M_ELECTRON,
# e^2 / (4 pi eps_0)::Float64 = classical_radius * mass * c^2.
# Is same for all particles of charge +/- 1.

"""
    K_BOLTZMANN::Float64

Boltzmann constant ``k_B`` in eV/K per the selected CODATA release.
"""
const K_BOLTZMANN::Float64 = _ACTIVE.K_BOLTZMANN
"""
    EPS_0::Float64

Permittivity of free space in 1/(eV·m) per the selected CODATA release.
"""
const EPS_0::Float64 = _ACTIVE.EPS_0
# Permittivity of free space in [1/(eV*m)]
"""
    MU_0::Float64

Vacuum permeability in eV·s²/m per the selected CODATA release.
"""
const MU_0::Float64 = _ACTIVE.MU_0
# Vacuum permeability in [eV*s^2/m]

"""
    KG_PER_AMU::Float64

Kilograms per dalton in the selected CODATA release.

Derived from the release's `G_PER_AMU` field (grams per dalton); there is no
`KG_PER_AMU` field on [`CODATA_release`](@ref).
"""
const KG_PER_AMU::Float64 = _ACTIVE.G_PER_AMU * 1e-3
# grams per standard atomic mass unit (dalton)

"""
    EV_PER_AMU::Float64

eV/c² per dalton in the selected CODATA release.
"""
const EV_PER_AMU::Float64 = _ACTIVE.EV_PER_AMU
# eV/c^2 per standard atomic mass unit (dalton)

"""
    J_PER_EV::Float64

Joules per eV in the selected CODATA release.
"""
const J_PER_EV::Float64 = _ACTIVE.J_PER_EV
# Joules per eV

"""
    G_PER_EV::Float64

Grams per eV/c² in the selected CODATA release.
"""
const G_PER_EV::Float64 = _ACTIVE.G_PER_EV
# grams per eV/c^2

"""
    RELEASE_YEAR::Int

The release year of the currently selected CODATA values.
"""
const RELEASE_YEAR::Int = _ACTIVE.RELEASE_YEAR

# kg per MeV/c²
"""
    KG_PER_MEV_C2::Float64

Kilograms per MeV/c².

Derived from [`G_PER_EV`](@ref) in the selected CODATA release, and so is not a
field of [`CODATA_release`](@ref).
"""
const KG_PER_MEV_C2::Float64 = G_PER_EV * 1e3

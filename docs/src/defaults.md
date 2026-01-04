# Defaults

By default, the following constants values are pulled from the **NIST** table of the **2022 CODATA release**. Note that `m_pion_0` and `m_pion_charged` are pulled from **PDG**.

## Physical Constants

- Speed of light: `c_light` = 2.99792458e8 * u"m/s"
- Planck's constant: `h_planck` = 4.135667696e-15 * u"eV*s"
- Classical electron radius: `r_e` = 2.8179403205e-15 * u"m"
- Vacuum permeability: `mu_0_vac` = 1.25663706127e-6 * u"N/A^2"
- Elementary charge: `e_charge` = 1.602176634e-19 * u"C"
- Avogadro's constant: `N_avogadro` = 6.02214076e23
- Fine structure constant: `fine_structure` = 0.0072973525643

## Species Mass

- Electron Mass: `m_electron` = 0.51099895069 * u"MeV/c^2"
- Proton Mass: `m_proton` = 938.2720894300001 * u"MeV/c^2"
- Neutron Mass: `m_neutron` = 9.395654219399999e2 * u"MeV/c^2"
- Muon Mass: `m_muon` = 1.056583755e2 * u"MeV/c^2"
- Helion Mass He3 nucleus: `m_helion` = 2.80839161112e3 * u"MeV/c^2"
- Deuteron Mass: `m_deuteron` = 1.875612945e3 * u"MeV/c^2"
- uncharged pion mass: `m_pion_0` = 1.349768277676847e2 * u"MeV/c^2"
- charged pion mass: `m_pion_charged` = 1.3957039098368132e2 * u"MeV/c^2"

## Species Magnetic Momoments

- Deuteron magnetic moment: `mu_deuteron` = 4.330735087e-27 * u"J/T"
- Electron magnetic moment: `mu_electron` = -9.2847646917e-24 * u"J/T"
- Helion magnetic moment: `mu_helion` = -1.07461755198e-26 * u"J/T"
- Muon magnetic moment: `mu_muon` = -4.4904483e-26 * u"J/T"
- Neutron magnetic moment: `mu_neutron` = -9.6623653e-27 * u"J/T"
- Proton magnetic moment: `mu_proton` = 1.41060679545e-26 * u"J/T"
- Triton magnetic moment: `mu_triton` = 1.5046095178e-26 * u"J/T"

## Conversion Factors

- kg per standard atomic mass unit: `kg_per_amu` = 1.66053906892e-27
- eV per standard atomic mass unit: `eV_per_amu` = 9.3149410372e8
- Joules per eV: `J_per_eV` = 1.602176634e-19

Subatomic particles included with information about charge, mass, anomalous magnetic moment, and spin are:

- `photon`
- `pion0`
- `pion+`
- `pion-`
- `muon`
- `antimuon`
- `electron`
- `positron`
- `proton`
- `anti-proton`
- `neutron`
- `anti-neutron`
- `deuteron`
- `anti-deuteron`

In addition, a collection of all the isotopes documented by NIST is included. Values may be updated with setIsos()

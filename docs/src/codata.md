# CODATA Structs

## CODATA 
CODATA is a type which contains all the relevant constants from our package. 
Each release year is a different struct object with name "CODATAYYYY" where 
YYYY is the year of the release.

## Constants 

* Constants with dimension [mass] have units [MeV]/c^2
* Constants with dimension [magnetic moment] have units [J/T]
* There are also several dimensionless constants such as  Avogadro's constant,
the fine structure constant, and various magnetic moment anomalies.
* Other constant (with miscellaneous dimension) are also defined. 

## Conversion Constants 

Within CODATAstruct, the following conversion factors are defined:
* Grams per Dalton: g_per_amu
* Electronvolts per Dalton: eV_per_amu
* Joules per Electronvolt: J_per_eV
* Elementary Charge in Coulombs: e_coulomb
* Grams per Elevtronvolt: g_per_eV

## Release Year 
The release year is also stored for posterity under the name RELEASE_YEAR and is of type Int.

## Data Type
Each constant is of Float64 type.

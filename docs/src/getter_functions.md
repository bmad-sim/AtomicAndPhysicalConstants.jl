# Getter Functions 

## Getter functions for Species struct fields

Getter functions take a `Species` as their parameter and return a specific property. Here are the availible fucntions: 


* `nameof(species::Species)`: Returns the name of the species as a String.
* `chargeof(species::Species)`: Returns the charge of the species in units of elementary charge [e].
* `massof(species::Species)`: Returns the mass of the species.
  * For atomic species, returns mass in atomic mass units (current_units.atomic_mass).
  * For subatomic species (baryons, leptons, etc.), returns mass in baryon mass units (current_units.baryon_mass).
* `spinof(species::Species)`:  Returns the spin of the species in units of reduced Planck constant [ħ].
* `momentof(species::Species)`: Returns the magnetic moment of the species in magnetic moment units J/T.
* `iso_of(species::Species)`: Returns the isotope mass number of the species as an Int.
  * For atomic isotopes, this is the mass number: if taken as the abundance average, yields -1.
  * For subatomic particles, yields 0.

Note: You must call @APCdef before using `massof()`, `chargeof()`, or `nameof()`.

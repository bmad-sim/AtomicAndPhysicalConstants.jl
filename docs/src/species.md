# Species

## Introduction

`Species` is a type to store the information of an particle. 

A species is defined with the following fields:

```julia
struct Species 
    name    # name of the particle to track
    charge  # charge of the particle 
    mass    # mass of the particle
    spin    # spin of the particle
    moment  # magnetic moment of the particle
    iso     # mass number of atomic isotope
	kind    # the kind of particle.
end;
```
There are 5 kinds of species: `ATOM` `HADRON` `LEPTON` `PHOTON` `NULL`. 
The kind of species is stored within the `kind` field.

The fields are stored with a set of units. If the fields are directly accessed, 
it will return a Unitful value. For example:
```julia
julia> Species("electron").mass
0.51099895069 MeV c^-2
```
The default units are:
- `mass`:  MeV/c^2
- `charge`: elementary charge
- `spin`: $\hbar$
- `moment`: J/T

We recommended using our getter functions `massof()` an d `chargeof()` to obtain values 
in units you prefer. See [this page](constants.md) for more information.


## Construct a Species

Construct the particle with the constructor `Species(name)`.

**Species names correspond to the OpenPMD standard.**

### Constructing a Null species

The `Null` species is usful for bookkeeping purposes. For example, as a place holder for a struct
component to indicate that the species has not yet been set. To instantiate use:
```julia
julia> Species("Null")
julia> Species()        # Same as above
```

### Constructing Subatomic Species

To construct a subatomic species, put the name of the subatomic species in the field `name`. 
**Note that the name must be provided exactly.**

Example:
```julia
julia> Species("electron")
```

To construct an antiparticle, prepend the prefix "anti-" in the front.

Example:
```julia
julia> Species("anti-proton")
```

See the list of all available subatomic species at the end of this page.

### Constructing Atomic Species

To construct an atomic species, put the following 3 things in `name`:

- Atomic Symbol
- "#" followed by the mass number of the atomic (optional)
- charge (optional)

Example:
```julia
julia> Species("C#13+") #Carbon-13 with a single positive charge
```

**Note**

- If mass number is not provided, the average will be used
- If charge is not provided, a neutral atom will be returned.
- Charge can be provided by the following format
    - "+" represents single positive charge
    - "++" represents double positive charge
    - "+n" represents n positive charge
    - "-" represents single negative charge
    - "--" represents double negative charge
    - "-n" represents n negative charge
- To construct an anti atom, put "anti-" in the front.

Example:
```julia
julia> Species("Al+3") #average Aluminum with 3 positive charge
julia> Species("anti-H") #anti-hydrogen
```

### Alternative Way of Constructing Atomic Species

We also provide the constructor 
```julia
Species(name::String, charge::Int, iso::Int)
```
where users can enter charge and mass number as separate parameter.

The parameter `charge` and `iso` are optional and it will use default values if not provided. 
Defaults are neutral atom and average atom.

**Note** If charge or mass number are also provided in `name`. 
The charge and mass number in `name` will override the one given in the parameter.

Example:
```julia
julia> Species("C",charge = 1, iso = 13) #Carbon-13 with a single positive charge
```

## Species Functions

Species functions take a `Species` as their only parameter and returns a specific property of it. 
Here is the list of species functions:

- `massof()`
- `chargeof()`
- `atomicnumber()`
- `g_spin()`
- `gyromagnetic_anomaly()`
- `g_nucleon()`
- `fullname()`

**Note**: One must call `@APCdef` before calling `massof()` and `chargeof()`.

## List of Available subatomic species

- `photon`
- `pion0`
- `pion+`
- `pion-`
- `muon`
- `anti-muon`
- `electron`
- `positron` or `anti-electron`
- `proton`
- `anti-proton`
- `neutron`
- `anti-neutron`
- `deuteron`
- `anti-deuteron`

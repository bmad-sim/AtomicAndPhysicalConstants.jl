# Declare specific systems of units
#   for particle physics
"""
    ACCELERATOR
## ACCELERATOR units:
- `mass`: eV/c^2
- `length`: m
- `time`: s
- `energy`: eV
- `charge`: elementary charge
"""
ACCELERATOR

const ACCELERATOR = [u"eV/c^2", u"m", u"s", u"eV", u"e"]

#   MKS
"""
    MKS
## MKS units:
- `mass`: kg
- `length`: m
- `time`: s
- `energy`: J
- `charge`: C
"""
MKS

const MKS = [u"kg", u"m", u"s", u"J", u"C"]
#   quasi-CGS
"""
    CGS
## CGS units:
- `mass`: g
- `length`: cm
- `time`: s
- `energy`: J
- `charge`: C
"""
CGS

const CGS = [u"g", u"cm", u"s", u"J", u"C"]

"""
    @APCdef(CODATA = 2022, unitsystem = ACCELERATOR, unitful = false)

## Description:
It defines the physical constants and getter functions for species mass and charge with the proper unit and data.

## positional parameters:
- `CODATA`       -- type: `Int`. Specify the year of the data source. Default to `2022``
- `unitsystem`   -- type: `UnitSystem`. Specify the unit system, default to `ACCELERATOR`, which sets units to 'Default units' (see above).
                                        The other options are `MKS`, and `CGS`. It provides a convient way to set all the units.
- `unitful`      -- type: `Bool`. If it is set to `true`, the constants will be a Unitful type. If it is set to `false`, it will be a `Float64`. Defualt to `false`.
                        
    
## Default units:
- `mass`: eV/c^2
- `length`: m
- `time`: s
- `energy`: eV
- `charge`: elementary charge

"""
macro APCdef(exs...)
    return quote
        #default parameter
        local CODATA = 2022
        local unitsystem = $ACCELERATOR
        local unitful = false

        #evaluate the parameter
        $(exs...)
        local mass_unit = unitsystem[1]
        local length_unit = unitsystem[2]
        local time_unit = unitsystem[3]
        local energy_unit = unitsystem[4]
        local charge_unit = unitsystem[5]
        # check dimensions of units
        if dimension(mass_unit) != dimension(u"kg")
            error("unit for mass does not have proper dimension")
        end
        if dimension(length_unit) != dimension(u"m")
            error("unit for length does not have proper dimension")
        end
        if dimension(time_unit) != dimension(u"s")
            error("unit for time does not have proper dimension")
        end
        if dimension(energy_unit) != dimension(u"J")
            error("unit for energy does not have proper dimension")
        end
        if dimension(charge_unit) != dimension(u"C")
            error("unit for charge does not have proper dimension")
        end
        const $(esc(:C_LIGHT)) =
            unitful ? uconvert(length_unit / time_unit, $__b_c_light) :
            uconvert(length_unit / time_unit, $__b_c_light).val
        const $(esc(:H_PLANCK)) =
            unitful ? uconvert(energy_unit * time_unit, $__b_h_planck) :
            uconvert(energy_unit * time_unit, $__b_h_planck).val #=  =#
        const $(esc(:H_BAR_PLANCK)) =
            unitful ? uconvert(energy_unit * time_unit, $__b_h_bar_planck) :
            uconvert(energy_unit * time_unit, $__b_h_bar_planck).val
        const $(esc(:R_E)) =
            unitful ? uconvert(length_unit, $__b_r_e) : uconvert(length_unit, $__b_r_e).val
        const $(esc(:R_P)) =
            unitful ? uconvert(length_unit, $__b_r_p) : uconvert(length_unit, $__b_r_p).val
        const $(esc(:E_CHARGE)) =
            unitful ? uconvert(charge_unit, $__b_e_charge) :
            uconvert(charge_unit, $__b_e_charge).val
        const $(esc(:MU_0_VAC)) = unitful ? $__b_mu_0_vac : $__b_mu_0_vac.val
        const $(esc(:EPS_0_VAC)) = unitful ? $__b_eps_0_vac : $__b_eps_0_vac.val
        const $(esc(:CLASSICAL_RADIUS_FACTOR)) =
            unitful ? $__b_classical_radius_factor : $__b_classical_radius_factor.val
        const $(esc(:FINE_STRUCTURE)) = $__b_fine_structure
        const $(esc(:N_AVOGADRO)) = $__b_N_avogadro

        const $(esc(:massof)) =
            (species::Species) ->
                unitful ? uconvert(mass_unit, species.mass) :
                uconvert(mass_unit, species.mass).val
        const $(esc(:chargeof)) =
            (species::Species) ->
                unitful ? uconvert(charge_unit, species.charge) :
                uconvert(charge_unit, species.charge).val
        const $(esc(:chargeof2)) = begin
            (species::Species) -> if species.populated == IsDef.Full
                (
                    unitful ? uconvert(charge_unit, species.charge) :
                    uconvert(charge_unit, species.charge).val
                )
                # else
                # 	error("""Can't get the charge of an undefined particle; 
                # 	the Species constructor for this object was called with no arguments.""")
            end
        end
    end

end


"""
    massof(
      species::Species,
    )

## Description:
return mass of 'species' in current unit.

## parameters:
- `species`     -- type:`Species`, the species whose mass you want to know
"""
massof


"""
    chargeof(
      species::Species,
    )

## Description:
return charge of 'species' in current unit.

## parameters:
- `species`     -- type:`Species`, the species whose charge you want to know

"""
chargeof

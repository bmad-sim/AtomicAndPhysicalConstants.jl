# AtomicAndPhysicalConstants/src/apc_units.jl

module unitalias
using Unitful
@unit amu "amu" amu 1.0 * u"u" false
@unit e "e" elementary_charge 1.0 * u"q" false
@unit h_bar "h_bar" reduced_planck_constant 1.0 * u"ħ" false
end


using Unitful
Unitful.register(unitalias);
using .unitalias

function __init__()
  Unitful.register(unitalias)
end

struct apc_units
  baryon_mass::Unitful.Units
  atomic_mass::Unitful.Units
  electric_charge::Unitful.Units
  length::Unitful.Units
  magnetic_field::Unitful.Units
  velocity::Unitful.Units
  energy::Unitful.Units
  magnetic_moment::Unitful.Units
  action::Unitful.Units
  permittivity::Unitful.Units
  permeability::Unitful.Units

  function apc_units(;
    baryon_mass=u"MeV/c^2", atomic_mass=u"amu",
    electric_charge=u"e", length=u"m", magnetic_field=u"T",
    magnetic_moment=u"J/T", velocity=u"m/s",
    energy=u"MeV", action=u"J*s",
    permittivity=u"F/m", permeability=u"N/A^2"
  )




    if dimension(baryon_mass) == dimension(u"eV")
      baryon_mass = baryon_mass / u"c^2"
    end
    if dimension(atomic_mass) == dimension(u"eV")
      atomic_mass = atomic_mass / u"c^2"
    end

    if dimension(baryon_mass) != dimension(u"kg")
      error("baryon_mass has been given units with improper dimensions.")
    end
    if dimension(atomic_mass) != dimension(u"kg")
      error("atomic_mass has been given units with improper dimensions.")
    end
    if dimension(electric_charge) != dimension(u"C")
      error("electric_charge has been given units with improper dimensions.")
    end
    if dimension(length) != dimension(u"m")
      error("length has been given units with improper dimensions.")
    end
    if dimension(magnetic_field) != dimension(u"T")
      error("magnetic_field has been given units with improper dimensions.")
    end
    if dimension(magnetic_moment) != dimension(u"J/T")
      error("magnetic_moment has been given units with improper dimensions.")
    end
    if dimension(velocity) != dimension(u"c")
      error("velocity has been given units with improper dimensions.")
    end
    if dimension(energy) != dimension(u"eV")
      error("energy has been given units with improper dimensions.")
    end
    if dimension(action) != dimension(u"J*s")
      error("action has been given units with improper dimensions.")
    end
    if dimension(permittivity) != dimension(u"F/m")
      error("permittivity has been given units with improper dimensions.")
    end
    if dimension(permeability) != dimension(u"N/A^2")
      error("permeability has been given units with improper dimensions.")
    end

    new(baryon_mass, atomic_mass, electric_charge, length,
      magnetic_field, velocity, energy, magnetic_moment,
      action, permittivity, permeability)
  end
end



const accelerator_units = apc_units(baryon_mass=u"eV/c^2", energy=u"eV")


const current_units = Ref(accelerator_units)
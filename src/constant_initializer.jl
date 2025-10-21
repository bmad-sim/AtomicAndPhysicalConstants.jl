# AtomicAndPhysicalConstants/src/constant_initializer.jl
struct units
  baryon_mass::String
  atom_mass::String
  length::String
  time::String
  energy::String
  charge::String
  magnetic_field::String
  spin::String

  function units(; baryon_mass::String = "MeV/c^2", atom_mass::String = "amu", length::String = "m", 
                  time::String = "s", energy::String = "MeV", 
                  charge::String = "e", magnetic_field::String = "T",
                  spin::String = "hbar")

    new(baryon_mass, atom_mass, length, time, energy, charge, magnetic_field, spin)
  end
end



function define_consts(; year::Int64 = 2022, my_units::units)::CODATA

end
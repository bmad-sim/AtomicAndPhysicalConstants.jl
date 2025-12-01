# AtomicAndPhysicalConstants/src/helpers.jl


import Base: getproperty



function getproperty(obj::Species, field::Symbol)
  
  error("Do not use the 'base.getproperty' syntax to access fields 
  of Species objects: instead use the provided functions; 
  massof, chargeof, spinof, momentof, isotopeof, kindof, or nameof.")

end; export getproperty

@doc """
    SUPERSCRIPT_MAP
    A dictionary mapping superscript characters to their corresponding integer values.
    This is used to convert superscript numbers in species names to their integer values.
"""
const SUPERSCRIPT_MAP = Dict{Char,Int64}(
  '⁰' => 0,
  '¹' => 1,
  '²' => 2,
  '³' => 3,
  '⁴' => 4,
  '⁵' => 5,
  '⁶' => 6,
  '⁷' => 7,
  '⁸' => 8,
  '⁹' => 9,
)

@doc """
    find_superscript(num::Int64)

## Description:
Convert an integer to its superscript representation.
This function takes an integer and returns a string containing the corresponding
superscript characters for each digit in the integer.
"""
find_superscript

function find_superscript(num::Int64)
  digs = reverse(digits(num))
  sup::String = ""
  for n ∈ digs
    for (k, v) in SUPERSCRIPT_MAP
      if n == v
        sup = sup * k
      end
    end
  end
  return sup
end

@doc """
    to_openPMD(val::Unitful.Quantity)
## Description:
Convert a Unitful.Quantity to a format suitable for openPMD.
Returns a tuple where the first element is the value in SI units
and the second element is a 7-tuple of  powers of the 7 base measures
characterizing the record's unit in SI 
(length L, mass M, time T, electric current I, thermodynamic temperature theta, amount of substance N, luminous intensity J)
"""
to_openPMD

function to_openPMD(val::Unitful.Quantity)
  # convert the type to DynamicQuantities, which automatically converts to SI units
  # multiplying by 1.0 ensures that the value is converted to a float
  v = convert(DynamicQuantities.Quantity, val * 1.0)
  return (
    DynamicQuantities.ustrip(v),
    (
      DynamicQuantities.ulength(v),
      DynamicQuantities.umass(v),
      DynamicQuantities.utime(v),
      DynamicQuantities.ucurrent(v),
      DynamicQuantities.utemperature(v),
      DynamicQuantities.uamount(v),
      DynamicQuantities.uluminosity(v)
    )
  )
end


# Units pulled from the NIST table of
# the 2022 CODATA release

# module NewUnits
# using Unitful
# AA = parentmodule(NewUnits)
# @unit amu "amu" Amu 1.66053906892 * 10^(-27) * u"kg" false
# @unit e "e" Elementary_charge 1.602176634e-19 * u"C" false
# @unit h_bar "h_bar" hbar 1.0 * u"ħ" false
# end


module NewUnits
using Unitful
@unit amu "amu" Dalton 1.0 * u"u" false
@unit e "e" elementary_charge 1.0 * u"q" false
@unit h_bar "h_bar" reduced_planck_constant 1.0 * u"ħ" false
end


using Unitful
Unitful.register(NewUnits);
using .NewUnits

uconvert(u"C", 1.0u"e")

uconvert(u"kg", 1.0u"amu")

uconvert(u"J*s", 2π*u"h_bar")
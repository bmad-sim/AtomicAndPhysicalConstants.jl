

# Units pulled from the NIST table of
# the 2022 CODATA release

module NewUnits
using Unitful
AA = parentmodule(NewUnits)
@unit amu "amu" Amu 1.66053906892 * 10^(-27) * u"kg" false
@unit e "e" Elementary_charge 1.602176634e-19 * u"C" false
@unit h_bar "h_bar" hbar 1.0545718176461565e-34 * u"J*s" false
end

using Unitful
Unitful.register(NewUnits);
using .NewUnits

function __init__()
    Unitful.register(NewUnits)
end

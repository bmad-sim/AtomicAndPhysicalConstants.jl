# AtomicAndPhysicalConstants.jl/src/prerelease.jl
# submodule including functions that can be used before a release year is set

module PreRelease
using Dates
function CODATA_releases()
  println("The CODATA release years available in this package now are:")
  CODATAyrs = 2002:4:2023
  for y in CODATAyrs
    println(y)
  end
  println("Previous years are not available in this package.")

  println("Note that access to a given CODATA release is often not available 
  until up to several years after the label date.")
end;
export CODATA_releases

end
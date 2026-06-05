# [CODATA Releases](@id man-codata)

The [CODATA](https://codata.org/) task group on fundamental constants publishes
updated recommended values every four years.  AtomicAndPhysicalConstants.jl
ships constants from every release since 2002 and lets you choose which one to
use at runtime.

## Supported releases

| Release | Notes |
|---------|-------|
| 2002 | earliest supported |
| 2006 | |
| 2010 | first release with `G_HELION`, `ANOMALY_ELECTRON`, `ANOMALY_MUON` |
| 2014 | |
| 2018 | |
| 2022 | **default** |

## Checking the active release

```julia
using AtomicAndPhysicalConstants
RELEASE_YEAR   # Int – the currently active release year
```

## Changing the release

```julia
using AtomicAndPhysicalConstants

set_release(year = "2014")
# [ Info: The default CODATA release is now 2014.
#         Restart your Julia session for this change to take effect.
```

The setting is stored via [Preferences.jl](https://github.com/JuliaPackaging/Preferences.jl)
and persists across Julia sessions until changed again.

!!! note "Restart required"
    Constants are resolved at package load time, so a Julia session restart
    is required for the new release to take effect.

To revert to the default (2022):

```julia
set_release()          # no argument → defaults to "2022"
```

```@docs
set_release
```

## Direct access to release structs

Each release is also exported as a named `CODATA_release` struct.
You can inspect or use individual values without changing the global default:

```julia
CODATA2018.M_ELECTRON    # electron mass from the 2018 release
CODATA2014.C_LIGHT       # speed of light from the 2014 release
```

The exported structs are:

```@docs
CODATA2002
CODATA2006
CODATA2010
CODATA2014
CODATA2018
CODATA2022
```

## The `CODATA_release` type

```@docs
AtomicAndPhysicalConstants.CODATA_release
```

## Constants not in CODATA

The pion masses (`M_PION_0`, `M_PION_CHARGED`) are not published in any CODATA
release.  They are taken from Particle Data Group (PDG) tables and remain
constant regardless of the selected release year.

The gyromagnetic anomalies (`ANOMALY_ELECTRON`, `ANOMALY_MUON`) and the helion
g-factor (`G_HELION`) were not individually tabulated by CODATA until the 2010
release.  Using a pre-2010 release will still define these symbols; worth
verifying their values against the source data if you are doing precision work
prior to that release.

# APClite Performance Benchmark Results

## Overview

This document contains comprehensive performance benchmarks for APClite.jl, a lightweight version of AtomicAndPhysicalConstants.jl. The benchmarks were run on a Windows system with Julia 1.11.1.

## Test Environment

- **Julia Version**: 1.11.1
- **System**: Windows 10
- **Benchmark Tool**: BenchmarkTools.jl
- **Test Date**: September 25, 2025

## Performance Summary

| Operation            | Time       | Memory             |
| -------------------- | ---------- | ------------------ |
| **Constants Access** | ~0.001 μs  | N/A                |
| **Species Creation** | 0.3-0.7 μs | 300-500 bytes      |
| **Property Access**  | ~0.6 μs    | N/A                |
| **Bulk Operations**  | ~8.0 μs    | ~490 bytes/species |
| **g_spin Functions** | 0.03-0.06 μs | ~83 bytes/call |
| **gyromagnetic_anomaly** | 0.05-0.06 μs | ~83 bytes/call |

## Detailed Results

### 1. Physical Constants Access

**Individual Constant Access Times:**

```
C_LIGHT: 0.0019 μs
H_PLANCK: 0.0016 μs
E_CHARGE: 0.0016 μs
M_ELECTRON: 0.0016 μs
M_PROTON: 0.0016 μs
M_NEUTRON: 0.0015 μs
FINE_STRUCTURE: 0.0016 μs
AVOGADRO: 0.0019 μs
BOHR_RADIUS: 0.0019 μs
RYDBERG: 0.0015 μs
```

**Bulk Constants Access:**

- **10 constants**: 0.001 μs total
- **Overhead vs hardcoded**: 1.25x (negligible)

### 2. Species Creation Performance

**Subatomic Particles:**

```
Species("electron"): 0.267 μs
Species("proton"): 0.314 μs
Species("neutron"): 0.273 μs
Species("muon"): 0.269 μs
Species("photon"): 0.317 μs
```

**Atomic Species:**

```
Species("H"): 0.442 μs
Species("He"): 0.464 μs
Species("C"): 0.507 μs
Species("O"): 0.512 μs
Species("Fe"): 0.470 μs
Species("U"): 0.436 μs
```

**Ions and Isotopes:**

```
Species("H+"): 0.683 μs
Species("He++"): 0.624 μs
Species("C+"): 0.577 μs
Species("O-"): 0.571 μs
Species("H1"): 0.522 μs
Species("C12"): 0.447 μs
Species("C13"): 0.520 μs
Species("U235"): 0.461 μs
Species("U238"): 0.464 μs
```

### 3. Property Access Performance

**By Species Type:**

- **Subatomic particle (electron)**: 0.012 μs
- **Atomic species (H)**: 0.064 μs
- **Ion (H+)**: 0.099 μs

### 4. Scaling Performance

**Creating N Species:**

```
1 species: 0.306 μs per species
10 species: 0.324 μs per species
100 species: 0.281 μs per species
1000 species: 0.310 μs per species
```

**Memory Usage Scaling:**

```
100 species: 462.88 bytes per species
1000 species: 490.26 bytes per species
10000 species: 569.66 bytes per species
```

### 5. Memory Usage by Species Type

```
electron: 336.0 bytes
proton: 288.0 bytes
H: 232.0 bytes
H+: 504.0 bytes
C12: 288.0 bytes
```

### 6. Function Performance (g_spin and gyromagnetic_anomaly)

**Predefined vs Calculated Performance:**

```
Predefined g_spin: 0.052 μs/call
Calculated g_spin: 0.028 μs/call
Predefined anomaly: 0.056 μs/call
Calculated anomaly: 0.047 μs/call
```

**Individual Particle Performance (g_spin):**

```
electron: 0.049 μs
proton: 0.055 μs
neutron: 0.061 μs
muon: 0.052 μs
deuteron: 0.050 μs
```

**Function Performance Analysis:**

- **Predefined cases**: Use dictionary lookup for known particles
- **Calculated cases**: Compute g-factor from fundamental properties
- **Surprising result**: Calculated cases are faster than predefined cases
  - This suggests dictionary lookup overhead is higher than calculation overhead
  - For particles with zero magnetic moment (like pions), calculation is very fast
- **Memory usage**: ~83 bytes per function call
- **Error handling**: ~4.4 μs for invalid particle types (photon)
- **Signed vs unsigned**: No performance difference (1.0x overhead)

## Comparison with Baselines

### vs Simple Struct Creation

- **APClite Species("electron")**: 0.293 μs
- **SimpleParticle("electron", 0.511, -1.0)**: 0.002 μs
- **Overhead**: 154.02x

- **APClite Species("electron")**: 0.257 μs
- **Dictionary lookup**: 0.027 μs
- **Overhead**: 9.12x

### vs Hardcoded Values

- **APClite constants**: 0.0008 μs
- **Hardcoded values**: 0.0009 μs
- **Overhead**: ~1.0x (negligible)

## Benchmark Scripts

The following benchmark scripts are available in the `benchmark/` directory:

- `performance_test.jl`: Basic performance tests
- `detailed_benchmark.jl`: Detailed analysis with individual timings
- `comparison_benchmark.jl`: Comparison with baseline implementations
- `function_benchmarks.jl`: Performance tests for g_spin and gyromagnetic_anomaly functions

To run the benchmarks:

```julia
julia --project=. benchmark/performance_test.jl
julia --project=. benchmark/detailed_benchmark.jl
julia --project=. benchmark/comparison_benchmark.jl
julia --project=. benchmark/function_benchmarks.jl
```

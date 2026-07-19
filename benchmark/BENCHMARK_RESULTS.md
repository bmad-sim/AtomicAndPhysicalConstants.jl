# AtomicAndPhysicalConstants.jl Performance Benchmark Results

## Overview

This document contains performance benchmarks for AtomicAndPhysicalConstants.jl.

## Test Environment

- **Julia Version**: 1.12.6
- **System**: macOS (Darwin, aarch64)
- **Benchmark Tool**: BenchmarkTools.jl
- **Test Date**: July 5, 2026

## Performance Summary

| Operation                | Time           | Memory                |
| ------------------------ | -------------- | --------------------- |
| **Constants Access**     | ~0.002 μs      | N/A                   |
| **Species Creation**     | 0.05-0.6 μs    | 0-544 bytes           |
| **Property Access**      | ~0.005-0.1 μs  | N/A                   |
| **Bulk Operations**      | ~6.3 μs        | ~0.15-0.17 KB/species |
| **gspin_of**             | ~0.002 μs/call | 0 bytes/call          |
| **gyromagnetic_anomaly** | ~0.001 μs/call | 0 bytes/call          |

## Detailed Results

### 1. Physical Constants Access

**Individual Constant Access Times:**

```
C_LIGHT: 0.0021 μs
H_PLANCK: 0.0021 μs
E_CHARGE: 0.0021 μs
M_ELECTRON: 0.0021 μs
M_PROTON: 0.0021 μs
M_NEUTRON: 0.0021 μs
FINE_STRUCTURE: 0.0021 μs
AVOGADRO: 0.0021 μs
R_ELECTRON: 0.0021 μs
R_PROTON: 0.0021 μs
EPS_0: 0.0021 μs
MU_0: 0.0021 μs
```

All exported constants are plain `Float64` globals, so access is effectively free regardless of which constant is read.

### 2. Species Creation Performance

**Subatomic Particles:**

```
Species("electron"): 0.049 μs
Species("proton"): 0.053 μs
Species("neutron"): 0.066 μs
Species("muon"): 0.104 μs
Species("photon"): 0.101 μs
```

**Atomic Species:**

```
Species("H"): 0.456 μs
Species("He"): 0.472 μs
Species("C"): 0.455 μs
Species("O"): 0.457 μs
Species("Fe"): 0.474 μs
Species("U"): 0.455 μs
```

**Ions and Isotopes:**

```
Species("H+"): 0.540 μs
Species("He++"): 0.571 μs
Species("C+"): 0.537 μs
Species("O-"): 0.585 μs
Species("#1H"): 0.492 μs
Species("#12C"): 0.501 μs
Species("#13C"): 0.500 μs
Species("#235U"): 0.519 μs
Species("#238U"): 0.515 μs
```

Atomic and ionic species generally take longer to construct than subatomic particles since parsing involves element symbol/mass-number/charge-state lookups; subatomic particles are simple dictionary lookups in `SUBATOMIC_SPECIES`. Species construction across the board is substantially faster than in the previous benchmark run, consistent with the constructor efficiency work in `constructors.jl`.

### 3. Property Access Performance

**By Species Type** (using `chargeof`, `massof`, `spinof`, `kindof`, `iso_of`):

- **Subatomic particle (electron)**: 0.005 μs
- **Atomic species (H)**: 0.005 μs
- **Ion (H+)**: 0.095 μs

`Species` is an immutable struct; the accessor functions are direct field reads (`Base.getproperty` is explicitly disabled for `Species` and errors if called directly — use the accessor functions instead).

### 4. Scaling Performance

**Creating N Species:**

```
1 species: 0.072 μs per species
10 species: 0.067 μs per species
100 species: 0.052 μs per species
1000 species: 0.051 μs per species
```

**Memory Usage Scaling:**

```
100 species: 137.44 bytes per species
1000 species: 161.26 bytes per species
10000 species: 166.87 bytes per species
```

### 5. Memory Usage by Species Type

```
electron: 0.0 bytes
proton: 0.0 bytes
H: 480.0 bytes
H+: 544.0 bytes
12C: 512.0 bytes
```

Subatomic particle construction allocates nothing measurable (the compiler can stack-allocate the immutable `Species` struct); atomic/ionic species allocate more due to string handling during name parsing.

### 6. Function Performance (gspin_of and gyromagnetic_anomaly)

`gspin_of` reads the g-factor stored on the `Species` at construction time — there is no separate "predefined vs. calculated" code path in the current implementation, so both predefined particles (electron, proton, ...) and particles without a tabulated magnetic moment cost the same.

```
gspin_of (8 species): 0.006 μs total, ~0.001 μs/call
gyromagnetic_anomaly (8 species): 0.005 μs total, ~0.001 μs/call
Signed vs unsigned gspin_of: no measurable difference (1.0x overhead)
```

**Individual Particle Performance (gspin_of):**

```
electron: 0.002 μs
positron: 0.002 μs
proton: 0.002 μs
neutron: 0.002 μs
muon: 0.002 μs
deuteron: 0.002 μs
pion+: 0.002 μs
pion-: 0.002 μs
```

**Notes:**

- `gyromagnetic_anomaly` returns `NaN` (not an error) for photons, atoms, and the null species, since the anomaly is undefined for them — this NaN-returning path is the same cost as the normal path (~0.002 μs).
- Memory allocation for both functions is 0 bytes across all tested species.

## Comparison with Baselines

### vs Simple Struct Creation

- **AtomicAndPhysicalConstants Species("electron")**: 0.049 μs
- **SimpleParticle("electron", 0.511, -1.0)**: 0.002 μs
- **Overhead**: 22.75x

### vs Dictionary Lookup

- **AtomicAndPhysicalConstants Species("electron")**: 0.049 μs
- **Dictionary lookup**: 0.031 μs
- **Overhead**: 1.57x

### vs Hardcoded Values

- **AtomicAndPhysicalConstants constants**: 0.0012 μs
- **Hardcoded values**: 0.0012 μs
- **Overhead**: 1.0x (negligible)

### Memory vs Simple Struct

Both `Species("electron")` and `SimpleParticle(...)` benchmarked at 0 bytes median allocation (both are immutable and the compiler elides heap allocation), so the memory overhead ratio is undefined (0/0) for this comparison.

## Benchmark Scripts

The following benchmark scripts are available in the `benchmark/` directory:

- `performance_test.jl`: Basic performance tests
- `apc_performance_test.jl`: Equivalent basic performance tests (duplicate of `performance_test.jl`)
- `detailed_benchmark.jl`: Detailed analysis with individual timings
- `comparison_benchmark.jl`: Comparison with baseline implementations
- `function_benchmarks.jl`: Performance tests for `gspin_of` and `gyromagnetic_anomaly`

To run the benchmarks:

```julia
julia --project=. benchmark/performance_test.jl
julia --project=. benchmark/apc_performance_test.jl
julia --project=. benchmark/detailed_benchmark.jl
julia --project=. benchmark/comparison_benchmark.jl
julia --project=. benchmark/function_benchmarks.jl
```

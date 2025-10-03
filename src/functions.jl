"""
Functions for APClite.jl

This module provides utility functions for working with Species objects.
"""

massof(species::Species) = species.mass
chargeof(species::Species) = species.charge
atomicnumberof(species::Species) = species.iso
kindof(species::Species) = species.kind
g_spin(species::Species) = species.g_factor
gyromagnetic_anomaly(species::Species) = (g_spin(species) - 2) / 2
isnullspecies(species_ref::Species) = getfield(species_ref, :kind) == Kind.NULL

# Supervised Learning for Multi Zone Sound Field Reproduction under Harsh Environmental Conditions

This repository provides the source code that was used to create the data for the paper "Supervised Learning for Multi Zone Sound Field Reproduction under Realistic Conditions".

The networks of the two mainly considered are located in ./data/nets.

You can change settings of the simulation in the parameter file ./lib/lib_parameter/parameter.m. CAUTION! Especially when reading in previously trained networks make sure to not change anything in the position of the microphones. In this regard the code is not protected from missuse.

I hope the commenting in the code is suffitient and the naming convention is well understandable. Have fun with the code!

Executing the main.m file runs the code.
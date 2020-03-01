# computerArchitectureLab
_Reports from the lab assignments, for the Computer Architecure course, school of Electrical and Computer Enginneering, AUTH._

#### Note: The report for each project (in greek) is located at the readme.md file of the corresponding folder.

## Brief description of every assignment
* **Lab1: Introduction to gem5**
  * Building gem5, running example programs and collecting statistics.
  * Cross compiling our program for ARM architecture.
  * Investigating differences of CPU models.
* **Lab2: Design space exploration with gem5**
  * Running 5 SPEC cpu2006 benchmark programs with different parameters (cache sizes, associativity and cache line size).
  * Collecting the results, plotting and deciding the best architecture for each spec program in terms of performance.
* **Lab3: Energy-Delay-Area product optimization (gem5 + McPAT)**
  * Gathering power statistics from each architecture used in Lab2, using McPAT.
  * Collecting the results, plotting the area and power and deciding the best architecture for each spec program, in terms of efficiency (EDAP).

## Scripts created by us
 * [run_benches.bash](spec_results_scripts_tools/run_beches.bash) for running ~100 simulations with diefferent parameter sets.
 * [mcpat_analyze.bash](spec_results_scripts_tools/mcpat_analyze.bash) for analyzing the different architectures with mcpat and extracting the results.
 * [make_graphs.m](spec_results_scripts_tools/make_graphs.m) for plotting the CPI for every simulation.
 * [make_energy_graphs.m](spec_results_scripts_tools/make_energy_graphs.m) for plotting the mcpat output for each different architecture.

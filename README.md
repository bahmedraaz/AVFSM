# AVFSM
Fault-Injection Vulnerability Analysis in Finite State Machine at Gate-level

Instructions on running AVFSM Tool:


Tools required: Matlab, Tetramax

Run instruction: Run AVFSM.bash to get the output. All the modification needs to be in module_main.txt


1. Source files: (Needs to be placed in same folder)
 
a. module_main.txt
An .txt file where the module name, file and the library directory, and the state encoding of the protected state needs to be mentioned. All the modification needs to be done here.

b. AVFSM.bash
Run to get the output. 
            
c. patt_gen.m
Produces the modified netlist needed for AVFSM framework. Also, produces the script for Tetramax analysis.

d. fault_analysis.m
Produces the state transition graph (STG) and calculates the metric for vulnerability assesment to fault attack

e. fault_finder.m
Function used by fault_analysis.




2. Required file: (Needs to be placed in thr Required_files folder)

a. Module_name.txt
The gate level netlist ofthe DUV. MUST BE IN .txt FORMAT. Needs to be synthesized with GSCLib (Cadence 180nm Library).

b. report_fsm
Generated during synthesis of the FSM module. Contains the state register names and state encodings.

c. static_time.rpt
The timing delays of the input paths to the state registers.




3. Outputs Generated: (In folder named Reports)

a. Fault_Details
susceptibility factor of each vulnerable transition

b. STG:
Extracted state transition graph.

c. funtioncalls
.dot file for STG visualization. This file can be visualized using GraphViz tool.

read_netlist /home/UFAD/adib1991/Desktop/GSCLib_3.0/verilog/GSCLib_3.0.v -library 
 read_netlist /home/UFAD/adib1991/Desktop/HARPOON/AVFSM_AES/IFT/aes_binary_3.v 
 run_build_model aes_binary 
 drc -force 
 run_build_model aes_binary 
 add_pi_constraints 0 {state_next[2]}  
 add_pi_constraints 0 {state_next[1]}  
 add_pi_constraints 1 {state_next[0]}  
 run_drc 
 remove_faults -all 
 add_faults  aes_binary/n10004 -stuck 1 
 set_atpg -decision random 
 run_atpg -ndetects 100 
 report_patterns -all 
 report_patterns -all > pattern1.rpt 
 drc -force 
 run_build_model aes_binary 
 add_pi_constraints 0 {state_next[2]}  
 add_pi_constraints 1 {state_next[1]}  
 add_pi_constraints 0 {state_next[0]}  
 run_drc 
 remove_faults -all 
 add_faults  aes_binary/n10004 -stuck 1 
 set_atpg -decision random 
 run_atpg -ndetects 100 
 report_patterns -all 
 report_patterns -all > pattern2.rpt 
 drc -force 
 run_build_model aes_binary 
 add_pi_constraints 0 {state_next[2]}  
 add_pi_constraints 1 {state_next[1]}  
 add_pi_constraints 1 {state_next[0]}  
 run_drc 
 remove_faults -all 
 add_faults  aes_binary/n10004 -stuck 1 
 set_atpg -decision random 
 run_atpg -ndetects 100 
 report_patterns -all 
 report_patterns -all > pattern3.rpt 
 drc -force 
 run_build_model aes_binary 
 add_pi_constraints 1 {state_next[2]}  
 add_pi_constraints 0 {state_next[1]}  
 add_pi_constraints 0 {state_next[0]}  
 run_drc 
 remove_faults -all 
 add_faults  aes_binary/n10004 -stuck 1 
 set_atpg -decision random 
 run_atpg -ndetects 100 
 report_patterns -all 
 report_patterns -all > pattern4.rpt 
 drc -force 
 run_build_model aes_binary 
 add_pi_constraints 0 {state_next[2]}  
 add_pi_constraints 0 {state_next[1]}  
 add_pi_constraints 0 {state_next[0]}  
 run_drc 
 remove_faults -all 
 add_faults  aes_binary/n10004 -stuck 1 
 set_atpg -decision random 
 run_atpg -ndetects 100 
 report_patterns -all 
 report_patterns -all > pattern5.rpt 
 exit
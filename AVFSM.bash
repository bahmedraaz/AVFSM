matlab -nodisplay -nodesktop -r "patt_gen"


cd ./IFT

tmax -shell tmax_script.tcl

cd ..

matlab -nodisplay -nodesktop -r "fault_analysis"







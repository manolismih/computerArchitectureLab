#!/bin/bash
echo -e Energy '\t' Peak Power '\t' Area '\t' Delay '\t' EDAP_product > allResultsEnergy.txt
folders=$(find -mindepth 1 -maxdepth 1 -type d | sort)
for i in $folders
do 
	./GEM5ToMcPAT.py "$i/stats.txt" "$i/config.json" inorder_arm.xml -o "$i/mcpat.xml"
	~/cmcpat/mcpat/mcpat -infile "$i/mcpat.xml" -print_level 5 > "$i/mcpat.out"
	./print_energy.py "$i/mcpat.out" "$i/stats.txt" > "$i/energy.txt"
	energy=$(grep energy $i/energy.txt | sed s/[^0-9\.]//g)
	pPower=$(grep 'Peak Power' $i/mcpat.out | sed s/[^0-9\.]//g)
	area1=$(sed '62!d' $i/mcpat.out | sed s/[^0-9\.]//g)
	area2=$(sed '278!d' $i/mcpat.out | sed s/[^0-9\.]//g)
	area=$(echo "$area1 + $area2" | bc)
	delay=$(grep sim_seconds $i/stats.txt | sed s/[^0-9\.]//g)
	edap=$(echo "$area" \* "$energy" \* "$delay" | bc)
	echo -e "$i" '\t' $energy '\t' $pPower '\t' $area '\t' $delay '\t' $edap >> allResultsEnergy.txt
done


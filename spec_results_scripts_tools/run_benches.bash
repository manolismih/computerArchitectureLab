#!/bin/bash

BENCH=('bzip2' 'mcf' 'hmmer' 'sjeng' 'lbm')
SPECS=('--l1i_size=' '--l1i_assoc=' '--l1d_size=' '--l1d_assoc=' '--l2_size=' '--l2_assoc=' '--cacheline_size=')
DEFAULT=('128kB' '4' '64kB' '4' '1MB' '4' '32')
OPTIONS=('64kB 32kB' '1 2 8' '128kB 32kB' '1 2 8' '4MB 2MB 512kB' '1 2 8' '64 16')
PROGRAM[0]='-c spec_cpu2006/401.bzip2/src/specbzip -o "spec_cpu2006/401.bzip2/data/input.program 10" -I 100000000' 
PROGRAM[1]='-c spec_cpu2006/429.mcf/src/specmcf -o "spec_cpu2006/429.mcf/data/inp.in" -I 100000000' 
PROGRAM[2]='-c spec_cpu2006/456.hmmer/src/spechmmer -o "--fixed 0 --mean 325 --num 45000 --sd 200 --seed 0 spec_cpu2006/456.hmmer/data/bombesin.hmm" -I 100000000' 
PROGRAM[3]='-c spec_cpu2006/458.sjeng/src/specsjeng -o "spec_cpu2006/458.sjeng/data/test.txt" -I 100000000' 
PROGRAM[4]='-c spec_cpu2006/470.lbm/src/speclibm -o "20 spec_cpu2006/470.lbm/data/lbm.in 0 1 spec_cpu2006/470.lbm/data/100_100_130_cf_a.of" -I 100000000'


G5='./build/ARM/gem5.opt'
M5OUT=' -d spec_results/spec' ####add bench name + change in spec
PYSCRIPT=' configs/example/se.py --cpu-type=MinorCPU --caches --l2cache'

for (( i=0; i<${#BENCH[*]}; i++ ))
do 
	##default parameters
	spec_options=""
	for (( j=0; j<${#SPECS[*]}; j++ )) 
	do
		spec_options=" $spec_options${SPECS[j]}${DEFAULT[j]} "
	done
	echo $G5 $M5OUT${BENCH[i]}-default $PYSCRIPT $spec_options ${PROGRAM[i]} &
	
	#### non-default
	for (( differ=0; differ<${#SPECS[*]}; differ++ ))
	do
		for option in ${OPTIONS[$differ]}
		do
			spec_options=${SPECS[$differ]}$option
			for (( spec=0; spec<${#SPECS[*]}; spec++ ))
			do
				if [ $spec != $differ ]
				then
					spec_options="$spec_options ${SPECS[$spec]}${DEFAULT[$spec]} "
				fi
			done
			
			echo $G5 $M5OUT${BENCH[i]}-${SPECS[differ]}$option $PYSCRIPT $spec_options ${PROGRAM[i]} &
		done
	done

done


#~ ./build/ARM/gem5.opt -d spec_results/specbzip configs/example/se.py --cpu-type=MinorCPU --caches --l2cache -c spec_cpu2006/401.bzip2/src/specbzip -o "spec_cpu2006/401.bzip2/data/input.program 10" -I 100000000 > log1.txt
#~ ./build/ARM/gem5.opt -d spec_results/specmcf configs/example/se.py --cpu-type=MinorCPU --caches --l2cache -c spec_cpu2006/429.mcf/src/specmcf -o "spec_cpu2006/429.mcf/data/inp.in" -I 100000000 > log2.txt
#~ ./build/ARM/gem5.opt -d spec_results/spechmmer configs/example/se.py --cpu-type=MinorCPU --caches --l2cache -c spec_cpu2006/456.hmmer/src/spechmmer -o "--fixed 0 --mean 325 --num 45000 --sd 200 --seed 0 spec_cpu2006/456.hmmer/data/bombesin.hmm" -I 100000000 > log3.txt
#~ ./build/ARM/gem5.opt -d spec_results/specsjeng configs/example/se.py --cpu-type=MinorCPU --caches --l2cache -c spec_cpu2006/458.sjeng/src/specsjeng -o "spec_cpu2006/458.sjeng/data/test.txt" -I 100000000 > log4.txt
#~ ./build/ARM/gem5.opt -d spec_results/speclibm configs/example/se.py --cpu-type=MinorCPU --caches --l2cache -c spec_cpu2006/470.lbm/src/speclibm -o "20 spec_cpu2006/470.lbm/data/lbm.in 0 1 spec_cpu2006/470.lbm/data/100_100_130_cf_a.of" -I 100000000 > log5.txt

#~ ./build/ARM/gem5.opt -d spec_results/speclibm  --cpu-type=MinorCPU --caches --l2cache --l1d_size=32kB --l1i_size=64kB --l2_size=512kB --l1i_assoc=1 --l1d_assoc=1 --l2_assoc=2 --cacheline_size=64 --cpu-clock=1GHz -c spec_cpu2006/470.lbm/src/speclibm -o "20 spec_cpu2006/470.lbm/data/lbm.in 0 1 spec_cpu2006/470.lbm/data/100_100_130_cf_a.of" -I 100000000

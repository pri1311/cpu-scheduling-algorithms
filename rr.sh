# Bash script to implement Round Robin CPU scheduling algorithm.

sort(){
	for ((i = 0; i<$n; i++)) 
	do
	      
	    for((j = 0; j<`expr $n - $i - 1`; j++)) 
	    do
	      
		if [ ${arrival_time[j]} -gt ${arrival_time[$((j+1))]} ] 
		then
		    # swap 
		    temp=${arrival_time[j]} 
		    arrival_time[$j]=${arrival_time[$((j+1))]}   
		    arrival_time[$((j+1))]=$temp 
		    
		    temp=${burst_time[j]} 
		    burst_time[$j]=${burst_time[$((j+1))]}   
		    burst_time[$((j+1))]=$temp
		    
		    temp=${pid[j]} 
		    pid[$j]=${pid[$((j+1))]}   
		    pid[$((j+1))]=$temp
		    
		    temp=${burst_time_copy[$j]} 
		    burst_time_copy[$j]=${burst_time_copy[$i]}   
		    burst_time_copy[$i]=$temp
		    
		    temp=${arrival_time_copy[$j]} 
		    arrival_time_copy[$j]=${arrival_time_copy[$i]}   
		    arrival_time_copy[$i]=$temp
		    
		elif [ ${arrival_time[j]} -eq ${arrival_time[$((j+1))]} ]
		then
			if [ ${pid[j]} -eq ${pid[$((j+1))]} ]
			then
			    temp=${arrival_time[j]} 
			    arrival_time[$j]=${arrival_time[$((j+1))]}   
			    arrival_time[$((j+1))]=$temp 
			    
			    temp=${burst_time[j]} 
			    burst_time[$j]=${burst_time[$((j+1))]}   
			    burst_time[$((j+1))]=$temp
			    
			    temp=${pid[j]} 
			    pid[$j]=${pid[$((j+1))]}   
			    pid[$((j+1))]=$temp
			    
			    temp=${burst_time_copy[$j]} 
			    burst_time_copy[$j]=${burst_time_copy[$i]}   
			    burst_time_copy[$i]=$temp
			    
			    temp=${arrival_time_copy[$j]} 
			    arrival_time_copy[$j]=${arrival_time_copy[$i]}   
			    arrival_time_copy[$i]=$temp
			fi
		fi
	    done
	done
}

border(){
	z=121
	for ((i=0; i<$z; i++))
	do
	echo -n "-"
	done
	echo ""
}

calcWaitingtime(){
	t=0
	arrival=0
	is_completed=0
	
	while [ $is_completed -eq 0 ]
	do
		is_completed=1
		for ((i=0; i<$n; i++))
		do
			chart[$t]=`expr $i + 1`
			if [ ${burst_time[$i]} -gt 0 ]
			then
				is_completed=0
				if [ ${burst_time[$i]} -gt $quantum -a ${arrival_time[$i]} -le $arrival ]
				then
					for ((j=0; j<$quantum; j++))
					do
						chart[$t]=`expr $i + 1`
						((t++))
					done
					#t=`expr $t + $quantum`
					burst_time[$i]=`expr ${burst_time[$i]} - $quantum`
					((arrival++))
				else
					if [ ${arrival_time[$i]} -le $arrival ]
					then
						((arrival++))
						for ((j=0; j<${burst_time[$i]}; j++))
						do
							chart[$t]=`expr $i + 1`
							((t++))
						done
						#t=`expr $t + ${burst_time[$i]}`
						burst_time[$i]=0
						completion_time[$i]=$t
					fi
				fi
			fi
		done
		if [ $is_completed -eq 1 ]
		then
			h=$t
		fi
	done
	
	for ((i=0; i<$n; i++))
	do
		tat[$i]=`expr ${completion_time[$i]} - ${arrival_time_copy[$i]}`
		waiting_time[$i]=`expr ${tat[$i]} - ${burst_time_copy[$i]}`
	done
	
	total_wt=0
	total_tat=0
	border
	printf "|%-18s|%-20s|%-18s|%-20s|%-18s|%-20s|\n" "Process Id" "Burst time" "Arrival time" "Waiting time" "Turn around time" "Completion time"
	border
	for ((i=0; i<$n; i++))
	do
		total_wt=`expr $total_wt + ${waiting_time[$i]}`
		total_tat=`expr ${tat[$i]} + $total_tat`
		completion_time=`expr ${arrival_time[$i]} + ${tat[$i]}`
		printf "|%-18s|%-20s|%-18s|%-20s|%-18s|%-20s|\n" ${pid[$i]} ${burst_time_copy[$i]} ${arrival_time_copy[$i]} ${waiting_time[$i]} ${tat[$i]} $completion_time
		#echo "${burst_time[$i]}     ${arrival_time[$i]}     ${waiting_time[$i]}       ${tat[$i]}        ${completion_time[$i]}"
	done
	border
	avgwt=`echo "scale=3; $total_wt / $n" | bc`
	echo "Average waiting time = $avgwt"
	avgtat=`echo "scale=3; $total_tat / $n" | bc`
	echo "Average turn around time = $avgtat"


	count_cols=1
	cols_id[0]=${chart[0]}
	cols[0]=0
	j=1
	for ((i=1; i<$h; i++))
	do
		if [ ${chart[$i]} -ne ${chart[`expr $i - 1`]} ]
		then
			((count_cols++))
			cols[$j]=$i
			cols_id[$j]=${chart[$i]}
			((j++))
		fi
	done

	echo ""

	for ((i=0; i<8*count_cols+count_cols+1; i++))
	do
		echo -n "-"
		done
		echo ""

	for ((i=0; i<$count_cols; i++))
	do
		echo -n "|   "
		echo -n "P${cols_id[$i]}"
		echo -n "   "
	done
	echo "|"
	for ((i=0; i<8*count_cols+count_cols+1; i++))
	do
		echo -n "-"
		done
		echo ""
	echo -n "0	"
	for ((i=1; i<$count_cols; i++))
	do
		echo -n "${cols[$i]}"
		echo -n "	   "
	done
	echo -n "$h"
	echo ""
}






















echo -n "Enter the number of processes: "
read n
for ((i=0; i<$n; i++))
do
echo -n "Enter Process Id: "
read pid[$i]
echo -n "Enter arrival time: "
read arrival_time[$i]
arrival_time_copy[$i]=${arrival_time[$i]}
echo -n "Enter burst time: "
read burst_time[$i]
burst_time_copy[$i]=${burst_time[$i]}
done
echo -n "Enter quantum size: "
read quantum
sort
calcWaitingtime
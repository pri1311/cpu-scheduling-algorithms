# Bash script to implement first come first served CPU scheduling algorithm.

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

findWaitingTime(){
	service_time[0]=0
	waiting_time[0]=0
	for ((i=1; i<$n; i++))
	do
		z=1
		y=`expr $i - $z`
		service_time[$i]=`expr ${service_time[$y]} + ${burst_time[$y]} `
		waiting_time[$i]=`expr ${service_time[$i]} - ${arrival_time[$i]}`
		if [ ${waiting_time[$i]} -lt 0 ]
		then
			waiting_time[$i]=0
		fi
	done
}

findTurnAroundTime(){
	for ((i=0; i<$n; i++))
	do
		tat[$i]=`expr ${waiting_time[$i]} + ${burst_time[$i]}`
	done
}

findAverageTime(){
	sort
	findWaitingTime
	findTurnAroundTime
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
		printf "|%-18s|%-20s|%-18s|%-20s|%-18s|%-20s|\n" ${pid[$i]} ${burst_time[$i]} ${arrival_time[$i]} ${waiting_time[$i]} ${tat[$i]} $completion_time
		#echo "${burst_time[$i]}     ${arrival_time[$i]}     ${waiting_time[$i]}       ${tat[$i]}         $completion_time"
	done
	border
	#avgwt=`echo "scale=3; $total_wt / $n" | bc`
	echo -n "Average waiting time ="
    printf %.3f\\n "$(($total_wt / $n))"
	#avgtat=`echo "scale=3; $total_tat / $n" | bc`
	echo -n "Average turn around time ="
    printf %.3f\\n "$(($total_tat / $n))"
	
	for ((i=0; i<8*n+n+1; i++))
	do
		echo -n "-"
		done
		echo ""

	for ((i=0; i<$n; i++))
	do
		echo -n "|   "
		echo -n "P${pid[$i]}"
		echo -n "   "
	done
	echo "|"
	for ((i=0; i<8*n+n+1; i++))
	do
		echo -n "-"
		done
		echo ""
	echo -n "0	"
	for ((i=0; i<$n; i++))
	do
		echo -n "`expr ${arrival_time[$i]} + ${tat[$i]}`"
		echo -n "	   "
	done
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
echo -n "Enter burst time: "
read burst_time[$i]
done
findAverageTime


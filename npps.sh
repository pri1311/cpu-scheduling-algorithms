# Bash Script to implement Priority Scheduling Algorithm (non pre-emptive)

border(){
	z=121
	for ((i=0; i<$z; i++))
	do
	    echo -n "-"
	done
	echo ""
}


arrangeArrival(){
	z=1
	for ((i=0; i<$n; i++))
	do
		for ((j=i+1; j<$n; j++))
		do
			if [ ${arrival_time[$i]} -gt ${arrival_time[$j]} ]
			then
			    temp=${arrival_time[$j]} 
			    arrival_time[$j]=${arrival_time[$i]}   
			    arrival_time[$i]=$temp 
			    
			    temp=${burst_time[$j]} 
			    burst_time[$j]=${burst_time[$i]}   
			    burst_time[$i]=$temp
			    
			    temp=${priority[$j]} 
			    priority[$j]=${priority[$i]}   
			    priority[$i]=$temp
			    
			    temp=${pid[$j]} 
			    pid[$j]=${pid[$i]}   
			    pid[$i]=$temp
			fi
		done
	done
}

arrangePriority(){
	z=1
	for ((i=0; i<$n; i++))
	do
		for ((j=i+1; j<$n; j++))
		do
			if [ ${arrival_time[$i]} -eq ${arrival_time[$j]} ]
			then
				if [ ${priority[$i]} -gt ${priority[$j]} ]
				then
				    temp=${arrival_time[$j]} 
				    arrival_time[$j]=${arrival_time[$i]}   
				    arrival_time[$i]=$temp 
				    
				    temp=${burst_time[$j]} 
				    burst_time[$j]=${burst_time[$i]}   
				    burst_time[$i]=$temp
				    
				    temp=${priority[$j]} 
				    priority[$j]=${priority[$i]}   
				    priority[$i]=$temp
				    
				    temp=${pid[$j]} 
				    pid[$j]=${pid[$i]}   
				    pid[$i]=$temp
				fi
			fi
		done
	done
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
echo -n "Enter priority: "
read priority[$i]
done
arrangeArrival
arrangePriority
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
avgwt=`echo "scale=3; $total_wt / $n" | bc`
echo "Average waiting time = $avgwt"
avgtat=`echo "scale=3; $total_tat / $n" | bc`
echo "Average turn around time = $avgtat"


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
	echo -n "`expr ${arrival_time[$i]} + ${tat[$i]}`	   "
done
echo ""
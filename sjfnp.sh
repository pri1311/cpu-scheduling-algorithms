# Bash Script to implement Shortest Job First Scheduling Algorithm (non pre-emptive)

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
			    
			    temp=${pid[$j]} 
			    pid[$j]=${pid[$i]}   
			    pid[$i]=$temp
			fi
		done
	done
}

arrangeBurst(){
	z=1
	for ((i=0; i<$n; i++))
	do
		for ((j=i+1; j<$n; j++))
		do
			if [ ${arrival_time[$i]} -eq ${arrival_time[$j]} ]
			then
				if [ ${burst_time[$i]} -gt ${burst_time[$j]} ]
				then
				    temp=${arrival_time[$j]} 
				    arrival_time[$j]=${arrival_time[$i]}   
				    arrival_time[$i]=$temp 
				    
				    temp=${burst_time[$j]} 
				    burst_time[$j]=${burst_time[$i]}   
				    burst_time[$i]=$temp
				    
				    temp=${pid[$j]} 
				    pid[$j]=${pid[$i]}   
				    pid[$i]=$temp
				fi
			fi
		done
	done
}

completionTime(){
	completion_time[0]=`expr ${arrival_time[0]} + ${burst_time[0]}`
	tat[0]=`expr ${completion_time[0]} - ${arrival_time[0]}`
	waiting_time[0]=`expr ${tat[0]} - ${burst_time[0]}`
	for ((i=1; i<$n; i++))
	do
		temp=${completion_time[`expr $i - 1`]}
		low=${burst_time[$i]}
		for ((j=i; j<$n; j++))
		do
			if [ $temp -ge ${arrival_time[$j]} ]
			then
				if [ $low -ge ${burst_time[$j]} ]
				then
					low=${burst_time[$j]}
					val=$j
				fi
			fi
		done
		completion_time[$val]=`expr $temp + ${burst_time[$val]}`
		tat[$val]=`expr ${completion_time[$val]} - ${arrival_time[$val]}`
		waiting_time[$val]=`expr ${tat[$val]} - ${burst_time[$val]}`
		
		if [ $val -ne $i ]
		then
			temp=${arrival_time[$val]} 
			arrival_time[$val]=${arrival_time[$i]}   
			arrival_time[$i]=$temp 
			
			temp=${burst_time[$val]} 
			burst_time[$val]=${burst_time[$i]}   
			burst_time[$i]=$temp
			
			temp=${pid[$val]} 
			pid[$val]=${pid[$i]}   
			pid[$i]=$temp
			
			temp=${completion_time[$val]} 
			completion_time[$val]=${completion_time[$i]}   
			completion_time[$i]=$temp 
			
			temp=${waiting_time[$val]} 
			waiting_time[$val]=${waiting_time[$i]}   
			waiting_time[$i]=$temp
			
			temp=${tat[$val]} 
			tat[$val]=${pid[$i]}   
			tat[$i]=$temp
		fi
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
done
arrangeArrival
arrangeBurst
completionTime
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
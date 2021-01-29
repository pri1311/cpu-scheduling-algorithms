# Bash script to implement Shortest Job First Scheduling Algorithm (Pre-emptive)

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
			    
			    temp=${burst_time_copy[$j]} 
			    burst_time_copy[$j]=${burst_time_copy[$i]}   
			    burst_time_copy[$i]=$temp
			    
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
				    
				    temp=${burst_time_copy[$j]} 
				    burst_time_copy[$j]=${burst_time_copy[$i]}   
				    burst_time_copy[$i]=$temp
				    
				    temp=${pid[$j]} 
				    pid[$j]=${pid[$i]}   
				    pid[$i]=$temp
				fi
			fi
		done
	done
}

timecalc(){
	is_completed=0
	current_time=0
	cp=0
	count=0
	max=1000
	for ((i=0; i<$n; i++))
	do
		if [ ${arrival_time[$i]} -le $current_time ]
		then
			if [ ${burst_time[$i]} -lt $max ]
			then
				if [ ${burst_time[$i]} -ne 0 ]
				then
					cp=$i
					max=${burst_time[$i]}
					if [ ${burst_time[$i]} -eq ${burst_time_copy[$i]} ]
					then
						waiting_time[$i]=$current_time
					fi
				fi
			fi
		fi
	done
	while [ $is_completed -eq 0 ]
	do
		if [ $count -eq $n ]
		then
			is_completed=1
			h=$current_time
		fi
		chart[$current_time]=`expr $cp + 1`
		((current_time++))
		if [ ${burst_time[$cp]} -gt 0 ]
		then
			burst_time[$cp]=`expr ${burst_time[$cp]} - 1`
			max=${burst_time[$cp]}
			if [ ${burst_time[$cp]} -eq 0 ]
			then
				((count++))
				completion_time[$cp]=$current_time
				max=1000
			fi
		fi
		prevcp=$cp
		for ((i=0; i<$n; i++))
		do
			if [ ${arrival_time[$i]} -le $current_time ]
			then
				if [ ${burst_time[$i]} -lt $max ]
				then
					if [ ${burst_time[$i]} -ne 0 ]
					then
						cp=$i
						max=${burst_time[$i]}
					fi
				fi
			fi
		done
		if [ $prevcp -ne $cp ]
		then
			waiting_time[$i]=$current_time
		fi
		
	done
	for ((i=0; i<$n; i++))
	do
		waiting_time[$i]=`expr ${completion_time[$i]} - ${arrival_time[$i]} - ${burst_time_copy[$i]}`
		if [ ${waiting_time[$i]} -lt 0 ]
		then 
			waiting_time[$i]=0
		fi
		tat[$i]=`expr ${waiting_time[$i]} + ${burst_time_copy[$i]}`
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
		printf "|%-18s|%-20s|%-18s|%-20s|%-18s|%-20s|\n" ${pid[$i]} ${burst_time_copy[$i]} ${arrival_time[$i]} ${waiting_time[$i]} ${tat[$i]} $completion_time
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
echo -n "Enter burst time: "
read burst_time[$i]
burst_time_copy[$i]=${burst_time[$i]}
done
arrangeArrival
arrangeBurst
timecalc
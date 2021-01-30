# BASH SCRIPT TO IMPLEMENT VARIOUS CPU SCHEDULING ALGORITHMS.

fcfs(){
    # Function to implement first come first served CPU scheduling algorithm.

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
        echo ""
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
        echo ""
        avgwt=`echo "scale=3; $total_wt / $n" | bc`
        echo "Average waiting time = $avgwt"
        avgtat=`echo "scale=3; $total_tat / $n" | bc`
        echo "Average turn around time = $avgtat"
        echo ""
        echo "GANTT CHART: "
        echo ""
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

    echo ""
    echo "--FIRST COME FIRST SERVED SCHEDULING--"
    echo ""
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


}

sjfnp(){
    # Function to implement Shortest Job First Scheduling Algorithm (non pre-emptive)

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

    echo ""
    echo "--NON PRE-EMPTIVE SHORTEST JOB FIRST ALGORITHM--"
    echo ""
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
    echo ""
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
    echo ""
    avgwt=`echo "scale=3; $total_wt / $n" | bc`
    echo "Average waiting time = $avgwt"
    avgtat=`echo "scale=3; $total_tat / $n" | bc`
    echo "Average turn around time = $avgtat"
    echo ""
    echo "GANTT CHART:"
    echo ""

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
}

sjfp(){
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
        echo ""
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
        echo ""
        avgwt=`echo "scale=3; $total_wt / $n" | bc`
        echo "Average waiting time = $avgwt"
        avgtat=`echo "scale=3; $total_tat / $n" | bc`
        echo "Average turn around time = $avgtat"
        echo ""
        echo "GANTT CHART:"
        echo ""
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
            


    echo ""
    echo "--PRE-EMPTIVE SHORTEST JOB FIRST SCHEDULING--"
    echo ""
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
}

npps(){
    # Function to implement Priority Scheduling Algorithm (non pre-emptive)

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


    echo ""
    echo "--NON PRE-EMPTIVE PRIORITY SCHEDULING--"
    echo ""
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
    echo ""
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
    echo ""
    avgwt=`echo "scale=3; $total_wt / $n" | bc`
    echo "Average waiting time = $avgwt"
    avgtat=`echo "scale=3; $total_tat / $n" | bc`
    echo "Average turn around time = $avgtat"
    echo ""

    echo "GANTT CHART:"
    echo ""
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
}

rr(){
    # Function to implement Round Robin CPU scheduling algorithm.

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
	echo ""
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
	echo ""
	avgwt=`echo "scale=3; $total_wt / $n" | bc`
	echo "Average waiting time = $avgwt"
	avgtat=`echo "scale=3; $total_tat / $n" | bc`
	echo "Average turn around time = $avgtat"
	echo ""
	echo "GANTT CHART:"
	echo ""


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


echo ""
echo "--ROUND ROBIN SCHEDULING--"
echo ""
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
}

#**************** MAIN FUNCTION ****************#
while :
do
	echo "-------------------------------------"
	echo " ALGORITHMS "
	echo "-------------------------------------"
	echo "[1] First Come First Served Algorithm"
	echo "[2] Non Pre-emptive Shortest Job First"
	echo "[3] Pre-emptive Shortest Job First "
	echo "[4] Non Pre-emptive Priority Scheduling"
	echo "[5] Round Robin Algorithm"
	echo "[6] Exit/Quit"
	echo "======================="
	
	echo -n "Enter your menu choice [1-6]: "
	read yourch
	
	case $yourch in
		1) fcfs; read ;;
		2) sjfnp ; read ;;
		3) sjfp ; read ;;
		4) npps; read  ;;
		5) rr ; read ;;
		6) exit 0 ;;
		*) echo "Provide a valid input please!" ; read ;;
	esac
done
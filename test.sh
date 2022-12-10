#!/bin/bash
HEIGHT=20
WIDTH=20

# tutorial had -A, I have switched this to -a to clear invalid option error
declare -a board


# tutorial had -1 as starting value for i and j, I have changed these to 0 due to 'bad subscript array'
# check if this is related to bash version? or to do with bash/zsh as zsh arrays are not zero based
for (( i=-0; i<$(( $HEIGHT+1 )); i++ )) do
	for (( j=-0; j<$(( $WIDTH+1 )); j++ )) do
		board[$i,$j]=0
	done
done


function printBoard {
	for (( i=0; i<$HEIGHT; i++ )) do

		str=""

		for (( j=0; j<$WIDTH; j++ )) do

			str+="|"

			#if board[i][j] is 1
			if [ ${board[$i,$j]} -eq 1 ]; then
				str+="*"
			else 
				str+=" "
			fi		
		done

		str+="|"

		echo $str 
	done
}

function getNeighbors {
	count=0

	if [ ${board[$(($i-1)),$j]} -eq 1 ]; then
		let count=$count+1
	fi

    if [ ${board[$(($i+1)),$j]} -eq 1 ]; then
        let count=$count+1
    fi

    if [ ${board[$i,$(($j-1))]} -eq 1 ]; then
        let count=$count+1
    fi

    if [ ${board[$i,$(($j+1))]} -eq 1 ]; then
        let count=$count+1
    fi

    if [ ${board[$(($i-1)),$(($j-1))]} -eq 1 ]; then
        let count=$count+1
    fi

    if [ ${board[$(($i-1)),$(($j+1))]} -eq 1 ]; then
        let count=$count+1
    fi

    if [ ${board[$(($i+1)),$(($j-1))]} -eq 1 ]; then
        let count=$count+1
    fi

    if [ ${board[$(($i+1)),$(($j+1))]} -eq 1 ]; then
        let count=$count+1
    fi

	return $count
}




# again switching to lowercase a flags
declare -a regen
declare -a alive

for (( c=0; c<120; c++  )) do
	s1=$(( $RANDOM % $HEIGHT ))
	s2=$(( $RANDOM % $WIDTH ))

	board[$s1,$s2]=1
done


clear 


while : 
do
	printBoard	
	# changed starting index from 0 to 1 for i and j as commented above, to elminate bad array subscript error 
	for (( i=1; i<$HEIGHT; i++ )) do
		for (( j=1; j<$WIDTH; j++ )) do
			getNeighbors
			neighbors=$?

			if [ $neighbors -eq 2 ] || [ $neighbors -eq 3 ] && [ ${board[$i,$j]} -eq 1 ] ; then
				alive[$i,$j]=1
			else 
				alive[$i,$j]=0
			fi

			if [ $neighbors -eq 3 ] && [ ${board[$i,$j]} -eq 0 ]; then
				regen[$i,$j]=1
			else 
				regen[$i,$j]=0
			fi
		done
	done

	# changed starting index from 0 to 1 for i and j as commented above, to elminate bad array subscript error 
	for (( i=1; i<$HEIGHT; i++ )) do
		for (( j=1; j<$WIDTH; j++ )) do
			
			if [ ${alive[$i,$j]} -eq 1 ] || [ ${regen[$i,$j]} -eq 1 ]; then
				board[$i,$j]=1
			else 
				board[$i,$j]=0
			fi
		done
	done

	sleep 0.2
	clear
done

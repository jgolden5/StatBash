#!/bin/bash
sleepyEcho() {
	echo $1
	sleep 1
}

playerChoice=""
computerChoice=""

playerFShields=1
playerWShields=1
playerPShields=1
playerCoreHealth=3

computerFShields=2
computerWShields=0
computerPShields=0
playerCoreHealth=3

playerSetup() {
	playerCanMoveOn=1 #false
	
	while [ "$playerCanMoveOn" -eq 1 ]; do
		echo "Enter your desired tokens: (only 5 allowed, either f, w, or p)"
		read playerChoice
		if [ ${#playerChoice} -eq 5 ]; then
			containsUnrecognizedCharacters=1
			for ((i = 0; i < ${#playerChoice}; i++)); do
				character="${playerChoice:i:1}"
				if [[ "$character" != "f" && "$character" != "w" && "$character" != "p" ]]; then 
					containsUnrecognizedCharacters=0
					break
				fi
			done
			if [[ "$containsUnrecognizedCharacters" -eq 0 ]]; then
				echo "String contains unrecognized characters, try again"
			else 
				sleepyEcho "You chose $playerChoice"
				playerCanMoveOn=0
			fi
		elif [ ${#playerChoice} -gt 5 ]; then
			echo "String is too long, try again"
		elif [ ${#playerChoice} -lt 5 ]; then
			echo "String is too short, try again"
		else 
			echo "error: String length not recognized"
		fi
	done
}

computerSetup() {
	counter=0
	while [ $counter -lt 5 ]; do
		random=$(( ( RANDOM % 3 )  + 1 ))
		case $random in 
			1)
				computerChoice+=f
				;;

			2) 
				computerChoice+=w
				;;
		
			3)
				computerChoice+=p
				;;

			*)
				echo case statement went wrong!
				;;
		esac
		((counter++))
	done
	sleepyEcho "The computer chose $computerChoice"
}

showPlayerHealth() {
	echo -e "\nPlayer"
	for ((j = 1; j < 4; j++)); do
		line=""
		if [[ "$j" -eq 1 ]]; then
			line+="f "
		elif [[ "$j" -eq 2 ]]; then
			line+="w "
		elif [[ "$j" -eq 3 ]]; then
			line+="p "
		else
			echo "Something went wrong line 92"
		fi
		for ((i = 1; i < 3; i++)); do
			if [[ "$j" -eq 1 ]]; then
				if [[ $playerFShields -ge $i ]]; then
					line+="+"
				else
					line+="-"
				fi
			elif [[ "$j" -eq 2 ]]; then
				if [[ $playerWShields -ge $i ]]; then
					line+="+"
				else
					line+="-"
				fi
			elif [[ "$j" -eq 3 ]]; then
				if [[ $playerPShields -ge $i ]]; then
					line+="+"
				else
					line+="-"
				fi
			fi
		done
		echo $line
	done
}

showComputerHealth() {
	echo -e "\nComputer"
	for ((j = 1; j < 4; j++)); do
		line=""
		if [[ "$j" -eq 1 ]]; then
			line+="f "
		elif [[ "$j" -eq 2 ]]; then
			line+="w "
		elif [[ "$j" -eq 3 ]]; then
			line+="p "
		else
			echo "Something went wrong line 92"
		fi
		for ((i = 1; i < 3; i++)); do
			if [[ "$j" -eq 1 ]]; then
				if [[ $computerFShields -ge $i ]]; then
					line+="+"
				else
					line+="-"
				fi
			elif [[ "$j" -eq 2 ]]; then
				if [[ $computerWShields -ge $i ]]; then
					line+="+"
				else
					line+="-"
				fi
			elif [[ "$j" -eq 3 ]]; then
				if [[ $computerPShields -ge $i ]]; then
					line+="+"
				else
					line+="-"
				fi
			fi
		done
		echo $line
	done
}

#fight() {
#	for ((i = 0; i < ${#playerChoice}; i++)); do
#		playerChar="${playerChoice:i:1}"
#		computerChar="${computerChoice:i:1}"
#		sleepyEcho "$playerChar vs. $computerChar"
#	done
#}

playerSetup
computerSetup
showPlayerHealth
showComputerHealth
#fight

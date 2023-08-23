#!/bin/bash
sleepyEcho() {
	echo $1
	sleep 1
}

playerChoice=""
computerChoice=""

playerSetup() {
	playerFShields=2
	playerWShields=2
	playerPShields=2
	playerCanMoveOn="false"
	while [ "$playerCanMoveOn" == "false" ]; do
		echo "Enter your desired tokens: (only 5 allowed, either f, w, or p)"
		read playerChoice
		if [ ${#playerChoice} -eq 5 ]; then
			sleepyEcho "You chose $playerChoice"
			playerCanMoveOn="true"
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
	computerFShields=2
	computerWShields=2
	computerPShields=2

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

playerSetup
computerSetup

#!/bin/bash
sleepyEcho() {
	echo $1
	sleep 1
}

playerBaseCoreHealth=3
computerBaseCoreHealth=2

computerIsDead=1
score=0
highScore=0

playerChoice=""
computerChoice=""

playerFShield=2
playerWShield=2
playerPShield=2
playerCurrentHealth=$playerBaseCoreHealth

computerFShield=2
computerWShield=2
computerPShield=2
computerCurrentHealth=$computerBaseCoreHealth

reset() {
  score=0

  playerChoice=""
  computerChoice=""

  playerFShield=2
  playerWShield=2
  playerPShield=2
  playerCurrentHealth=$playerBaseCoreHealth

  computerFShield=2
  computerWShield=2
  computerPShield=2
  computerCurrentHealth=$computerBaseCoreHealth

  fight

}

computerReset() {
  computerChoice=""

  computerFShield=2
  computerWShield=2
  computerPShield=2
  computerCurrentHealth=$computerBaseCoreHealth

}

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
  computerChoice=""
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
	for ((j = 1; j < 5; j++)); do
		line=""
		if [[ "$j" -eq 1 ]]; then
			line+="f "
		elif [[ "$j" -eq 2 ]]; then
			line+="w "
		elif [[ "$j" -eq 3 ]]; then
			line+="p "
		elif [[ "$j" -eq 4 ]]; then
			line+="health "
		else
			echo "Something went wrong line 92"
		fi
		if [[ $j -lt 4 ]]; then
			for ((i = 1; i < 3; i++)); do
				if [[ "$j" -eq 1 ]]; then
					if [[ $playerFShield -ge $i ]]; then
						line+="+"
					else
						if [[ $playerFShield -ge 0 ]] || [[ $i -lt 2 ]]; then
							line+="-"
						else
							line+="-"
							if [[ $playerCurrentHealth -le 0 ]]; then
                line+="☠️"
                break
							fi
						fi
					fi
				elif [[ "$j" -eq 2 ]]; then
					if [[ $playerWShield -ge $i ]]; then
						line+="+"
					else
						if [[ $playerWShield -ge 0 ]] || [[ $i -lt 2 ]]; then
							line+="-"
						else
							line+="-"
							if [[ $playerCurrentHealth -le 0 ]]; then
                line+="☠️"
                break
							fi
						fi
					fi
				elif [[ "$j" -eq 3 ]]; then
					if [[ $playerPShield -ge $i ]]; then
						line+="+"
					else
						if [[ $playerPShield -ge 0 ]] || [[ $i -lt 2 ]]; then
							line+="-"
						else
							line+="-"
							if [[ $playerCurrentHealth -le 0 ]]; then
                line+="☠️"
                break
							fi
						fi
					fi
				fi
			done
		else
			for ((i = 0; i < $playerBaseCoreHealth; i++)); do
			  if [[ $playerCurrentHealth -gt $i ]]; then
          line+="|"
        else
          line+="X"
        fi
			done
		fi
		echo $line
	done
}

showComputerHealth() {
	echo -e "\nComputer"
	for ((j = 1; j < 5; j++)); do
		line=""
		if [[ "$j" -eq 1 ]]; then
			line+="f "
		elif [[ "$j" -eq 2 ]]; then
			line+="w "
		elif [[ "$j" -eq 3 ]]; then
			line+="p "
		elif [[ "$j" -eq 4 ]]; then
			line+="health "
		else
			echo "Something went wrong line 92"
		fi
		if [[ $j -lt 4 ]]; then
			for ((i = 1; i < 3; i++)); do
				if [[ "$j" -eq 1 ]]; then
					if [[ $computerFShield -ge $i ]]; then
						line+="+"
					else
						if [[ $computerFShield -ge 0 ]] || [[ $i -lt 2 ]]; then
							line+="-"
						else
							line+="-"
							if [[ $computerCurrentHealth -le 0 ]]; then
                line+="☠️"
                break
							fi
						fi
					fi
				elif [[ "$j" -eq 2 ]]; then
					if [[ $computerWShield -ge $i ]]; then
						line+="+"
					else
						if [[ $computerWShield -ge 0 ]] || [[ $i -lt 2 ]]; then
							line+="-"
						else
							line+="-"
							if [[ $computerCurrentHealth -le 0 ]]; then
                line+="☠️"
                break
							fi
						fi
					fi
				elif [[ "$j" -eq 3 ]]; then
					if [[ $computerPShield -ge $i ]]; then
						line+="+"
					else
						if [[ $computerPShield -ge 0 ]] || [[ $i -lt 2 ]]; then
							line+="-"
						else
							line+="-"
							if [[ $computerCurrentHealth -le 0 ]]; then
                line+="☠️"
                break
							fi
						fi
					fi
				fi
			done
		else
			for ((i = 0; i < $computerBaseCoreHealth; i++)); do
			  if [[ $computerCurrentHealth -gt $i ]]; then
          line+="|"
        else
          line+="X"
        fi
			done
		fi
		echo $line
	done
}

fight() {
  if [[ $computerIsDead -eq 0 ]]; then
    computerReset
    computerIsDead=1
    playerHeal
    showPlayerHealth
  fi
	playerSetup
	computerSetup
	for ((i = 0; i < ${#playerChoice}; i++)); do
		playerChar="${playerChoice:i:1}"
		computerChar="${computerChoice:i:1}"
		sleepyEcho "$playerChar vs. $computerChar"
		if [[ $playerChar == $computerChar ]]; then
			sleepyEcho "Tie!"
			continue
		elif [[ $playerChar == "f" ]]; then
			if [[ $computerChar == "w" ]]; then
				playerFShield=$((playerFShield-1))
				sleepyEcho "your fire was beaten by water"
				if [[ $playerFShield -lt 0 ]]; then
					sleepyEcho "Without fire shields, your core health was damaged"
					playerCoreHealthDamage
					if [[ $playerCurrentHealth -le 0 ]]; then
            break
					fi
				fi
			elif [[ $computerChar == "p" ]]; then
				computerPShield=$((computerPShield-1))
				sleepyEcho "your fire beat your enemy's plant!"
				if [[ $computerPShield -lt 0 ]]; then
					sleepyEcho "Without plant shields, your enemy's core health has been damaged!"
					computerCoreHealthDamage
					if [[ $computerCurrentHealth -le 0 ]]; then
            break
					fi
				fi
			fi
		elif [[ $playerChar == "w" ]]; then
			if [[ $computerChar == "f" ]]; then
				computerFShield=$((computerFShield-1))
				sleepyEcho "your water beat your enemy's fire!"
				if [[ $computerFShield -lt 0 ]]; then
					sleepyEcho "Without water shields, your enemy's core health has been damaged!"
					computerCoreHealthDamage
					if [[ $computerCurrentHealth -le 0 ]]; then
            break
					fi
				fi
			elif [[ $computerChar == "p" ]]; then
				playerWShield=$((playerWShield-1))
				sleepyEcho "your water was beaten by plant"
				if [[ $playerWShield -lt 0 ]]; then
					sleepyEcho "Without water shields, your core health was damaged"
					playerCoreHealthDamage
					if [[ $playerCurrentHealth -le 0 ]]; then
            break
					fi
				fi
			fi
		elif [[ $playerChar == "p" ]]; then
			if [[ $computerChar == "f" ]]; then
				playerPShield=$((playerPShield-1))
				sleepyEcho "your plant was beaten by fire"
				if [[ $playerPShield -lt 0 ]]; then
					sleepyEcho "Without plant shields, your core health was damaged"
					playerCoreHealthDamage
				fi
			elif [[ $computerChar == "w" ]]; then
				computerWShield=$((computerWShield-1))
				sleepyEcho "your plant beat your enemy's water!"
				if [[ $computerWShield -lt 0 ]]; then
					sleepyEcho "Without plant shields, your enemy's core health has been damaged!"
					computerCoreHealthDamage
					if [[ $computerCurrentHealth -le 0 ]]; then
            break
					fi
				fi
			fi
		else
			echo "Something went wrong, characters not recognized"
		fi
	done

	showPlayerHealth
	showComputerHealth
}

playerDie() {
	sleepyEcho "You have died..."
	echo "Score = $score"
	if [[ $score -gt $highScore ]]; then
	  highScore=$score
	  sleepyEcho "New High Score!"
	fi
	sleepyEcho "High Score =  $highScore"
}

computerDie() {
  computerIsDead=0
	sleepyEcho "You have successfully defeated the enemy! Mission accomplished."
	score=$((score+1))
	sleepyEcho "Score = $score"
}

playerCoreHealthDamage() {
	playerCurrentHealth=$((playerCurrentHealth-1))
	if [[ $playerCurrentHealth -le 0 ]]; then
		sleepyEcho "Your core has been destroyed"
		playerDie
		break
	fi
}

computerCoreHealthDamage() {
	computerCurrentHealth=$((computerCurrentHealth-1))
	if [[ $computerCurrentHealth -le 0 ]]; then
		sleepyEcho "Your enemy's core has been destroyed"
		computerDie
		break
	fi
}

playerHeal() {
  count=0
  while [[ $count -lt 2 ]]; do
    random=$(( ( RANDOM % 3 )  + 1 ))
    case $random in
      1)
        if [[ $playerFShield -lt 2 ]]; then
          ((playerFShield++))
          echo "1 fire shield healed"
        else
          echo "fire shields are full, so nothing was healed"
        fi
        ;;

      2)
        if [[ $playerWShield -lt 2 ]]; then
          ((playerWShield++))
          echo "1 water shield healed"
        else
          echo "water shields are full, so nothing was healed"
        fi
        ;;

      3)
        if [[ $playerPShield -lt 2 ]]; then
          ((playerPShield++))
          echo "1 plant shield healed"
        else
          echo "plant shields are full, so nothing was healed"
        fi
        ;;

      *)
        echo "case statement went wrong!"
        ;;
    esac
    ((count++))
  done
}

fight

alias f=fight

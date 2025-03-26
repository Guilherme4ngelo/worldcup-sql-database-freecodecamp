#!/bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.


$PSQL "TRUNCATE teams CASCADE"

while IFS=","  read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS	
do
	# skip first line from csv file
	if [[ $YEAR != 'year' ]]
	then
		# start of script

		# first fill the teams table

		# try to find the team_id for winner team
		WINNER_ID=$($PSQL "select team_id from teams where name = '$WINNER'")

		# try to find the team_id for opponent temas
		OPPONENT_ID=$($PSQL "select team_id from teams where name = '$OPPONENT'")

		
		# if winner_id not found
		if [[ -z $WINNER_ID ]]
		then

			echo rodou o primeiro if

			# insert winner team into teams table
			$PSQL "INSERT INTO teams(name) VALUES ('$WINNER')"

			# get the winner_id from the inserted input
			WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")

			echo inserido na tabela de times o time: $WINNER:$WINNER_ID
		fi
	
		# if opponent_id not found
		if [[ -z $OPPONENT_ID ]]
		then
			# insert opponent team into teams table
			$PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')"
			
			# get the opponent_id from the inserted input
			OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
			
			echo inserido na tabela de times o time: $OPPONENT:$OPPONENT_ID
		fi
	fi
done < games_test.csv

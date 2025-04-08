#!/bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.


TRUNCATE_RESULT=$($PSQL "TRUNCATE teams,games CASCADE")

if [[ $TRUNCATE_RESULT = "TRUNCATE TABLE" ]]
then
	echo tabelas truncadas com sucesso
fi

while IFS=","  read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS	
do
	# skip first line from csv file
	if [[ $YEAR != 'year' ]]
	then
		# start of script

		# first fill the teams table

		# try to find the team_id for winner team
		WINNER_ID=$($PSQL "select team_id from teams where name = '$WINNER'")

		# try to find the team_id for opponent team
		OPPONENT_ID=$($PSQL "select team_id from teams where name = '$OPPONENT'")

		
		# if winner_id not found
		if [[ -z $WINNER_ID ]]
		then

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


		# insert complete row

		INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")

		if [[ $INSERT_GAME_RESULT = "INSERT 0 1" ]]
		then
			echo jogo inserido na base de dados
		fi
	fi
done < games.csv

#!/bin/bash
export PSQLRC=/dev/null
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
echo "Enter your username:"
read USERNAME
USER_ROW=$($PSQL "SELECT games_played, best_game FROM users WHERE username='$USERNAME'")
if [[ -z $USER_ROW ]]
then
echo "Welcome, $USERNAME! It looks like this is your first time here."
$PSQL "INSERT INTO users(username) VALUES('$USERNAME')" > /dev/null
else
IFS="|" read GAMES BEST <<< "$USER_ROW"
echo "Welcome back, $USERNAME! You have played $GAMES games, and your best game took $BEST guesses."
fi
SECRET=$(( RANDOM % 1000 + 1 ))
GUESSES=0
echo "Guess the secret number between 1 and 1000:"
while true
do
read GUESS || exit
if [[ ! $GUESS =~ ^[0-9]+$ ]]
then
echo "That is not an integer, guess again:"
continue
fi
GUESSES=$((GUESSES+1))
if (( GUESS < SECRET ))
then
echo "It's higher than that, guess again:"
elif (( GUESS > SECRET ))
then
echo "It's lower than that, guess again:"
else
break
fi
done
$PSQL "UPDATE users SET games_played=games_played+1, best_game=CASE WHEN best_game IS NULL OR $GUESSES < best_game THEN $GUESSES ELSE best_game END WHERE username='$USERNAME'" > /dev/null
echo "You guessed it in $GUESSES tries. The secret number was $SECRET. Nice job!"

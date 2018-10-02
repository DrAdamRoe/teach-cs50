#!/usr/local/bin/bash

#######################################################
## Author: Adam Roe, Code University
## 
## usage: ./morestats.sh
## expects a file called "usernames.txt" in the same directory 
##  containing one git username per line, no commas
#######################################################

### define some variables for basic counting statistics
N_USERNAMES=0 # N being looped over

## counter for problem set directories
declare -A psets=( ["pset1"]=0 ["pset2"]=0 ["pset3"]=0)

## counter for problems, relative to cs50 directory
declare -A hws=( ["pset1/mario/less/mario.c"]=0 
		["pset1/mario/more/mario.c"]=0 
		["pset1/cash/cash.c"]=0  
		["pset1/credit/credit.c"]=0  
		["pset2/caesar/caesar.c"]=0  
		["pset2/vigenere/vigenere.c"]=0 
		["pset2/crack/crack.c"]=0
		)

## read in GitHub usernames from file, line by line 
while read USERNAME

## loop over usernames 
do

## increment overal counter 
let N_USERNAMES++

LOC_REPO="students/$USERNAME/cs50"
#echo $LOC_REPO

##loop over all problem set directories, and count up.
for dir in "${!psets[@]}"
do
if [ -d $LOC_REPO/$dir ]; then
	##increment value
	let ++psets[$dir]
fi
done


## loop over all problem sets, and count up.
for hw in "${!hws[@]}"
do
if [ -f "$LOC_REPO/$hw" ]; then
	##increment value
	let ++hws[$hw]
fi
done


done < usernames.txt

echo "### statistics ###" 
echo "total usernames: $N_USERNAMES" 

## print dirs 
for dir in "${!psets[@]}"
do
echo "total $dir : ${psets[$dir]}"
done

echo ""

## print hws 
for hw in "${!hws[@]}"
do
echo "total $hw : ${hws[$hw]}"
done

#######################################################
## A bash script to clone & pull student's work on cs50
## Note that this is setup based on custom instructions, 
##  not the standard cs50 submission mechanism. 
##
## Author: Adam Roe, Code University
## 
## usage: ./check.sh > logs/check_$(date +%s).out 2>&1
## expects a file called "usernames.txt" in the same directory 
##  containing one git username per line, no commas
## also expects a "logs" and a "students" directory
#######################################################

### define some variables for basic counting statistics
N_USERNAMES=0 # N being looped over
N_ERROR=0     # N with no acessible remote repo 
N_NEW=0       # N clones 
N_UPDATE=0    # N pulls

## read in GitHub usernames from file, line by line 
while read USERNAME

## loop over usernames 
do

## increment overal counter 
let N_USERNAMES++

## define a variable with the remote repository location on GitHub
REMOTE_REPO="git@github.com:$USERNAME/cs50"
# echo $REMOTE_REPO

## check if the repo exists and if you have access.

RET_CHECK="git ls-remote --exit-code --quiet --heads $REMOTE_REPO"
echo "executing: $RET_CHECK"
eval $RET_CHECK

## continue if there is an error, otherwise keep going. 

if [ $? -ne 0 ]; then 
	echo "Return code was $? . Repo for $USERNAME not exist or is closed source". 
	let N_ERROR++
	continue
fi 

## if there is no local directory with the username's name, create it.

if [ ! -d "students/$USERNAME" ]; then
	mkdir "students/$USERNAME"
	echo "created directory for $USERNAME"
fi

## define a variable with local repository path, at username/cs50
LOC_REPO="students/$USERNAME/cs50"
# echo $LOC_REPO

## if there is no local repo yet, clone into it. Otherwise, pull it. m
if [ ! -d "students/$USERNAME/cs50" ]; 
	then
		echo "Cloing into $REMOTE_REPO"
        	git clone $REMOTE_REPO $LOC_REPO
		let N_NEW++
	else 
		echo "Updating $LOC_REPO"
		git -C $LOC_REPO pull $REMOTE_REPO
		let N_UPDATE++
fi

		
echo ""
done < usernames.txt

echo "### statistics ###" 
echo "total usernames: $N_USERNAMES" 
echo "N new repos:     $N_NEW" 
echo "N updated repos: $N_UPDATE" 
echo "N errors:        $N_ERROR" 

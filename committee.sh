usage()
{
    echo "git-committee usage:"
    echo "---"
    echo
    echo "-u | --username   Choose GitHub username to use as input"
    echo "-f | --file       Choose JSON file to use as input"
    echo
    echo "-s | --start      Set the start date"
    echo "-e | --end        Set the end date"
    echo
    echo "-h | --help       Show this help screen"
    echo
    echo "---"
    echo
    echo "Examples:"
    echo
    echo "Use a GitHub user as the input, with start date and end date:"
    echo "./committee.sh -u torvalds -s 2020-02-01 -e 2020-02-29"
    echo
    echo "Use a JSON file as the input:"
    echo "./committee.sh -f ~/Downloads/data.json"
    echo
    echo "---"
}

##################
# Parse arguments
##################

username=
file=
start=
end=

while [ "$1" != "" ]; do
    case $1 in
        -u | --username )
          shift
          username=$1
          ;;
        -f | --file )
          shift
          file=$1
          ;;
        -s | --start )
          shift
          start=$1
          ;;
        -e | --end )
          shift
          end=$1
          ;;
        -h | --help )
          usage
          exit
          ;;
    esac
    shift
done

if [ ! -z "$file" ] && [ ! -z "$username" ];
then
  echo "Error: received both file and GitHub username."
  exit
elif [ -z "$file" ] && [ -z "$username" ];
then
  echo "Error: you must supply a file or GitHub username."
  exit
fi

##################
# Prepare the data
##################

select=

if [ ! -z "$start" ] && [ ! -z "$end" ];
then
  select=" | select(.date >= \"$start\" and .date <= \"$end\")"
elif [ ! -z "$start" ];
then
  select=" | select(.date >= \"$start\")"
elif [ ! -z "$end" ];
then
  select=" | select(.date <= \"$end\")"
fi

data=

if [ ! -z "$file" ];
then
  data=`jq -c ".contributions[]$select" $file`
elif [ ! -z "$username" ];
then
  data=`curl -s https://github-contributions.now.sh/api/v1/$username | jq -c ".contributions[]$select"`
fi

##################
# Initialize repo
##################

today="$(date +"%Y-%m-%d")"
random_string="$(head /dev/urandom | LC_CTYPE=C tr -dc A-Za-z0-9 | head -c 4 ; echo '')"
dir="$today-$random_string-commits"

echo "Creating new folder $dir..."

mkdir -p repos
cd repos
mkdir -p $dir
cd $dir

echo "Initializing new git repository..."

git init
touch git-committee.md

##################
# Make the commits
##################

for c in $data
do
  date=$(echo $c | jq '.date')
  count=$(echo $c | jq '.count')

  if [ "$count" -gt 0 ]; then
    echo '==='
    echo $count commits on $date

    export GIT_COMMITER_DATE="$date 12:00:00"
    export GIT_AUTHOR_DATE="$date 12:00:00"

    for i in `seq 1 $count`
    do
      echo "$date $i" > git-committee.md
      git add git-committee.md
      git commit --date="$date 12:00:00" -m "commit"
    done
  fi
done

echo '==='
echo "All done!"
echo
echo "Now cd into the new directory..."
echo "cd repos/$dir"
echo
echo "Add a git remote..."
echo "git remote add origin <my remote>.git"
echo
echo "And push it!"
echo "git push -u origin master"

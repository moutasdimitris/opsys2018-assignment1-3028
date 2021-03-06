#! /usr/bin/bash
FILE=$1
check_structure(){
	if [ -f $1/dataA.txt ]; then
	if [ -d $1/more ]; then
		if [ -f $1/more/dataB.txt ]; then
			if [ -f $1/more/dataC.txt ]; then
			echo -e "\e[38:5:42mDirectory structure is OK\e[39m "
		fi
	fi
	fi
else
	echo -e "\e[31mDirectory structure is NOT OK\e[0m"
fi
		}


if [ -f $FILE ]; then
  echo "File exists.Opening..."
  if [ ! -d ~/Desktop/temp_git_repos ]; then
  mkdir -p ~/Desktop/temp_git_repos
  fi
  if [ ! -d ~/Desktop/git_repos ]; then
  mkdir -p ~/Desktop/git_repos
  fi
  cd ~/Desktop/temp_git_repos
  tar -xvzf $FILE > /dev/null
  find ~/Desktop/temp_git_repos -type f -name "*.txt" | while read txt; do
    mv $txt ~/Desktop/git_repos
  done
 rm -rf ~/Desktop/temp_git_repos
else
	echo "File not exists."
	exit $?;
fi
echo "-------------------------"
echo "----------START----------"
#READ TXT FILES AND TAKE THE URL TO GITHUB.
if [ ! -d ~/Desktop/assignments ];
then mkdir -p ~/Desktop/assignments
fi
cd ~/Desktop/assignments
for file1 in  ~/Desktop/git_repos/*.txt; do
 while IFS=$'\n' read f; do
if [[ $f == "https"* ]]; then
  git ls-remote $f -q
  if [[ $? == "0" ]]; then
    str=`echo "$f" | cut -d'/' -f 5`
  if [ ! -d ~/Desktop/assignments/$str ];
   then mkdir  ~/Desktop/assignments/$str
  else
    rm -r ~/Desktop/assignments/$str
  fi
    git clone  -q $f ~/Desktop/assignments/$str > /dev/null
    echo -e "$f : \e[38:5:42mCloning OK\e[39m "
  else
   echo -e "$f : \e[31mCloning FAILED\e[0m"
fi
  break;
fi
done < "$file1"
done

for file2 in ~/Desktop/assignments/*; do
str=`echo "$file2" | cut -d'/' -f 6`
echo -e "\e[4m$str:\e[0m"
dir=`find $file2/* -maxdepth 0 -type d | wc -l`
txt=`find $file2/* -type f -name '*.txt' | wc -l`
other=`find $file2/* | wc -l `
sd=$(( $other-$txt-$dir ))
echo -e "Number of directories: \e[31m$dir\e[0m"
echo -e "Number of txt files: \e[31m$txt\e[0m"
echo -e "Number of other files: \e[31m$sd\e[0m"
check_structure $file2
done
echo "----------End----------"

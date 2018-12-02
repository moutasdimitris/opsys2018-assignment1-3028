#! bin/bash
check_structure(){
	if [ -f $1/script1a.sh ]; then
	if [ -f $1/script1b.sh ]; then
		if [ -f $1/script2.sh ]; then
			echo -e "\e[38:5:42mDirectory structure is OK\e[39m "
		fi
	fi
else
	echo -e "\e[31mDirectory structure is NOT OK\e[0m"
fi
		}
echo "Give me the file:"
echo "-------------------------"
read file
if [ -f $file ] ;
	then echo "File exists.Opening..."
  if [ ! -d ~/Desktop/temp_git_repos ]; then
  mkdir -p ~/Desktop/temp_git_repos
  fi
  if [ ! -d ~/Desktop/git_repos ]; then
  mkdir -p ~/Desktop/git_repos
  fi
  cd ~/Desktop/temp_git_repos
  tar -xvzf $file > /dev/null
  find ~/Desktop/temp_git_repos -type f -name "*.txt" | while read txt; do
    mv $txt ~/Desktop/git_repos
  done
 rm -rf ~/Desktop/temp_git_repos
else
	until [ -f $file ];
		do
		echo "File not exists."
		echo "Please give me the right path."
		read file
	done
echo "File exists.Opening.."
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
    str=`echo "$f" | cut -d'/' -f 4`
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
echo "file is $file2"
check_structure $file2
done





echo "----------End----------"

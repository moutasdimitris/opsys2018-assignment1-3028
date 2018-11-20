#! bin/bash
echo "Give me the file:"
echo "------------------------------"
read file #TAKE THE PATH TO FILE.
if [ -f $file ];
	then echo "File exists.Opening.."
else
	until [ -f $file ];
		do
		echo "File not exists."
		echo "Please give me the right path."
		read file
	done
echo "File exists.Opening.."
fi

#MAKE FOLDER TO SAVE WEBSITES FILES.
dir_name="/home/$USER/Desktop/web_con_a"
if [ ! -f $dir_name ];
	then mkdir -p $dir_name
else
	break;
fi
echo "------------------------------"


#CHECK CONNECTION WITH WEBSITES.
#CREATE ALL FILES TO SAVE WEBSITES CONTENTS.
#COMPARE WEBSITES CONTENTS.
> ~/Desktop/web_con_a/status.txt
while IFS=$'\n' read LINE;
do
if [[ ! $LINE == "#"* ]]; then
	status=`curl -sL -w "%{http_code}\n" "$LINE" -o /dev/null`
	str=`echo "$LINE" | cut -d'/' -f 3`
	if [[ $status == "200" ]]; then
			if [ -f  ~/Desktop/web_con_a/"$str".txt ]; then
				curl -sS $LINE > /tmp/"$str".txt
				status1=`cmp -b ~/Desktop/web_con_a/"$str".txt /tmp/"$str".txt`
				if [[ ! $status1 == "" ]]; then
					echo $LINE >> ~/Desktop/web_con_a/status.txt
					rm ~/Desktop/web_con_a/"$str".txt
					mv /tmp/"$str".txt ~/Desktop/web_con_a/
				fi
	else
				echo "$LINE INIT"
			  curl -sS $LINE > ~/Desktop/web_con_a/"$str".txt
	    fi
	else
		echo "$LINE FAILED"
	fi
fi
done < "$file"
echo "------------------------------"

if [[ -s ~/Desktop/web_con_a/status.txt ]]; then
echo "Website that have changed:"
echo "++++++++++++++++++++++++++"
cat ~/Desktop/web_con_a/status.txt
fi
rm ~/Desktop/web_con_a/status.txt
echo "------END------"
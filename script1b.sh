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
dir_name="/home/$USER/Desktop/web_con_b"
if [ ! -f $dir_name ];
	then mkdir -p $dir_name
else
	break;
fi
echo "------------------------------"


#CHECK CONNECTION WITH WEBSITES.
#CREATE ALL FILES TO SAVE WEBSITES CONTENTS.
> ~/Desktop/web_con_b/status.txt
> ~/Desktop/web_con_b/online_web.txt
while IFS=$'\n' read LINE;
do
if [[ ! $LINE == "#"* ]]; then
	status=`curl -sL -w "%{http_code}\n" "$LINE" -o /dev/null`
	str=`echo "$LINE" | cut -d'/' -f 3`
	if [[ $status == "200" ]]; then
		echo $LINE >> ~/Desktop/web_con_b/online_web.txt
  fi
fi
done < $file
echo "------------------------------"

#DOWNLOAD WEBSITES CONTENTS
cd ~/Desktop/web_con_b
wget -b -i ~/Desktop/web_con_b/online_web.txt > /dev/null
rm "wget-log"



if [[ -s ~/Desktop/web_con_b/status.txt ]]; then
echo "Website that have changed:"
echo "++++++++++++++++++++++++++"
cat ~/Desktop/web_con_b/status.txt
fi
rm ~/Desktop/web_con_b/online_web.txt
rm ~/Desktop/web_con_b/status.txt
echo "------END------"

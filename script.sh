#!/bin/bash
USERID="<YOUR-ID>"
KEY="<API-KEY-OF-YOUR-BOT>" TIMEOUT="10"
if [ "$PAM_TYPE" = "close_session" ]; then
  WHAT="out"
else
 WHAT="in"
fi
URL="https://api.telegram.org/bot$KEY/sendMessage"
DATE_EXEC="$(date "+%d %b %Y %H:%M")" #Collect date & time.
TMPFILE='/tmp/ipinfo-$DATE_EXEC.txt' #Create a temporary file to keep data in.
if [ -n "$PAM_RHOST" ] && [ -z "$TMUX" ]; then #Trigger
IP=$(echo $PAM_RHOST) #Get Client IP address.
HOSTNAME=$(hostname -f) #Get hostname
IPADDR=$(hostname -I | awk '{print $1}') 
curl https://ipinfo.io/$IP -s -o $TMPFILE #Get info on client IP.
CITY=$(cat $TMPFILE | sed -n 's/^  "city":[[:space:]]*//p' | sed 's/"//g') #Client IP info parsing
REGION=$(cat $TMPFILE | sed -n 's/^  "region":[[:space:]]*//p' | sed 's/"//g')
COUNTRY=$(cat $TMPFILE | sed -n 's/^  "country":[[:space:]]*//p' | sed 's/"//g')
ORG=$(cat $TMPFILE | sed -n 's/^  "org":[[:space:]]*//p' | sed 's/"//g')
TEXT="$DATE_EXEC: $PAM_USER logged $WHAT to $HOSTNAME ($IPADDR) %0AFrom  $IP  %0A$ORG  %0A$CITY  %0A$REGION  %0A$COUNTRY"
curl -s --max-time $TIMEOUT -d "chat_id=$USERID&disable_web_page_preview=1&text=$TEXT" $URL>/dev/null
rm $TMPFILE #clean up after
fi


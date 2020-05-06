#!/bin/bash

# Adjust the Minute to nearest 10th Minute (0,10,20,30,40,50) of that hour 
# For example, at 12:36 PM, the minute 36 will adjusted back to 30. Timestamp will be readjusted to depict time 12:30:00

echo "Current date is $(date -u)"
adjmin=$(expr "$(date -u "+%M") - $(date -u "+%M") % 10"|bc)


# Initialize Counter for limiting the processing to 6 steps

cnt=0
# echo -n "Enter your Pass Phrase for Encryption: "
# stty -echo
# read passphrase
# read passphrase < ./passphrase
passphrase="Time-based Auth Key"
# stty echo
echo
echo

# Setting Static Variables as Input for TOTP Generation

imei=13122004956780
mobno=98981125436
# ssalt=$(openssl prime -generate -bits 256)
ssalt=90383760885505128609436366384783470988859228428581495067567141457192442766313
# read ssalt < ./syskey
usalt=$passphrase
reg_key=$ssalt$usalt
# reg_key=fgh79i

# Adjust timestamp with adjusted minute (for each 10 minute interval) and resetting seconds to 00

adtstmp=$(expr "$(date -u '+%s') - $(date -u "+%S") - ($(date -u "+%M") * 60) + ${adjmin:-}" |bc)

# Creating a concatenated key of all static and variable values as calculated / mentioned above

fnlStr=$imei$mobno$reg_key$adtstmp

# echo $fnlStr
# echo $(expr "$fnlStr" | /usr/bin/openssl dgst -md5) |awk '{print $2}' | fold -5
echo
echo

        
# Looping to generate each digit of TOTP of lenght 6 by calculating an Message Digest Ver 5 (md5) checksum hash and breaking it into 5 equal part
# Loop also ignores remaining part of checksum hash once 6th digit is calculated
# echo "$(expr "$fnlStr" | /usr/bin/openssl dgst -md5 | cut -d= -f2)"

for a in $(expr "$fnlStr" | /usr/bin/openssl dgst -md5 |awk '{print $2}' | fold -5);
        do 
                j=$(echo $((16#$a)))
                k=$(expr "$j % 10" | bc)
                h=$k${h:-} 
                cnt=$(expr "$cnt + 1" |bc)
                # echo $adjmin ----- $cnt----- $k---- $h ----- $j ------ $k ------ $a
                if [[ $cnt -ge 6 ]] ; then
                        break
                fi
        done 

printf "%s\n" "Time based OTP is $h"

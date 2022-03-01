#!/bin/bash
shell_version="1.4.1";
UA_Browser="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.87 Safari/537.36";
UA_Dalvik="Dalvik/2.1.0 (Linux; U; Android 9; ALP-AL00 Build/HUAWEIALP-AL00)";
DisneyAuth="grant_type=urn%3Aietf%3Aparams%3Aoauth%3Agrant-type%3Atoken-exchange&latitude=0&longitude=0&platform=browser&subject_token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJiNDAzMjU0NS0yYmE2LTRiZGMtOGFlOS04ZWI3YTY2NzBjMTIiLCJhdWQiOiJ1cm46YmFtdGVjaDpzZXJ2aWNlOnRva2VuIiwibmJmIjoxNjIyNjM3OTE2LCJpc3MiOiJ1cm46YmFtdGVjaDpzZXJ2aWNlOmRldmljZSIsImV4cCI6MjQ4NjYzNzkxNiwiaWF0IjoxNjIyNjM3OTE2LCJqdGkiOiI0ZDUzMTIxMS0zMDJmLTQyNDctOWQ0ZC1lNDQ3MTFmMzNlZjkifQ.g-QUcXNzMJ8DwC9JqZbbkYUSKkB1p4JGW77OON5IwNUcTGTNRLyVIiR8mO6HFyShovsR38HRQGVa51b15iAmXg&subject_token_type=urn%3Abamtech%3Aparams%3Aoauth%3Atoken-type%3Adevice"
DisneyHeader="authorization: Bearer ZGlzbmV5JmJyb3dzZXImMS4wLjA.Cu56AgSfBTDag5NiRA81oLHkDZfu5L3CKadnefEAY84"
Font_Black="\033[30m";
Font_Red="\033[31m";
Font_Green="\033[32m";
Font_Yellow="\033[33m";
Font_Blue="\033[34m";
Font_Purple="\033[35m";
Font_SkyBlue="\033[36m";
Font_White="\033[37m";
Font_Suffix="\033[0m";
LOG_FILE="check.log";

clear;
echo -e "Streaming Unlock Test" && echo -e "Streaming Unlock Test" > ${LOG_FILE};
echo -e "${Font_Purple}Tips The test results of this tool are for reference only，Please refer to the actual use${Font_Suffix}" && echo -e "Tips The test results of this tool are for reference only，Please refer to the actual use" >> ${LOG_FILE};
echo -e "${Font_Yellow}Checking Unlock Streaming Sites${Font_Suffix}" && echo -e "Checking Unlock Streaming Sites" >> ${LOG_FILE};
echo -e " ** current version: v${shell_version}" && echo -e " ** current version: v${shell_version}" >> ${LOG_FILE};
echo -e " ** system time: $(date)" && echo -e " ** system time: $(date)" >> ${LOG_FILE};

export LANG="en_US";
export LANGUAGE="en_US";
export LC_ALL="en_US";

function InstallJQ() {
    #Install JQ
    if [ -e "/etc/redhat-release" ];then
        echo -e "${Font_Green}installing dependencies: epel-release${Font_Suffix}";
        yum install epel-release -y -q > /dev/null;
        echo -e "${Font_Green}installing dependencies: jq${Font_Suffix}";
        yum install jq -y -q > /dev/null;
        elif [[ $(cat /etc/os-release | grep '^ID=') =~ ubuntu ]] || [[ $(cat /etc/os-release | grep '^ID=') =~ debian ]];then
        echo -e "${Font_Green}Updating package list...${Font_Suffix}";
        apt-get update -y > /dev/null;
        echo -e "${Font_Green}installing dependencies: jq${Font_Suffix}";
        apt-get install jq -y > /dev/null;
        elif [[ $(cat /etc/issue | grep '^ID=') =~ alpine ]];then
        apk update > /dev/null;
        echo -e "${Font_Green}installing dependencies: jq${Font_Suffix}";
        apk add jq > /dev/null;
    else
        echo -e "${Font_Red}Please install jq manually${Font_Suffix}";
        exit;
    fi
}

function PharseJSON() {
    # Instructions: PharseJSON "raw JSON text to parse" "key value to parse"
    # Example: PharseJSON ""Value":"123456"" "Value" [return result: 123456]
    echo -n $1 | jq -r .$2;
}

function PasteBin_Upload() { 
    local uploadresult="$(curl -fsL -X POST \
        --url https://paste.ubuntu.com \
        --output /dev/null \
        --write-out "%{url_effective}\n" \
        --data-urlencode "content@${PASTEBIN_CONTENT:-/dev/stdin}" \
        --data "poster=${PASTEBIN_POSTER:-MediaUnlock_Test_By_CoiaPrant}" \
        --data "expiration=${PASTEBIN_EXPIRATION:-}" \
    --data "syntax=${PASTEBIN_SYNTAX:-text}")"
    if [ "$?" = "0" ]; then
        echo -e "${Font_Green}Report generated ${uploadresult} ${Font_Suffix}";
    else
        echo -e "${Font_Red}Failed to generate report ${Font_Suffix}";
    fi
}

# Streaming Unlock Test - Viu
function MediaUnlockTest_Viu() {
    echo -n -e " Viu:\t\t\t\t->\c";
    local result=`curl -sSL -${1} "https://api.ip.sb/geoip" 2>&1`;
    if [[ "$result" == "curl"* ]];then
        return
    fi
    local result=$(PharseJSON "${result}" "continent_code");
    if [[ "$result" == "AS" ]]; then
        echo -n -e "\r Viu TV:\t\t\t\t${Font_Green}Yes (SG)${Font_Suffix}\n" && echo -e " Viu TV:\t\t\t\tYes (SG)" >> ${LOG_FILE};
        return
    fi
    
    if [[ "$result" == "GEO_CHECK_FAIL" ]]; then
        echo -n -e "\r Viu TV:\t\t\t\t${Font_Red}No${Font_Suffix}\n" && echo -e " Viu TV:\t\t\t\tNo" >> ${LOG_FILE};
        return;
    fi
    
    echo -n -e "\r Viu.TV:\t\t\t\t${Font_Red}Failed (Unexpected Result: $result)${Font_Suffix}\n" && echo -e " Viu TV:\t\t\t\tFailed (Unexpected Result: $result)" >> ${LOG_FILE};
}

# Checking ISP
function ISP(){
    local result=`curl -sSL -${1} "https://api.ip.sb/geoip" 2>&1`;
    if [[ "$result" == "curl"* ]];then
        return
    fi
    local ip=$(PharseJSON "${result}" "ip" 2>&1)
    local isp="$(PharseJSON "${result}" "isp" 2>&1) [$(PharseJSON "${result}" "country" 2>&1) $(PharseJSON "${result}" "city" 2>&1)]";
    if [ $? -eq 0 ];then
        echo " ** IP: ${ip}"
        echo " ** ISP: ${isp}" && echo " ** ISP: ${isp}" >> ${LOG_FILE};
    fi
}

# Media Unlock Test Sites
function MediaUnlockTest() {
    ISP ${1};
    MediaUnlockTest_Viu ${1};
}

curl -V > /dev/null 2>&1;
if [ $? -ne 0 ];then
    echo -e "${Font_Red}Please install curl${Font_Suffix}";
    exit;
fi

jq -V > /dev/null 2>&1;
if [ $? -ne 0 ];then
    InstallJQ;
fi
echo " ** Testing IPv4 Unlocking" && echo " ** Testing IPv4 Unlocking" >> ${LOG_FILE};
check4=`ping 1.1.1.1 -c 1 2>&1`;
if [[ "$check4" != *"unreachable"* ]] && [[ "$check4" != *"Unreachable"* ]];then
    MediaUnlockTest 4;
else
    echo -e "${Font_SkyBlue}The current host does not support IPv4, skip...${Font_Suffix}" && echo "The current host does not support IPv4, skip..." >> ${LOG_FILE};
fi

echo " ** Testing IPv6 Unlocking" && echo " ** Testing IPv6 Unlocking" >> ${LOG_FILE};
check6=`ping6 240c::6666 -c 1 2>&1`;
if [[ "$check6" != *"unreachable"* ]] && [[ "$check6" != *"Unreachable"* ]];then
    MediaUnlockTest 6;
else
    echo -e "${Font_SkyBlue}The current host does not support IPv6, skip...${Font_Suffix}" && echo "The current host does not support IPv6, skip..." >> ${LOG_FILE};
fi
echo -e "";
echo -e "${Font_Green}The test results have been saved to ${LOG_FILE} ${Font_Suffix}";
cat ${LOG_FILE} | PasteBin_Upload;

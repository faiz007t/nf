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
echo -e "${Font_Yellow} **Testing IPv4 unlocking** ${Font_Suffix}" && echo -e " **Testing IPv4 unlocking** " > ${LOG_FILE};
echo -e " ----------------------------------------------\n" && echo -e " ----------------------------------------------\n" > ${LOG_FILE};

export LANG="en_US";
export LANGUAGE="en_US";
export LC_ALL="en_US";

function PharseJSON() {
    # Instructions: PharseJSON "raw JSON text to parse" "key value to parse"
    # Example: PharseJSON ""Value":"123456"" "Value" [return result: 123456]
    echo -n $1 | jq -r .$2;
}

function ISP(){
    local result=`curl --user-agent "${UA_Browser}" -${1} -sL "https://api.ip.sb/geoip" | sed 's/,/\n/g' | grep "ip" | cut -d '"' -f4`;
    local result2=`curl --user-agent "${UA_Browser}" -${1} -sL "https://api.ip.sb/geoip" | sed 's/,/\n/g' | grep "isp" | cut -d '"' -f4`;
	
    if [ -n "$result" ]; then
        echo -n -e " Your ip is: ${result}\n Your network is: ${result2} \n\n==============[ Checking Sites ]===============\n\n" && echo -e " Your ip is: ${result}\n Your network is: ${result2} \n\n==============[ Checking Sites ]===============\n\n" >> ${LOG_FILE};
        return;
    fi
    
    echo -n -e " Your ip is: No\n Your network is: No \n\n==============[ Checking Sites ]===============\n\n" && echo -e " Your ip is: No\n Your network is: No \n\n==============[ Checking Sites ]===============\n\n" >> ${LOG_FILE};
    return;
}

function InstallJQ() {
    #InstallJQ
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

# Gaming Unlock Test - Steam
function MediaUnlockTest_Steam(){
    echo -n -e " Steam Currency:\t\t\t->\c";
    local result=`curl --user-agent "${UA_Browser}" -${1} -fsSL --max-time 30 https://store.steampowered.com/app/761830 2>&1 | grep priceCurrency | cut -d '"' -f4`;
    
    if [ ! -n "$result" ]; then
        echo -n -e "\r Steam Currency:\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n" && echo -e " Steam Currency:\t\t\tFailed (Network Connection)" >> ${LOG_FILE};
    else
        echo -n -e "\r Steam Currency:\t\t\t${Font_Green}${result}${Font_Suffix}\n" && echo -e " Steam Currency:\t\t\t${result}" >> ${LOG_FILE};
    fi
}

# Streaming Unlock Test - PrimeVideo
function MediaUnlockTest_PrimeVideo() {
    echo -n -e " PrimeVideo:\t\t\t\t->\c";
	local result=`curl --user-agent "${UA_Browser}" -${1} -sSL "https://www.primevideo.com/" 2>&1`;
    
    if [[ "$result" == "curl"* ]];then
        echo -n -e "\r PrimeVideo:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n" && echo -e " PrimeVideo:\t\t\t\tFailed (Network Connection)" >> ${LOG_FILE};
        return;
    fi
    
	local result=`curl --user-agent "${UA_Browser}" -${1} -sL "https://www.primevideo.com/" | sed 's/,/\n/g' | grep "country" | cut -d '"' -f4`;
	
    if [ -n "$result" ]; then
        echo -n -e "\r PrimeVideo:\t\t\t\t${Font_Green}${result}${Font_Suffix}\n" && echo -e " PrimeVideo:\t\t\t\t${result}" >> ${LOG_FILE};
        return;
    fi
    
    echo -n -e "\r PrimeVideo:\t\t\t\t${Font_Red}No${Font_Suffix}\n" && echo -e " PrimeVideo:\t\t\t\tNo" >> ${LOG_FILE};
    return;
}

# Streaming Unlock Test - Netflix
function MediaUnlockTest_Netflix() {
    echo -n -e " Netflix:\t\t\t\t->\c";
    local result=`curl -${1} --user-agent "${UA_Browser}" -sSL "https://www.netflix.com/" 2>&1`;
    if [ "$result" == "Not Available" ];then
        echo -n -e "\r Netflix:\t\t\t\t${Font_Red}Unsupport${Font_Suffix}\n" && echo -e " Netflix:\t\t\t\tUnsupport" >> ${LOG_FILE};
        return;
    fi
    
    if [[ "$result" == "curl"* ]];then
        echo -n -e "\r Netflix:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n" && echo -e " Netflix:\t\t\t\tFailed (Network Connection)" >> ${LOG_FILE};
        return;
    fi
    
    local result=`curl -${1} --user-agent "${UA_Browser}" -sL "https://www.netflix.com/title/80018499" 2>&1`;
    if [[ "$result" == *"page-404"* ]] || [[ "$result" == *"NSEZ-403"* ]];then
        echo -n -e "\r Netflix:\t\t\t\t${Font_Red}No${Font_Suffix}\n" && echo -e " Netflix:\t\t\t\tNo" >> ${LOG_FILE};
        return;
    fi
    
    local result1=`curl -${1} --user-agent "${UA_Browser}" -sL "https://www.netflix.com/title/70143836" 2>&1`;
    local result2=`curl -${1} --user-agent "${UA_Browser}" -sL "https://www.netflix.com/title/80027042" 2>&1`;
    local result3=`curl -${1} --user-agent "${UA_Browser}" -sL "https://www.netflix.com/title/70140425" 2>&1`;
    local result4=`curl -${1} --user-agent "${UA_Browser}" -sL "https://www.netflix.com/title/70283261" 2>&1`;
    local result5=`curl -${1} --user-agent "${UA_Browser}"-sL "https://www.netflix.com/title/70143860" 2>&1`;
    local result6=`curl -${1} --user-agent "${UA_Browser}" -sL "https://www.netflix.com/title/70202589" 2>&1`;
    
    if [[ "$result1" == *"page-404"* ]] && [[ "$result2" == *"page-404"* ]] && [[ "$result3" == *"page-404"* ]] && [[ "$result4" == *"page-404"* ]] && [[ "$result5" == *"page-404"* ]] && [[ "$result6" == *"page-404"* ]];then
        echo -n -e "\r Netflix:\t\t\t\t${Font_Yellow}Originals Only${Font_Suffix}\n" && echo -e " Netflix:\t\t\t\tOriginals Only" >> ${LOG_FILE};
        return;
    fi
    
    local region=`tr [:lower:] [:upper:] <<< $(curl -${1} --user-agent "${UA_Browser}" -fs --write-out %{redirect_url} --output /dev/null "https://www.netflix.com/title/80018499" | cut -d '/' -f4 | cut -d '-' -f1)` ;
    
    if [[ ! -n "$region" ]];then
        region="US";
    fi
    echo -n -e "\r Netflix:\t\t\t\t${Font_Green}${region}${Font_Suffix}\n" && echo -e " Netflix:\t\t\t\t${region}" >> ${LOG_FILE};
    return;
}

# Streaming Unlock Test - Youtube
function MediaUnlockTest_YouTube() {
    echo -n -e " YouTube:\t\t\t\t->\c";
    local result=`curl --user-agent "${UA_Browser}" -${1} -sSL "https://www.youtube.com/" 2>&1`;
    
    if [[ "$result" == "curl"* ]];then
        echo -n -e "\r YouTube:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n" && echo -e " YouTube:\t\t\t\tFailed (Network Connection)" >> ${LOG_FILE};
        return;
    fi
    
    local result=`curl --user-agent "${UA_Browser}" -${1} -sL "https://www.youtube.com/red" | sed 's/,/\n/g' | grep "countryCode" | cut -d '"' -f4`;
    if [ -n "$result" ]; then
        echo -n -e "\r YouTube:\t\t\t\t${Font_Green}${result}${Font_Suffix}\n" && echo -e " YouTube:\t\t\t\t${result}" >> ${LOG_FILE};
        return;
    fi
    
    echo -n -e "\r YouTube:\t\t\t${Font_Red}No${Font_Suffix}\n" && echo -e " YouTube:\t\t\tNo" >> ${LOG_FILE};
    return;
}

# Streaming Unlock Test - DisneyPlus
function MediaUnlockTest_DisneyPlus() {
    echo -n -e " Disney+:\t\t\t\t->\c"
	local PreAssertion=$(curl $useNIC $xForward -${1} --user-agent "${UA_Browser}" -s --max-time 10 -X POST "https://global.edge.bamgrid.com/devices" -H "authorization: Bearer ZGlzbmV5JmJyb3dzZXImMS4wLjA.Cu56AgSfBTDag5NiRA81oLHkDZfu5L3CKadnefEAY84" -H "content-type: application/json; charset=UTF-8" -d '{"deviceFamily":"browser","applicationRuntime":"chrome","deviceProfile":"windows","attributes":{}}' 2>&1)
	if [[ "$PreAssertion" == "curl"* ]] && [[ "$1" == "6" ]]; then
		echo -n -e "\r Disney+:\t\t\t\t${Font_Red}IPv6 Not Support${Font_Suffix}\n"
		return
	elif [[ "$PreAssertion" == "curl"* ]]; then
		echo -n -e "\r Disney+:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
		return
	fi

	local assertion=$(echo $PreAssertion | python -m json.tool 2>/dev/null | grep assertion | cut -f4 -d'"')
	local PreDisneyCookie=$(curl -s --max-time 10 "https://raw.githubusercontent.com/lmc999/RegionRestrictionCheck/main/cookies" | sed -n '1p')
	local disneycookie=$(echo $PreDisneyCookie | sed "s/DISNEYASSERTION/${assertion}/g")
	local TokenContent=$(curl $useNIC $xForward -${1} --user-agent "${UA_Browser}" -s --max-time 10 -X POST "https://global.edge.bamgrid.com/token" -H "authorization: Bearer ZGlzbmV5JmJyb3dzZXImMS4wLjA.Cu56AgSfBTDag5NiRA81oLHkDZfu5L3CKadnefEAY84" -d "$disneycookie")
	local isBanned=$(echo $TokenContent | python -m json.tool 2>/dev/null | grep 'forbidden-location')
	local is403=$(echo $TokenContent | grep '403 ERROR')

	if [ -n "$isBanned" ] || [ -n "$is403" ]; then
		echo -n -e "\r Disney+:\t\t\t\t${Font_Red}No${Font_Suffix}\n"
		return
	fi

	local fakecontent=$(curl -s --max-time 10 "https://raw.githubusercontent.com/lmc999/RegionRestrictionCheck/main/cookies" | sed -n '8p')
	local refreshToken=$(echo $TokenContent | python -m json.tool 2>/dev/null | grep 'refresh_token' | awk '{print $2}' | cut -f2 -d'"')
	local disneycontent=$(echo $fakecontent | sed "s/ILOVEDISNEY/${refreshToken}/g")
	local tmpresult=$(curl $useNIC $xForward -${1} --user-agent "${UA_Browser}" -X POST -sSL --max-time 10 "https://disney.api.edge.bamgrid.com/graph/v1/device/graphql" -H "authorization: ZGlzbmV5JmJyb3dzZXImMS4wLjA.Cu56AgSfBTDag5NiRA81oLHkDZfu5L3CKadnefEAY84" -d "$disneycontent" 2>&1)
	local previewcheck=$(curl $useNIC $xForward -${1} -s -o /dev/null -L --max-time 10 -w '%{url_effective}\n' "https://disneyplus.com" | grep preview)
	local isUnabailable=$(echo $previewcheck | grep 'unavailable')
	local region=$(echo $tmpresult | python -m json.tool 2>/dev/null | grep 'countryCode' | cut -f4 -d'"')
	local inSupportedLocation=$(echo $tmpresult | python -m json.tool 2>/dev/null | grep 'inSupportedLocation' | awk '{print $2}' | cut -f1 -d',')

	if [[ "$region" == "JP" ]]; then
		echo -n -e "\r Disney+:\t\t\t\t${Font_Green}JP${Font_Suffix}\n"
		return
	elif [ -n "$region" ] && [[ "$inSupportedLocation" == "false" ]] && [ -z "$isUnabailable" ]; then
		echo -n -e "\r Disney+:\t\t\t\t${Font_Yellow}Available For Disney+ $region Soon${Font_Suffix}\n"
		return
	elif [ -n "$region" ] && [ -n "$isUnavailable" ]; then
		echo -n -e "\r Disney+:\t\t\t\t${Font_Red}No${Font_Suffix}\n"
		return
	elif [ -n "$region" ] && [[ "$inSupportedLocation" == "true" ]]; then
		echo -n -e "\r Disney+:\t\t\t\t${Font_Green}$region${Font_Suffix}\n"
		return
	elif [ -z "$region" ]; then
		echo -n -e "\r Disney+:\t\t\t\t${Font_Red}No${Font_Suffix}\n"
		return
	else
		echo -n -e "\r Disney+:\t\t\t\t${Font_Red}Failed${Font_Suffix}\n"
		return
	fi

}

# Streaming Unlock Test - Viu
function MediaUnlockTest_Viu() {
    echo -n -e " Viu:\t\t\t\t\t->\c";
	local result=`curl --user-agent "${UA_Browser}" -${1} -sSL "https://www.viu.com/" 2>&1`;
    
    if [[ "$result" == "curl"* ]];then
        echo -n -e "\r Viu:\t\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n" && echo -e " Viu:\t\t\t\t\tFailed (Network Connection)" >> ${LOG_FILE};
        return;
    fi
    
	local result=`curl --user-agent "${UA_Browser}" -${1} -sL "https://www.viu.com/" | sed 's/,/\n/g' | grep "ccode" | cut -d '"' -f4`;
	
    if [ -n "$result" ]; then
        echo -n -e "\r Viu:\t\t\t\t\t${Font_Green}${result}${Font_Suffix}\n" && echo -e " Viu:\t\t\t\t\t${result}" >> ${LOG_FILE};
        return;
    fi
    
    echo -n -e "\r Viu:\t\t\t\t\t${Font_Red}No${Font_Suffix}\n" && echo -e " Viu:\t\t\t\t\tNo" >> ${LOG_FILE};
    return;
}

# Streaming Unlock Test - iQiyi
function MediaUnlockTest_iQiyi() {
    echo -n -e " iQiyi:\t\t\t\t\t\t->\c";
	local result=`curl --user-agent "${UA_Browser}" -${1} -sSL "https://www.iq.com/" 2>&1`;
    
    if [[ "$result" == "curl"* ]];then
        echo -n -e "\r iQiyi:\t\t\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n" && echo -e " iQiyi:\t\t\t\t\t\tFailed (Network Connection)" >> ${LOG_FILE};
        return;
    fi
    
	local result=`curl --user-agent "${UA_Browser}" -${1} -sL "https://www.iq.com/" | sed 's/,/\n/g' | grep "modeCode" | cut -d '"' -f4`;
	
    if [ -n "$result" ]; then
        echo -n -e "\r iQiyi:\t\t\t\t\t\t${Font_Green}${result}${Font_Suffix}\n" && echo -e " iQiyi:\t\t\t\t\t\t${result}" >> ${LOG_FILE};
        return;
    fi
    
    echo -n -e "\r iQiyi:\t\t\t\t\t\t${Font_Red}No${Font_Suffix}\n" && echo -e " iQiyi:\t\t\t\t\t\tNo" >> ${LOG_FILE};
    return;
}

# Streaming Unlock Test - Netflix2
function MediaUnlockTest_Netflix2() {
    echo -n -e " Netflix2:\t\t\t\t->\c";
	local result=$(curl -sL "www.netflix.com/redeem" 2>&1);
    
    if [[ "$result" == "curl"* ]];then
        echo -n -e "\r Netflix2:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n" && echo -e " Netflix2:\t\t\t\tFailed (Network Connection)" >> ${LOG_FILE};
        return;
    fi
    
	local result=$(curl -sL "www.netflix.com/redeem" | sed 's/,/\n/g' | grep "countryName" | cut -d '"' -f4)
	
    if [ -n "$result" ]; then
        echo -n -e "\r Netflix2:\t\t\t\t${Font_Green}${result}${Font_Suffix}\n" && echo -e " Netflix2:\t\t\t\t${result}" >> ${LOG_FILE};
        return;
    fi
    
    echo -n -e "\r Netflix2:\t\t\t\t${Font_Red}No${Font_Suffix}\n" && echo -e " Netflix2:\t\t\t\tNo" >> ${LOG_FILE};
    return;
}

# Media Unlock Test Sites
function MediaUnlockTest() {
    ISP ${1};
    MediaUnlockTest_iQiyi ${1};
    MediaUnlockTest_DisneyPlus ${1};
    MediaUnlockTest_PrimeVideo ${1};
    MediaUnlockTest_Viu ${1};
    MediaUnlockTest_Netflix ${1};
    MediaUnlockTest_Netflix2 ${1};
    MediaUnlockTest_Steam ${1};
    MediaUnlockTest_YouTube ${1};
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
check4=`ping 1.1.1.1 -c 1 2>&1`;
if [[ "$check4" != *"unreachable"* ]] && [[ "$check4" != *"Unreachable"* ]];then
    MediaUnlockTest 4;
else
    echo -e "${Font_SkyBlue}The current host does not support IPv4, skip...${Font_Suffix}" && echo "The current host does not support IPv4, skip..." >> ${LOG_FILE};
fi
echo -e " \n===============================================\n" && echo -e " \n===============================================\n" >> ${LOG_FILE};

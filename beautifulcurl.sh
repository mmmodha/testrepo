#!/bin/bash
#Author: mehul.modha@alation.com
#With thanks to the following contributors for testing: michelle.lam@alation.com, francis.schulz@alation.com, 
#soeba.qureshi@alation.com, andreas.neuhauser@alation.com, liza.branella@alation.com
#Created: 22/11/2022
#This script will run a curl command for you and beautify the output into JSON format.
# NOTE: You must have JQ installed in your machine: you can do this from homebrew: https://github.com/stedolan/jq/wiki/Installation
# 1: variable is name of file - be specific, if you run this many times you may want to organise you files later
# 2: what is the curl api endpoint you want to hit, use https://developer.alation.com/dev/ to help you form this and copy the bit in front of --url
# 3: please have a valid API token: see how to do this https://developer.alation.com/dev/docs/authentication-into-alation-apis

set -e
Red=`tput setaf 1`
Green=`tput setaf 2`
NOCOl=`tput sgr0`
Yellow=`tput setaf 3`
Cyan=`tput setaf 6`
White=`tput bold`  


#---------Please set the values in this section---------#
#Insert Token Value between "" and remove <>
#API tokens expire every 24hrs
#Need Help? How to get your API token https://developer.alation.com/dev/docs/authentication-into-alation-apis 
API_TOKEN_VALUE=$"TbctT6MNHyANHJGD9uwWLDbtSVhrwhYPXz1O1pp0eOg"
#Insert User ID for the matching API token between "" and remove <>
user_id=$"1"
#Insert you catalog URL endpoint between "" and remove <>
#Note: DO NOT include the trailing '/' in your url. Example https://www.<domainname>.alationcatalog.com 
curl_URL_ENDPOINT=$"https://skf-eval.alationcatalog.com/"
#--------------------------------------------------------


DELIMITER=$"-------------------------------------------"

echo $"-----------------------------------------------------------------${Cyan}"
echo '|    __                     __  _ ____      __                __|'
echo '|   / /_  ___  ____ ___  __/ /_(_) __/_  __/ /______  _______/ /|'
echo '|  / __ \/ _ \/ __ `/ / / / __/ / /_/ / / / / ___/ / / / ___/ / |'
echo '| / /_/ /  __/ /_/ / /_/ / /_/ / __/ /_/ / / /__/ /_/ / /  / /  |'
echo '|/_.___/\___/\__,_/\__,_/\__/_/_/  \__,_/_/\___/\__,_/_/  /_/   |' ${NOCOl} 
echo $"-----------------------------------------------------------------"                                                               

echo ${DELIMITER}
echo -e "${Cyan}Action${NOCOl} : Checking JQ is installed "
if [ "$(command -v jq)" ] 
	then
	echo "${Green} INFO ${NOCOl}: JQ found in environment"
	echo "${Green} JQ Version Number ${NOCOl}: $(command jq --version)"	
	else
		echo "${Red} ERROR ${NOCOl} : JQ missing from you machine, please install"
		exit 1 
fi

echo ${DELIMITER}


echo ${DELIMITER}
echo -e "${Cyan}Action${NOCOl} : Checking Python is installed "
if [ "$(command -v python3 -version)" ] 
	then
	echo "${Green} INFO ${NOCOl}: Python found in environment"
	echo "${Green} Python Version Number ${NOCOl}: $(command python3 --version)"	
	else
		echo "${Red} ERROR ${NOCOl} : Python missing from you machine, please install"
		exit 1 
fi

echo -e "${Cyan}Action${NOCOl} : Checking you have Pandas is installed "
if python3 -c 'import pkgutil; exit(not pkgutil.find_loader("pandas"))'; then
    echo "${Green} INFO ${NOCOl}: Pandas found in environment"
    echo "${Green} Pandas Version Number ${NOCOl}: $(command pip3 show pandas | grep Version)"
else
    echo "${Yellow} WARN ${NOCOl} : Pandas are missing from you machine, attempting to install"
    pip3 install pandas
    if python3 -c 'import pkgutil; exit(not pkgutil.find_loader("pandas"))'; then
    	echo "${Green} INFO ${NOCOl}: Pandas are now found in environment"
    	echo "${Green} Pandas Version Number ${NOCOl}: $(command pip3 show pandas | grep Version)"
		else
    	echo "${Red} ERROR ${NOCOl} : Pandas is still missing from you machine after attempted install, please install manually"
    	exit 1
		fi
fi

echo ${DELIMITER}
echo -e "${Cyan}Action${NOCOl} : Checking Argument Values"
echo ${DELIMITER}
echo -e "${Cyan}Action${NOCOl} : Checking you have a file name ${NOCOl}"
if [ -z "$1" ]
  then
    echo "${Red} ERROR ${NOCOl} : Missing File Name" 
    exit 1
fi
echo "${Green} Success ${NOCOl}"
echo ${DELIMITER}

echo "${Cyan}Action${NOCOl} : Checking you have a API URL endpoint"
if [ -z "$2" ]
  then
    echo "${Red} ERROR ${NOCOl} : Missing URL Endpoint to GET from"
    exit 1
fi
echo "${Green} Success ${NOCOl}"

echo ${DELIMITER}
echo "${Cyan}Action${NOCOl} : Checking you have a token"
if [ -z "$API_TOKEN_VALUE" ]
  then
    echo "${Red} ERROR ${NOCOl} : Missing token"
    exit 1
fi
echo "${Green} Success ${NOCOl}"


echo ${DELIMITER}
echo -e "${Cyan}Action${NOCOl} : Validating API access token"

curl --fail --request POST \
     --url ${curl_URL_ENDPOINT}/integration/v1/validateAPIAccessToken/ \
     --header 'accept: application/json' \
     --header 'content-type: application/json' \
     --data '
{
     "api_access_token": "'${API_TOKEN_VALUE}'",
     "user_id": '${user_id}'
}
' || (echo "${Red} ERROR ${NOCOl} : Token is invalid - please check both the token and the user ID the token has come from" && exit 1)

echo""


echo ${DELIMITER}
echo "${Cyan}Your Inputs${NOCOl} : "
echo "${Green} INFO ${NOCOl} - File name as: $1"
echo "${Green} INFO ${NOCOl} - URL endpoint as: ${curl_URL_ENDPOINT}$2"
echo "${Green} INFO ${NOCOl} - API token as: ${API_TOKEN_VALUE}"

directory_name="$1-$(date '+%Y-%m-%d-%H%M')"
echo ${DELIMITER}
echo "${Green} INFO ${NOCOl} - Making directroy for storing information, the directory name is: ${directory_name}"
mkdir ${directory_name}

echo ${DELIMITER}
echo "${Cyan}Action${NOCOl} : Running Curl Command"
curl --request GET \
     --url ''${curl_URL_ENDPOINT}$2'' \
     --header 'TOKEN: '${API_TOKEN_VALUE}'' \
     --header 'accept: application/json' > ${directory_name}/$1.json
echo ${DELIMITER}

echo "${Cyan}Action${NOCOl} : Beautifying JSON output"
jq . ${directory_name}/$1.json > ${directory_name}/$1_pretty_output.json
echo "${Green} INFO ${NOCOl} : Complete - please open ${directory_name}/${White}$1_pretty_output.json${NOCOl} to see you API output"
echo ${DELIMITER}
echo "${Cyan}Action${NOCOl} : Turning JSON output into CSV"
python3 beautifulcurl.py ${directory_name}/$1.json $1_csvoutput
mv $1_csvoutput.csv "${directory_name}/"
echo "${Green} INFO ${NOCOl} : Complete - please open ${White}${directory_name}/$1_csvoutput${NOCOl} to see you API output as a CSV file"
echo ${DELIMITER}



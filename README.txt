Why BeautifulCurl?
- Sometimes you might not be able to use POSTMAN, some customer might not be able to install postman you might want to run GET command, and get beautified results.
- Sometime you want to store the results, this can be a bit of a manual process when you do this in postman, even though it will give you a JSON response which is well formatted. This application will run the GET request for you, beautify is using JQ and then turn it into a CSV file using python.

Components: 
- beautifulcurl.py, takes your JSON payload and turns it into CSV file for you to inspect
- beautifulcurl.sh, takes your URL, Token, Endpoint and Filename, verifies the environment and token, then runs the commands to get three outputs: the original JSON payload, a organised version of the JSON payload, a tabluar version of the JSON payload using Pandas and Dataframes. 

Requirements: 
- Script will check that you have Python3, JQ and Pandas installed
- Pythons and JQ you will manually need to install, script will stop if not present on your machine 
- Pandas the script will attempt to install itself so don't worry too much there. 

How to run the Script: 
1) Download ZipFile
2) Extract ZipFile 
3) Make beautifulcurl.sh executable: chmod +x beautifulscript.sh
4) Use the text editor of your choice or vim to add the following variables to beautifulscript.sh
	i)   API_TOKEN_VALUE
    ii)  user_id
    iii) curl_URL_ENDPOINT
    There is help in the script file with examples for each.
5) You are now ready to execute the script, the script takes two variables, file name and endpoint you want to curl. Filename is the title you give for the specifc curl. For example if I want to get all articles I might run the script in the following way:
./beautifulscript.sh getAllArticles '/integration/v1/article/'

Template: ./beautifulscript filename 'endpoint'

6) Note: you don't need to put the entire URL, just the integration you want to interact with start with the '/integration' onwards

7) The script will make a directory as follows (filename-TIMESTAMP) and put 3 files in there:
i)   filename.json
ii)  filename_pretty_output.json
iii) filename_csvoutput.csv
import os
import time
import requests

community_files_cached = None

GITHUB_USERNAME = ""
GITHUB_TOKEN = ""

while(True):
    community_files = requests.get('https://api.github.com/repos/PeterPgit/HackKU2022/contents/Community_Upload', auth=(GITHUB_USERNAME, GITHUB_TOKEN)).json()
    community_files_length = len(community_files)
    if community_files_cached == None or community_files_cached != community_files_length:
        os.system("pixlet render ~/Desktop/HackKU2022/HackKU2022.star")
        print("Rendered .star file")
        os.system("pixlet push -i HackKU2022 [DEVICE_ID] -t [DEVICE_API_KEY] [FILE_PATH]")
        print("Pushed to device")
        community_files_cached = community_files_length
    else:
        print("\n No files changed in repo; displaying cached.")
    time.sleep(10)

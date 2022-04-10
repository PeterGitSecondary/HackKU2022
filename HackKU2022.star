"""
Applet: HackKU2022
Summary: Allows anyone to display words/images to the LED Display.
Description: The University of Kansas 2022 Hackathon Submission.
Author: Peter Pham
"""

load("render.star", "render")
load("encoding/base64.star", "base64")
load("schema.star", "schema")
load("http.star", "http")
load("encoding/json.star", "json")
load("cache.star", "cache")


GITHUB_API_REPO_URL = "https://api.github.com/repos/PeterPgit/HackKU2022/contents/Community_Upload"
GITHUB_TOKEN = ""

image_extensions = [".png", ".jpeg", ".jpg"]
text_extensions = ".txt"

def get_repo_contents(url):
    headers = {'Authorization': 'token %s' % GITHUB_TOKEN}
    http_response = http.get(url, headers = headers)
    data = http_response.json()
    return data

def main(config):
    repo_content = get_repo_contents(GITHUB_API_REPO_URL)

    community_files = []
    text_file_indexes = []

#    print("\nRecorded repo length is: " + str(len(repo_content)))

    repo_length_cached = cache.get("repo_length")

#    print("Cached repo length is: " + str(repo_length_cached))

    if repo_length_cached != None and int(repo_length_cached) == len(repo_content):
        print("Hit! Displaying cached data.")
        file_num = 0
        while file_num < int(repo_length_cached):
            community_files.append(cache.get("community_files"+ str(file_num)))
            file_num += 1

        text_file_indexes_str = cache.get("text_file_indexes")
        text_file_indexes_list = text_file_indexes_str.split(",");
        for i in text_file_indexes_list:
            i = i.replace("[","").replace("]","").replace(" ", "")
            text_file_indexes.append(int(i))

    else:
        print("Miss! Calling Github API.")
        file_num = 0
        for file in repo_content:
            for extension in image_extensions:
                if extension in file["name"]:
                    file_url = file["_links"]["git"]
                    print("image: " + file_url)
                    req_response = get_repo_contents(file_url)
                    image_data_encoded = req_response["content"]
                    image_data_decoded = base64.decode(image_data_encoded)
                    community_files.append(image_data_decoded)
                    cache.set("community_files" + str(file_num), community_files[file_num], ttl_seconds=600)
                    file_num += 1
            if text_extensions in file["name"]:
                file_url = file["_links"]["git"]
                print("text: " + file_url)
                req_response = get_repo_contents(file_url)
                text_data_encoded = req_response["content"]
                text_data_decoded = base64.decode(text_data_encoded)
                community_files.append(text_data_decoded)
                cache.set("community_files" + str(file_num), community_files[file_num], ttl_seconds=600)
                text_file_indexes.append(file_num)
                file_num += 1
        cache.set("repo_length", str(int(len(repo_content))), ttl_seconds=600)
        cache.set("text_file_indexes", str(text_file_indexes), ttl_seconds=600)

    if len(community_files) > 0:
#        print(text_file_indexes)
        animation_children = []
        file_num = 0
        for i in community_files:
            if file_num in text_file_indexes:
#                print(str(file_num) + " is a text file")
                text = render.WrappedText(
                    content=community_files[file_num],
                    width=64,
                    color="#fa0",
                    )
#                   text = render.Marquee(
#                       width=64,
#                       child=render.Text(community_files[file_num]),
#                       offset_start=5,
#                       offset_end=32,
#                   )
                file_num += 1
                animation_children.append(text)
                
            else:
                image = render.Image(
                    width = 64,
                    height = 32,
                    src = community_files[file_num],
                )
                file_num += 1
                animation_children.append(image)
        

#            print(animation_children)

#    print("Length of community files is: " + str(len(community_files)))
#    print("Text file indexes are: " + str(text_file_indexes))

    return render.Root(
            delay = 2000,
            child = render.Box(
                child = render.Row(
                        expanded = True, # uses as much horizontal space as possible
                        cross_align="center", # Controls vertical alignment
                        children = [
                            render.Animation(
                                children = animation_children
                            )
                        ]
                )
            )
    )


def get_schema():
    return schema.Schema(
        version = "1", 
        fields = [
        ]
    )

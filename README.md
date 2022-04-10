# HackKU2022 Submission: Communal LED Display
 
<p align="center">
 <img src="https://user-images.githubusercontent.com/41265442/162598928-dde48fc8-8127-4a9c-9ffb-429378da47d8.jpg" width=50% height=50%>
</p>



I recently purchased a Tidbyt, which is a 32x64 programmable LED display. It works great, though you are only have to customize what is being displayed through the app. This essentially means I'm the only one who can make changes to it, which greatly limits it's potential. To allow others to contribute to the display, I created this program so that anyone with a GitHub account is able to submit an image or text to be displayed, all in real-time.

This program as a couple of parts to it. The first is the GitHub repository itself. Using a third party program called Mergify, I set conditions for pull requests so that when those conditions are met, that PR is automatically merged into main. In this case, those conditions limit users to only making image file changes (.png, .jpeg, and .jpg) and text file changes (.txt) within the Community_Upload folder. From there, the python file will constantly check for changes in the directly using GitHub's API. Once a change is detected, it will pull all of the image & text files from the directly, put them through the Starlark file and Pixlet renderer, and upload the resulting .webp file onto the physical display itself.


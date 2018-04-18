# YouTube Video Compression Automation

This is a Windows Powershell project. 

As an content creator for YouTube, I'm always looking for ways to automate my tasks. The idea behind this project is be able to take 1 or more video files, and based on the file name, combine different parts of the content, followed by compressing the file. The conpression and concatination of the content will be performed using ffmpeg, using pre-defined strings which will be witin the powershell script.

This is my first GH repo, and I've been using the MVA course "GITHUB for Windows Users" (https://mva.microsoft.com/en-US/training-courses/github-for-windows-users-16749)

## NAMING CONVENTION

This script is based on a naming convention I use when preparing my videos for compression

**_Single Files_** - This is when the video you want to compress is in a single part. The naming convention used for these is <number>.<filename>.<extension> where <number> = the order the video was recorded in, <filename> is the name of the video and <extension> is the file type of the video
  
**_Multiple Files_** - This is when the video you want to compess is in multple parts and needs to be joined together before compression. The naming convention used for these is <number>.<filename>_<partNumber>.<extension> where <number> = the order the video was recorded in, <filename> is the name of the video, <partNumber> defines the order the clips should be joined and <extension> is the file type of the video 

## USAGE

There are currently 2 variables which need to be set when using this script. You'll find these between a commented block titled "EDITABLE REGION" at the start of the script

**_$fileExt_** - This is the file type you want the script to target

**_$location_** - This is the base folder where you'll put all of the files you want the script to process

**_$ffmpegLocation_** - This is the physical path to ffmpeg.exe

**_$joinCommand_** - This is the arguments I use to join my clips together. This will also uses the **_$location_** {0} and **_$fileExt_** {2} as part of the variable.  {1} refers to the name of the folder/file

# YouTube Video Compression Automation

This is a Windows Powershell project. 

As an content creator for YouTube, I'm always looking for ways to automate my tasks. The idea behind this project is be able to take 1 or more video files, and based on the file name, combine different parts of the content, followed by compressing the file. The conpression and concatination of the content will be performed using ffmpeg, using pre-defined strings which will be witin the powershell script.

This is my first GH repo, and I've been using the MVA course "GITHUB for Windows Users" (https://mva.microsoft.com/en-US/training-courses/github-for-windows-users-16749)

USAGE

There are currently 2 variables which need to be set when using this script. You'll find these between a commented block titled "EDITABLE REGION" at the start of the script

$fileExt - This is the file type you want the script to target
$location - This is the base folder where you'll put all of the files you want the script to process

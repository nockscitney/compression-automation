## VIDEO COMPRESION AUTOMATION SCRIPT ##
##
## Version:            1.3.1
## Last Update:        2018-04-24
## Last Updated By:    Nick Scotney
## Git Hub URL:        https://github.com/nockscitney/compression-automation
## Branch Name:        video-compression


## EDITABLE REGION ##
## Variables which are safe to edit reside there

# Tells the script whether or not to tidy up the original files (move them to the bin) once the compression has completed
$runCleanup = 0

# This variable will be used to hold the file extension we're currently working on
$fileExt = ".mkv" 

# This is the path to your command line ffmpef
$ffmpegLocation = "<<PATH TO FFMPEG>>"

# This variable will tell the script where the base folder is and should be where all the files you want to process reside when you run the script
$location = "<<PATH TO BASE LOCATION>>"
$finishedLocation = "<<PATH TO FINAL LOCATION>>"

# This variable is the settings for joining multiple clips together into a single video. This uses the $ffmpegLocation variable to know where the program is when running the join
# The joined video will then be saved in the current working folder, which is set later in the script
$joinCommand = "-f concat -safe 0 -i {0}\{1}\fileList.txt -c copy {0}\{1}\{1}{2}"

# This variable is the setting which will compress the clips. This uses the $ffmpegLocation variable to know where the program is when running the compress. Once compressed, the video
# will then be saved in the current working directory
$compressCommand = "-i {0}\{1}\{1}{2} -c:v libx265 -preset ultrafast -crf 15 -c:a copy {3}\{1}_compressed{2}"

## END EDITABLE REGION ##

# Here you'll need to set the base location of your video folder
Set-Location $location

# This will hold an array of files, which match the extension you're looking to match. In this case, I'm looking only for text files, however the 
$workingList = Get-ChildItem -Filter *$fileExt

# Here we'll loop the folder file array, assuming we have something that is
foreach($folderFile in $workingList)
{
    # Here we set the folder name that will be created.  We do this be stripping out the file extension and splitting the string on an '_' character, based on my namin convension when
    # there are more than on part needed for the final video.  I.E. if we have files '1.test_1.ext' and '1.test_2.ext' both files will be placed into a folder called '1.test'
    $shortFile = $folderFile.Name.Replace($fileExt,"").Split("_")[0]

    # Here's we're going to check to see if the folder exists, and if it doesn't we'll create a new one
    if(!(Test-Path -path $shortFile)) {
        New-Item -ItemType Directory -Name $shortFile
    }
    
    # Now we know the folder exists, we'll move the current file into the folder
    Move-Item -Path $folderFile.PSPath -Destination $shortFile    
}

# We're done with the list, so to be safe, we'll clear it before proceeding any further
$workingList = @()

# Now we're going to be working on a folder at a time. First, we need the list of folders and assign it to $workingList
$workingList = Get-ChildItem -Directory

# Loop the list to begin the processing
foreach($folder in $workingList)
{
    # Update the location
    Set-Location $location\$folder

    # Now we need to check if there is more than one item in the folder, if there is the we'll need to join them together before we can compress them
    if(($folderFilesList = Get-ChildItem).Count -gt 1)
    {
        # We'll need to create a list for the join to work from
        New-Item -Path . -Name "fileList.txt" -ItemType File

        foreach($folderFile in $folderFilesList) 
        {
            # The file list items need to be surrounded by ' ' so we're using an variable here to create the correct string first, before adding it to the command
            $argumentList = "file '{0}\{1}\{2}'" -f $location, $folder, $folderFile
            # Add the line to the file here
            Add-Content -Value $argumentList  -Path .\"fileList.txt"
        }

        # Pause for a second to make sure we've created the list
        Start-Sleep -s 2

        # Build the argument list that we want to use to join the clips together
        $argumentList = $joinCommand -f $location, $folder, $fileExt
        
        # Write this out to the screen to be sure it's right
        Write-Host -ForegroundColor Green -Object $argumentList

        # Start ffmpeg joining the files together
        Start-Process $ffmpegLocation -ArgumentList $argumentList -Wait
    }    
    
    # Now we can compress the video itself
    $argumentList = $compressCommand -f $location, $folder, $fileExt, $finishedLocation
        
    # Write this out to the screen to be sure it's right
    Write-Host -ForegroundColor Green -Object $argumentList

    # Start ffmpeg joining the files together
    Start-Process $ffmpegLocation -ArgumentList $argumentList -Wait

    # Here we'll check to see if we need to run the clean-up
    if($runCleanup -eq 1)
    {
        # Change the folder location here, else PS will thrown an error saying the folder is in use
        Set-Location $location
        # Delete the folder and all it's child items. Items are only moved to the recycle bin, so can always be recovered at a later date
        Remove-Item -Path $location\$folder -Recurse
    }
} 

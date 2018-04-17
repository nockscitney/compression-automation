## VIDEO COMPRESION AUTOMATION SCRIPT ##
##
## Version:            1.0
## Last Update:        2018-04-17
## Last Updated By:    Nick Scotney
## Git Hub URL:        https://github.com/nockscitney/compression-automation


## EDITABLE REGION ##

## Variables which are safe to edit reside there

# This variable will be used to hold the file extension we're currently working on
$fileExt = ".txt"

# Here you'll need to set the base location of your video folder
Set-Location "C:\Users\Nick\Desktop\Powershell"

## END EDITABLE REGION ##


# This will hold an array of files, which match the extension you're looking to match. In this case, I'm looking only for text files, however the 
$folderFiles = Get-ChildItem -Filter *$fileExt

# Here we'll loop the folder file array, assuming we have something that is
foreach($folderFile in $folderFiles)
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
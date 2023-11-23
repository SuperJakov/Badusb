# Clear the screen
Clear-Host
# Get the folder path from the user input
$folderPath = Read-Host "Type folder path to organise "

# Get all the subfolders in the root folder
$subFolders = Get-ChildItem -Recurse -Path $folderPath -Directory 

# Loop through each subfolder
foreach ($subFolder in $subFolders) {
  # Get all the files in the subfolder
  $files = Get-ChildItem -Path $subFolder.FullName -File
  # Loop through each file
  foreach ($file in $files) {
    # Move the file to the root folder
    Move-Item -Path $file.FullName  -Destination $folderPath 
  }
}

# Define a hashtable that maps the extensions to the subfolder names
$extToSubfolder = @{ 
  ".jpg"  = "Images" 
  ".jpeg" = "Images" 
  ".png"  = "Images" 
  ".heic" = "Images"
  ".heif" = "Images"
  ".webp" = "Images"
  ".tiff" = "Images"
  ".eps"  = "Images"
  ".svg"  = "Images"
  ".ai"   = "Images"
  ".pdf"  = "PDF"
  ".gif"  = "GIF" 
  ".ps1"  = "Code" 
  ".py"   = "Code" 
  ".java" = "Code" 
  ".js"   = "Code"
  ".cs"   = "Code" 
  ".c"    = "Code"
  ".h"    = "Code"
  ".cpp"  = "Code"
  ".hpp " = "Code"
  ".php"  = "Code"
  ".ts"   = "Code"
  ".r"    = "Code"
  ".html" = "Code" 
  ".rb"   = "Code"
  ".go"   = "Code"
  ".vba"  = "Code"
  ".vbs"  = "Code"
  ".rs"   = "Code"
  ".lua"  = "Code"
  ".m"    = "Code"
  ".txt"  = "Text" 
  ".csv"  = "Text" 
  ".docx" = "MS Word" 
  ".doc"  = "MS Word" 
  ".xlsx" = "MS Excel"
  ".xls"  = "MS Excel" 
  ".xlss" = "MS Excel"
  ".xlsm" = "MS Excel"
  ".xlsb" = "MS Excel"
  ".xla"  = "MS Excel add-in files"
  ".pptx" = "MS Powerpoint" 
  ".ppt"  = "MS Powerpoint" 
  ".ppsx" = "MS Powerpoint" 
  ".mp3"  = "Audio" 
  ".wav"  = "Audio" 
  ".mp4"  = "Video" 
  ".avi"  = "Video" 
  ".webm" = "Video"
  ".zip"  = "Compressed" 
  ".rar"  = "Compressed" 
  ".gz"   = "Compressed"
  ".exe"  = "Executable" 
  ".dll"  = "Executable" 
  ".dng"  = "Raw Photos"
}

# Loop through each subfolder name and create a subfolder with the same name
foreach ($subfolder in $extToSubfolder.Values | Sort-Object -Unique) {
  # Create the subfolder path
  $subFolderPath = Join-Path -Path $folderPath -ChildPath $subfolder
  # Create the subfolder if it does not exist
  if (-not (Test-Path -Path $subFolderPath)) {
    New-Item -Path $subFolderPath -ItemType Directory
  }
}

# Move the files into the subfolders based on their extensions
Get-ChildItem -Path $folderPath -File | Move-Item -Destination { Join-Path -Path $folderPath -ChildPath $extToSubfolder[$_.Extension] }

# Delete any subfolders that have no files in them
Get-ChildItem -Path $folderPath -Directory | Where-Object { (Get-ChildItem -Path $_.FullName -File).Count -eq 0 } | Remove-Item
Clear-Host
Write-Host "Done Organising"
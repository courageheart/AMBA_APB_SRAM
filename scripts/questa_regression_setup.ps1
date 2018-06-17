###################################################################################################################
#.SYNOPSYS
#This script prepares the necessary files for running regression tests with Questa Verification Run Manager (VRM)
#
#.DESCRIPTION
#
#
###################################################################################################################
param(
    [string] $regressionMode="c",
    [string] $fileListLocation="..\sim\tb_filelist.f",
    [string] $rmdbFileLocation="apb_regression.rmdb",
    [string] $vrmFilelistLocation="..\sim\",
    [string] $vrmFilelist="tb_filelist_VRM.f",
    [switch] $startFresh = $false 
)

# Get full VRM File location
$vrmFilelistAbsLocation = [System.IO.Path]::GetFullPath((Join-Path (pwd) $vrmFilelistLocation) )
#$vrmFilelistAbsLocation = [System.IO.Path]::GetFullPath((Join-Path (pwd) '..\scripts') )
echo($vrmFilelistAbsLocation)
Out-File -FilePath ($vrmFilelistAbsLocation+'\'+$vrmFilelist)

# Clean up old regression files
#if(Test-Path '..\sim\VRMDATA*'){
#    Remove-Item -Path '..\sim\VRMDATA*' -Recurse
#}

#if($startFresh -eq $true) {
#    # Clean up old generated filelist
#    if(Test-Path '..\sim\' -Include "tb_filelist_VRM.f"){
#        Remove-Item -Path '..\sim\tb_filelist_VRM.f'
#    }
#}

# check if main filelist exists
if((Test-Path -Path $fileListLocation) -eq $false){
    echo("Error. $filelistlocation can not be opened for read or write. Please check the location.")
    echo("The script is exiting..")
    exit
}

# Create filelist with absolute path from filelist with relative path
if($startFresh -eq $true){
    # Create empty filelist for writing absolute paths
    Out-File -FilePath ($vrmFilelistAbsLocation+'\'+$vrmFilelist)
    # Read filelist with realtive path and generate filelist with absolute path 
    foreach($line in Get-Content $fileListLocation){
        # if the line is a commnet (i.e. starts with '//') then output it to the filelist as it is
        if($line -match "^//"){
            $line | Out-File -FilePath ($vrmFilelistAbsLocation+'\'+$vrmFilelist) -Append
        }
        elseif($line -match "(?<=\+incdir\+).*$"){
            $relPath = $line -split ("\+incdir\+",2)
            $absPath = Resolve-Path ($relPath.ToString())
            echo($relPath)
            echo($absPath)
        }
    }
}

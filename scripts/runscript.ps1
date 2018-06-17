######################################################################################################
#.SYNOPSYS
#Run script for running tests with different run option and coverage sampling and report generation
#
#.DESCRIPTION
#Runscript will take several parameters such as,
#*)testName: UVM Test Name for running. Default is apb_reg_por_read_test
#*)mode: Run mode. Set to 'c' for running simulation in batch mode and 'gui' for running simulation in gui mode
#*)logFile: location of simulation log files. By default it is set to "../simlog/"+<testName>+".log"
#*)seed: sv seed value for randomization. Default is set to random
#*)verbosity: UVM Verbosity Level. Default is set to UVM_NONE.
#*)cov: A switch for enabling code coverage sampling
#*)covoptions: Coverage options. Default is set to 'bcest'. Available options are:
#                    -> b–Collect branch statistics
#                    -> c–Collect condition statistics.
#                    -> e–Collect expression statistics.
#                    -> s–Collect statement statistics. Default.
#                    -> t–Collect toggle statistics. Cannot be used if ’x’ is specified.
#                    -> x–Collect extended toggle statistics
#*)covmerge: switch for enabling coverage database merge option. It is useful for merging test coverage databases during regression run
#*)mergeFileName: Name of the merged coverage file. Only works if covmerge switch is enabled. Default is set to "mergedCoverage"
#*)export_cov_report_html: switch for enabling exporting coverage report in html format
#*)htmlreportDir: Directory to save html report. Must be used with 'export_cov_report_html' enabled. Default value is: '../sim/covhtmlreport'
#*)UserDefines: User specific defines used for simulation purpose.
#
#.EXAMPLE
#./runscript.ps1 apb_directed_reg_write_read_test -mode gui -cov APB_SLV_WAIT_FUNC_EN=0
#    
#.NOTES
#This script supports Mentor QuestaSim and ModelSim Only.
#       
##############################################################################################################
param(
    [string] $testName = "apb_reg_por_read_test",
    [string] $mode='c',
    [string ]$logFile = "../simlog/"+$testName+".log",
    [string] $seed = "random",
    [string] $verbosity = "UVM_NONE",
    [switch] $cov = $false,
    [string] $covoptions = "bcest", # b–Collect branch statistics.
                                    # c–Collect condition statistics.
                                    # e–Collect expression statistics.
                                    # s–Collect statement statistics. Default.
                                    # t–Collect toggle statistics. Cannot be used if ’x’ is specified.
                                    # x–Collect extended toggle statistics
    [switch] $covmerge = $false,
    [string] $mergeFileName = "mergedCoverage",
    [switch] $export_cov_report_html = $false,
    [string] $htmlreportDir = "../sim/covhtmlreport",
    [string[]] $UserDefines
)

##################################### User defined Functions ############################################################
#############################################################################
# Function : pass_user_defines
# Return Type: String
# Description: Creates define command line options and return them for use
#############################################################################
function pass_user_defines {
    $index=0
    $defineName=""
    # generate define strings
    foreach($i in $UserDefines){
        if($defineName -ne ""){
            $defineName = $defineName + " " + "+define+"+$i
        }
        else {
            $defineName = "+define+"+$i
        }
    }
    return $defineName
}

# Clean up Previous Simulation Log Files
if(Test-Path "..\simlog\" -Include $testName+".log") {
    Remove-Item -Path $logFile
}

# Clean up Previous Simulation Files
if(Test-Path "..\sim\work"){
    Remove-Item -Path '..\sim\work' -Recurse
}

Write-Host("logfile location: ")
Write-Host($logFile)

#create library
vlib work
# map to library
vmap work
if($cov -eq $false) {
    if($UserDefines.Length -ne 0){
        $UserDefines=pass_user_defines
        # Compile RTL and Tb files with user defines
        vlog -novopt -f ../sim/tb_filelist.f -timescale 1ns/1ps $UserDefines
    }
    else {
        # Compile RTL and Tb files
        vlog -novopt -f ../sim/tb_filelist.f -timescale 1ns/1ps
    }

    # Simulate RTL and tb files
    if($mode -eq "c") {  # run in commandline mode
        vsim tb_top -$mode +UVM_TESTNAME=$testname -l $logFile -sv_seed $seed +UVM_VERBOSITY=$verbosity -do "run -all"
    }
    else {  # run in gui mode
        vsim tb_top -$mode +UVM_TESTNAME=$testname -l $logFile -sv_seed $seed +UVM_VERBOSITY=$verbosity
    }
}
else {
    if($UserDefines.Length -ne 0){
        $UserDefines=pass_user_defines
        # Compile RTL and Tb files with user defines
        vlog -novopt -f ../sim/tb_filelist.f -timescale 1ns/1ps $UserDefines
    }
    else {
        # Compile RTL and Tb files
        vlog -novopt -f ../sim/tb_filelist.f -timescale 1ns/1ps
    }

    # Simulate RTL and tb files with coverage enabled
    if($mode -eq "c") {  # run in commandline mode
        vsim tb_top -c +UVM_TESTNAME=$testname -l $logFile -sv_seed $seed +UVM_VERBOSITY=$verbosity -coverage -voptargs="+cover=bcfst" -do "coverage save -onexit $testname.ucdb; run -all; exit"
    }
    else {  # run in gui mode
        vsim tb_top -gui +UVM_TESTNAME=$testname -l $logFile -sv_seed $seed +UVM_VERBOSITY=$verbosity -coverage -do "coverage save -onexit $testname.ucdb;"
    }
}

##################################### Coverage Reporting and Merge Operations ###########################################
# enable coverage merge
if($covmerge -eq $true){
    vcover merge *.ucdb $mergeFileName.ucdb
    # Generate coverage report in html format
    if($export_cov_report_html -eq $true) {
        vcover report -html -htmldir $htmlreportDir -verbose -threshL 50 -threshH 90 $mergeFileName.ucdb
    }
}
# Generate coverage report in html format for current test
elseif($export_cov_report_html -eq $true){
    vcover report -html -htmldir $htmlreportDir -verbose -threshL 50 -threshH 90 $testname.ucdb
}


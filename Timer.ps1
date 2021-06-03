# Simple PowerShell Timer
# Originally written by Ivy Slick (@queery420) 6/2/21
#
# Displays current time, end time, remaining time.
# Plays a sound and pushes a notification when the time is up.




#Parameters
param(
  [Parameter( Mandatory = $false,
              HelpMessage = "First timer")]
  [int]$timerA = 30,
  [Parameter( Mandatory = $false,
              HelpMessage = "Second timer")]
  [int]$timerB = 0,
  [Parameter( Mandatory = $false,
              HelpMessage = "Number of Cycles")]
  [int]$timerCycles = 1
)



# Windows 10 Notification support
import-module BurntToast



# IFTTT Notification support
# Code by Dennis Rye, May 12, 2019
# https://www.dennisrye.com/post/send-smartphone-notifications-powershell-ifttt/
function Send-IftttAppNotification {
    [cmdletbinding()]
    param(
        [Parameter(Mandatory)]
        [string]$EventName,

        [Parameter(Mandatory)]
        [string]$Key,

        # The length of the timer that just finished
        [string]$Value1,
        # Total time remaining
        [string]$Value2,
        # Unused
        [string]$Value3
    )

    $webhookUrl = "https://maker.ifttt.com/trigger/{0}/with/key/{1}" -f $EventName, $Key

    $body = @{
        value1 = $Value1
        value2 = $Value2
        value3 = $Value3
    }

    Invoke-RestMethod -Method Get -Uri $webhookUrl -Body $body
}
# Your Event Name
$YourEventName = "YOUR EVENT NAME HERE DELETE THIS OR THE SCRIPT WON'T WORK"
# Your Key from https://ifttt.com/maker_webhooks/settings
$YourKey = "YOUR KEY HERE PUT IT HERE DELETE THIS AND PUT IT IN OR THIS SCRIPT WON'T WORK"



# Initialize Variables
# ***Str is the version of the variable for concatinating

# startTime is the time the script is initialized
$startTime = $(get-date)
$startTimeStr = $startTime.ToShortTimeString()
# currentTime is the variable to be updated with the current time
$currentTime = $(get-date)
$currentTimeStr = $currentTime.ToShortTimeString()
# totalMinutes is a countdown to the end of all cycles
$totalMinutes = $TimerCycles * ($timerA + $timerB)
$totalMinutesStr = $totalMinutes
# endTime is when the final alarm will sound and the script will complete
$endTime = $(get-date).AddMinutes($totalMinutes)
$endTimeStr = $endTime.ToShortTimeString()
# current cycle
$cycles = 1



# Core Loop. Updates every 60 seconds.
clear-host
While ($cycles -le $timerCycles)
{

  # Timer A
  # minutesA is the local countdown for the first timerA
  $minutesA = $timerA
  # startTimeA is when the first time starts
  $startTimeA = $(get-date)
  $startTimeAStr = $startTimeA.ToShortTimeString()
  # endTimeA is when the first timer ends
  $endTimeA = $(get-date).AddMinutes($minutesA)
  $endTimeAStr = $endTimeA.ToShortTimeString()

  While ($currentTime -le $endTimeA)
  {

    # Displays all info
    write-host "     Timer Start:   $startTimeStr"
    write-host "     Timer End:     $endTimeStr"
    write-host ""
    write-host "     Cycle Start:   $startTimeAStr"
    write-host "     Cycle End:     $endTimeAStr"
    write-host ""
    write-host "     Now:           $currentTimeStr"
    if($minutesA -eq 1) {write-host "     1 minute remaining in this $timerA minute cycle."}
    else {write-host "     $minutesA minutes remaining in this $timerA minute cycle."}
    if($totalMinutes -eq 1) {write-host "     1 minute of $totalMinutesStr remaining overall."}
    else {write-host "     $totalMinutes of $totalMinutesStr minutes remaining overall."}

    # wait 1 minute
    Start-Sleep -s 60

    # Update currentTime and check to see if the timer is finished.
    $currentTime = $(get-date)
    $currentTimeStr = $currentTime.ToShortTimeString()
    $minutesA = $minutesA - 1
    $totalMinutes = $totalMinutes - 1
    clear-host

  }

  # Timer A alarm & push notifications
  write-host "     A $timerA minute timer has finished."
  New-BurntToastNotification -Text "PowerShell Timer", "Time's up!" -sound "Call3"
  # $shutup because if you leave it alone it outputs a statement.
  $shutup = Send-IftttAppNotification -EventName $YourEventName -Key $YourKey -Value1 $timerA -Value2 $totalMinutes



  # Timer B
  # minutesA is the local countdown for the first timerA
  $minutesB = $timerB
  # startTimeA is when the first time starts
  $startTimeB = $(get-date)
  $startTimeBStr = $startTimeB.ToShortTimeString()
  # endTimeB is when the first timer ends
  $endTimeB = $(get-date).AddMinutes($minutesB)
  $endTimeBStr = $endTimeB.ToShortTimeString()

  While ($currentTime -le $endTimeB)
  {

    # Displays all info
    write-host "     Timer Start:   $startTimeStr"
    write-host "     Timer End:     $endTimeStr"
    write-host ""
    write-host "     Cycle Start:   $startTimeBStr"
    write-host "     Cycle End:     $endTimeBStr"
    write-host ""
    write-host "     Now:           $currentTimeStr"
    if($minutesB -eq 1) {write-host "     1 minute remaining in this $timerB minute cycle."}
    else {write-host "     $minutesB minutes remaining in this $timerB minute cycle."}
    if($totalMinutes -eq 1) {write-host "     1 minute of $totalMinutesStr remaining overall."}
    else {write-host "     $totalMinutes of $totalMinutesStr minutes remaining overall."}

    # wait 1 minute
    Start-Sleep -s 60

    # Update currentTime and check to see if the timer is finished.
    $currentTime = $(get-date)
    $currentTimeStr = $currentTime.ToShortTimeString()
    $minutesB = $minutesB - 1
    $totalMinutes = $totalMinutes - 1
    clear-host

  }
  # Timer B alarm & push notifications. Does not execute for a 0 minute timer.
  if ($timerB -gt 0)
  {
    write-host "     A $timerB minute timer has finished."
    New-BurntToastNotification -Text "PowerShell Timer", "Time's up!" -sound "Call3"
    # $shutup because if you leave it alone it outputs a statement.
    $shutup = Send-IftttAppNotification -EventName $YourEventName -Key $YourKey -Value1 $timerB -Value2 $totalMinutes
  }


  # Update Cycles
  $cycles = $cycles + 1
  write-host "     $cycles cycle(s) out of $timerCycles have completed."

}

# Final time announcement
write-host "     Time's up! All Cycles completed."
write-host "     The time is now $currentTimeStr."

# Simple PowerShell Timer
# Originally written by Ivy Slick (@queery420) 6/2/21
# Adapted from @avredd's sitstand.sh
#
# Displays current time, end time, remaining time.
# Plays a sound and pushes a notification when the time is up.




# Parameters
param(
  # Length in minutes of the first timer, 30 minutes by default.
  [Parameter( Mandatory = $false,
              HelpMessage = "First timer")]
  [int]$timerA = 30,
  # Length in minutes of the second timer, turned off (0 minutes) by default
  [Parameter( Mandatory = $false,
              HelpMessage = "Second timer")]
  [int]$timerB = 0,
  # Number of times you wish the timer(s) to repeat, no repetition by default
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

        # A String stating your timer has finished
        [string]$Value1,
        # The length of the timer that just finished
        [string]$Value2,
        # Total time remaining across all cycles
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
# IFTTT INTEGRATION VARIABLES
# These must be set in order to use the optional IFTTT feature
# IFTTT integration flag. Set to $true in order to enable the integration
$IFTTT = $false
# Your Event Name
$YourEventName = "PUT YOUR EVENT NAME HERE AND DELETE THIS OR THE SCRIPT WON'T WORK"
# Your Key from https://ifttt.com/maker_webhooks/settings
$YourKey = "PUT YOUR KEY HERE AND DELETE THIS OR THIS SCRIPT WON'T WORK"
$IFTTTmsg = "Your timer has finished!"



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
$cycle = 1



# Core Loop. Updates every 60 seconds.
clear-host
While ($cycle -le $timerCycles)
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
  # endTimeB is when the second timer ends
  $endMinutes = $timerA + $timerB
  $endTimeB = $(get-date).AddMinutes($endMinutes)
  $endTimeBStr = $endTimeB.ToShortTimeString()
  if($endMinutes -gt 60)
  {
    $eM = $endMinutes
    $eM = [timeSpan]::fromminutes($eM)
    $eM = $eM.ToString("hh\:mm")
  }
  else {$eM = "$endMinutes minutes"}

  While ($currentTime -le $endTimeA)
  {

    # Overall time display
    write-host "     ::OVERALL::"
    write-host "     Overall Start:   $startTimeStr"
    write-host "     Overall End:     $endTimeStr"
    # Formats total times over 1 hour
    # tM = string for Total Minutes
    $tM = $totalMinutes
    if($totalMinutes -gt 60)
    {
      $tM = [timeSpan]::fromminutes($totalMinutes)
      $tM = $tM.ToString("hh\:mm")
    }
    elseif ($totalMinutesStr -gt 60) {$tM = "$totalMinutes minutes"}
    # tMs = string for totalMinutesStr. Why yes, I am aware of that thing, thank you.
    $tMs = "$totalMinutesStr minutes"
    if($totalMinutesStr -gt 60)
    {
      $tMs = [timeSpan]::fromminutes($totalMinutesStr)
      $tMs = $tMs.ToString("hh\:mm")
    }
    #Totals Summary
    # Displays 1 minute remaining at 1 minute; otherwise displays "minutes"
    if($totalMinutes -eq 1) {write-host "     1 minute of $tMs remaining overall."}
    else {write-host "     $tM of $tMs remaining overall."}
    write-host ""

    # Cycle Display (only if timerB is on)
    if ($timerB -ge 1)
    {
      $cycleTime = $minutesA + $timerB
      if($cycleTime -gt 60)
      {
        $cycleTime = [timeSpan]::fromminutes($cycleTime)
        $cycleTime = $cycleTime.ToString("hh\:mm")
      }
      elseif ($endMinutes -gt 60)
      {$cycleTime = "$cycleTime minutes"}

      write-host "     ::CYCLE::"
      write-host "     Cycle $cycle of $timerCycles"
      write-host "     Cycle Start:     $startTimeAStr"
      write-host "     Cycle End:       $endTimeBStr"
      write-host "     $cycleTime of $eM remaining this cycle."
      write-host ""
    }

    # Timer display
    # Formatting for times over 60 minutes
    if($minutesA -gt 60)
    {
      $mA = [timeSpan]::fromminutes($minutesA)
      $mA = $mA.ToString("hh\:mm")
    }
    else {$mA = "$minutesA"}

    if($timerA -gt 60)
    {
      if($minutesA -le 60) {$mA = "$minutesA minutes"}
      $tA = [timeSpan]::fromminutes($timerA)
      $tA = $tA.ToString("hh\:mm")
    }
    elseif ($timerA -eq 1) {$tA = "1 minute"}
    else {$tA = "$timerA minutes"}

    write-host "     ::TIMER::"
    write-host "     Timer Start:     $startTimeAStr"
    write-host "     Timer End:       $endTimeAStr"
    write-host "     $mA of $tA remaining this timer."
    write-host ""
    write-host "     Now:             $currentTimeStr"


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
  #IFTTT notification
  if ($IFTTT)
  {
    # $shutup because if you leave it alone it outputs a statement.
    $shutup = Send-IftttAppNotification -EventName $YourEventName -Key $YourKey  -Value1 $IFTTTmsg -Value2 $timerA -Value3 $totalMinutes
  }

  # Timer B
  # minutesB is the local countdown for the second timer, timerB
  $minutesB = $timerB
  # startTimeB is when the second timer starts
  $startTimeB = $(get-date)
  $startTimeBStr = $startTimeB.ToShortTimeString()
  # endTimeB is when the second timer ends
  $endTimeB = $(get-date).AddMinutes($minutesB)
  $endTimeBStr = $endTimeB.ToShortTimeString()

  While ($currentTime -le $endTimeB)
  {

    # Overall time display
    write-host "     ::OVERALL::"
    write-host "     Overall Start:   $startTimeStr"
    write-host "     Overall End:     $endTimeStr"
    # Formats total times over 1 hour
    # tM = string for Total Minutes
    $tM = $totalMinutes
    if($totalMinutes -gt 60)
    {
      $tM = [timeSpan]::fromminutes($totalMinutes)
      $tM = $tM.ToString("hh\:mm")
    }
    elseif ($totalMinutesStr -gt 60) {$tM = "$totalMinutes minutes"}
    # tMs = string for totalMinutesStr. Why yes, I am aware of that thing, thank you.
    $tMs = "$totalMinutesStr minutes"
    if($totalMinutesStr -gt 60)
    {
      $tMs = [timeSpan]::fromminutes($totalMinutesStr)
      $tMs = $tMs.ToString("hh\:mm")
    }
    #Totals Summary
    # Displays 1 minute remaining at 1 minute; otherwise displays "minutes"
    if($totalMinutes -eq 1) {write-host "     1 minute of $tMs remaining overall."}
    else {write-host "     $tM of $tMs remaining overall."}
    write-host ""

    # Cycle Display
    $cycleTime = $minutesB
    if($minutesB -gt 60)
    {
      $cycleTime = [timeSpan]::fromminutes($minutesB)
      $cycleTime = $cycleTime.ToString("hh\:mm")
    }
    else {$cycleTime = "$cycleTime minutes"}

    write-host "     ::CYCLE::"
    write-host "     Cycle $cycle of $timerCycles"
    write-host "     Cycle Start:     $startTimeAStr"
    write-host "     Cycle End:       $endTimeBStr"
    write-host "     $cycleTime of $eM remaining this cycle."
    write-host ""

    # Timer Display
    # Formatting for times over 60 minutes
    if($minutesB -gt 60)
    {
      $mB = [timeSpan]::fromminutes($minutesB)
      $mB = $mB.ToString("hh\:mm")
    }
    else {$mB = "$minutesB"}

    if($timerB -gt 60)
    {
      if($minutesB -le 60) {$mB = "$minutesB minutes"}
      $tB = [timeSpan]::fromminutes($timerB)
      $tB = $tB.ToString("hh\:mm")
    }
    elseif ($timerB -eq 1) {$tB = "1 minute"}
    else {$tB = "$timerB minutes"}

    write-host "     ::TIMER::"
    write-host "     Timer Start:     $startTimeBStr"
    write-host "     Timer End:       $endTimeBStr"
    write-host "     $mB of $tB remaining this timer."
    write-host ""
    write-host "     Now:             $currentTimeStr"

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
    #IFTTT notification
    if ($IFTTT)
    {
      # $shutup because if you leave it alone it outputs a statement.
      $shutup = Send-IftttAppNotification -EventName $YourEventName -Key $YourKey -Value1 $IFTTTmsg -Value2 $timerB -Value3 $totalMinutes
    }
  }


  # Update Cycles
  write-host "     $cycle cycle(s) out of $timerCycles have completed."
  $cycle = $cycle + 1
}

# Final time announcement
write-host "     Time's up! All Cycles completed at $currentTimeStr."

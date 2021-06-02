# Simple PowerShell Timer
#
# Displays current time, end time, remaining time.
# Plays a sound and pushes a notification when the time is up.

# Windows 10 Notification support
Import-Module BurntToast

# startTime is the time the script is initialized
$startTime = $(get-date)
$startTimeStr = $startTime.ToShortTimeString()
# currentTime is the variable to be updated with the current time
$currentTime = $(get-date)
$currentTimeStr = $currentTime.ToShortTimeString()
# endTime is when the timer will sound, 30 minutes by default
$minutes = 30
$endTime = $(get-date).AddMinutes($minutes)
$endTimeStr = $endTime.ToShortTimeString()


# Core Loop. Updates every 60 seconds,
While ($currentTime -le $endTime)
{
  # Displays start time, end time, current time, remaining minutes
  clear-host
  write-host "     Start:   $startTimeStr"
  write-host "     End:     $endTimeStr"
  write-host "     Now:     $currentTimeStr"
  if($minutes -eq 1)
  {
    write-host "     1 minute remaining."
  }
  else
  {
    write-host "     $minutes minutes remaining."
  }

  # wait 1 minute
  Start-Sleep -s 60

  # Update currentTime and check to see if the timer is finished.
  $currentTime = $(get-date)
  $currentTimeStr = $currentTime.ToShortTimeString()
  $minutes = $minutes - 1
}

# Final time announcement, push notification
clear-host
write-host "The time is now $currentTimeStr."
New-BurntToastNotification -Text "PowerShell Timer","The time is now $currentTimeStr."

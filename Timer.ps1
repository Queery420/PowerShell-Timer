# Simple PowerShell Timer
#
# Displays current time, end time, remaining time.
# Plays a sound and pushes a notification when the time is up.

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

While ($currentTime -le $endTime)
{
  # Displays current time, makes a joke, tells you the rest of it idk
  clear-host
  write-host "The time is now $currentTimeStr"
  write-host "This timer was started at $startTimeStr"
  write-host "The timer will ring at $endTimeStr, which will signal the endTime."
  write-host "You have $minutes minutes remaining to make your peace."

  Start-Sleep -s 60

  # Update currentTime and check to see if the timer is finished.
  $currentTime = $(get-date)
  $currentTimeStr = $currentTime.ToShortTimeString()
  $minutes = $minutes - 1
}

clear-host
write-host "The time is now $currentTimeStr. You have lived to see it through once more."

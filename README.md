# PowerShell-Timer v0.3
A simple timer for Windows PowerShell by @queery420

Requires PowerShell and BurntToast (see below)

Parameters:

> **-timerA**: Defaults to 30 minutes. This is the first timer of the two in a cycle.
>
> **-timerB**: Defaults to 0 minutes. This is the second timer of the two in a cycle.
>
> **-timerCycles**: Defaults to 1 cycle. Number of times the timers are repeated.

To run PowerShell-Timer with its default parameters (one 30-minute timer), simply run
```PowerShell
.\Timer.ps1
```
You may also customize any of the Parameters like so:
```PowerShell
.\Timer.ps1 -timerA 60 -timerB 30 -timerCycles 3 
```
The output should look like this:
```
     Timer Start:   9:57 PM
     Timer End:     2:27 AM
     
     Cycle Start:   9:57 PM
     Cycle End:     10:57 PM
     
     Now:           9:57 PM
     60 minutes remaining in this 60 minute cycle.
     270 of 270 minutes remaining overall.
```


## v0.3 Notes
- Timer works in-terminal.
- Default time is 30 minutes for the first timer, 0 for the second, for 1 cycle (30 minutes total).
- IFTTT Integration is on by default - you must comment out the code yourself (lines 134 & 182) or enter your own Webhook info into lines 61 & 63. Otherwise it'll throw errors at you when it's notification time one way or the other (see IFTTT Support below for more information).
- No system sound support.

## v0.2 -> v0.3 Changelog
- Added IFTTT integration (see below)
- Added parameters with default values
- Added Alternating Timers with cycles

## v0.1 -> v0.2 Changelog
- Added notification support via BurntToast (see below)
- Cleaned up diction and formatted displayed information
- minor logic changes to the main loop (support for 1 min case)


## BurntToast
PowerShell-Timer requires the BurntToast module (https://github.com/Windos/BurntToast) to be installed. Enter the following line into PowerShell, say 'Yes,' and you're good to go.

```PowerShell
  Install-Module -Name BurntToast
```


## IFTTT Support
PowerShell-Timer comes with IFTTT WebHook Support. To use this support, you will need to set up a custom WebHook on IFTTT.
When making your Event, the parameters used are only EventName, Value1 (length of the timer that just finished), and Value2 (total time remaining); Value3 is unused.

Example of my notification message from IFTTT
```
{{EventName}}
A {{Value1}} minute timer is now complete at {{OccurredAt}}.
{{Value2}} minutes remain overall.
```

To enable IFTTT support, your Event Name will need to be entered into line 61...
```ps1
$YourEventName = "YOUR EVENT NAME HERE DELETE THIS OR THE SCRIPT WON'T WORK"
```
...and your webhook key (From https://ifttt.com/maker_webhooks/settings) will need to be entered into line 63
```ps1
$YourKey = "YOUR KEY HERE PUT IT HERE DELETE THIS AND PUT IT IN OR THIS SCRIPT WON'T WORK"
```
Alternatively, if you do not wish to use the WebHook integration, simply comment out lines 134 and 182, as below.
> Before:
```ps1
  $shutup = Send-IftttAppNotification -EventName $YourEventName -Key $YourKey -Value1 $timerA -Value2 $totalMinutes
```
```ps1
  $shutup = Send-IftttAppNotification -EventName $YourEventName -Key $YourKey -Value1 $timerB -Value2 $totalMinutes
```
> After:
```ps1
#  $shutup = Send-IftttAppNotification -EventName $YourEventName -Key $YourKey -Value1 $timerA -Value2 $totalMinutes
```
```ps1
#  $shutup = Send-IftttAppNotification -EventName $YourEventName -Key $YourKey -Value1 $timerB -Value2 $totalMinutes
```

## Development Goals
- convert totalMinutes and totalMinutesStr to Hours & Minutes format from Minutes (int) format in output (i.e. 270 minutes to 4 hours 30 minutes)
- Make Custom Notification Sounds Work God Damn It
- Flexible cycles: Number of Timers parameter, array of times, modify timer loop to handle variable time
- verify attribution conventions; update as necessary
- expand documentation (comment everything)
- set IFTTT integration to fully off by default (add comment signs to lines 34 and 182)
- demonstrate value to self; grow as a person by typing words in pretty colors for 8 hours straight

# PowerShell-Timer v0.4
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
The output should look like this:
```
     ::OVERALL::
     Overall Start:   4:37 PM
     Overall End:     5:07 PM
     30 of 30 minutes remaining overall.

     ::TIMER::
     Timer Start:     4:37 PM
     Timer End:       5:07 PM
     30 of 30 minutes remaining this timer.

     Now:             4:37 PM
```

You may also customize any of the Parameters like so:
```PowerShell
.\Timer.ps1 -timerA 60 -timerB 30 -timerCycles 3 
```
The output should look like this:
```
     ::OVERALL::
     Overall Start:   3:37 PM
     Overall End:     8:07 PM
     04:30 of 04:30 remaining overall.

     ::CYCLE::
     Cycle 1 of 3
     Cycle Start:     3:37 PM
     Cycle End:       5:07 PM
     01:30 of 01:30 remaining this cycle.

     ::TIMER::
     Timer Start:     3:37 PM
     Timer End:       4:37 PM
     60 of 60 minutes remaining this timer.

     Now:             3:37 PM
```
Another example:
```PowerShell
.\Timer.ps1 -timerA 3 -timerB 2 -timerCycles 2
```
Which outputs:
```
     ::OVERALL::
     Overall Start:   3:32 PM
     Overall End:     3:42 PM
     10 of 10 minutes remaining overall.

     ::CYCLE::
     Cycle 1 of 2
     Cycle Start:     3:32 PM
     Cycle End:       3:37 PM
     5 of 5 minutes remaining this cycle.

     ::TIMER::
     Timer Start:     3:32 PM
     Timer End:       3:35 PM
     3 of 3 minutes remaining this timer.

     Now:             3:32 PM
```

Exit the script at any time with ctrl + c.


## v0.4 Notes
- Timer works in-terminal.
- Default time is 30 minutes for the first timer, 0 for the second, for 1 cycle (30 minutes total).
- IFTTT Integration is off by default - you must change a boolean variable as well as entering your EventName and Key (see IFTTT Support below for more information).
- No system sound support.

## v0.3 -> v0.4 Changelog
- Changed IFTTT integration (see below for new procedures)
  - Integration is now off by default
  - Set integration flag, removed old "comment" system of integration
  - Added a String for the Value1
  - Changed old Value2 -> Value3, old Value1 -> Value2
- Added more comments
- Improved output format.

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
PowerShell-Timer comes with IFTTT WebHook Support via a code snippet from Dennis Rye (see code for attribution). To use this support, you will need to set up a custom WebHook event on IFTTT.
When making your Event, the parameters used are EventName, Value1 (string: "Your timer has finished!"), Value2 (length of the timer that just finished), and Value3 (total time remaining).

Example of my notification message from IFTTT
```
{{EventName}}
{{Value1}}
The {{Value2}} minute timer completed at {{OccurredAt}}.
{{Value3}} minutes remain overall.
```

To enable IFTTT support, first change $IFTTT to $true in line 67, as below:
> Before:
```ps1
$IFTTT = $false
```
> After:
```
$IFTTT = $true
```
You must also enter your Event Name into line 69...
```ps1
$YourEventName = "PUT YOUR EVENT NAME HERE AND DELETE THIS OR THE SCRIPT WON'T WORK"
```
...and your webhook key (From https://ifttt.com/maker_webhooks/settings) will need to be entered into line 71.
```ps1
$YourKey = "PUT YOUR KEY HERE AND DELETE THIS OR THIS SCRIPT WON'T WORK"
```


## Development Goals
- v0.5 will be one nested loop that can alternate the cycle it processes as opposed to two loops in serial inside a loop
- Final release when I figure out sound on Toast notifications.
- demonstrate value to self; grow as a person by typing words in pretty colors for 8 hours straight

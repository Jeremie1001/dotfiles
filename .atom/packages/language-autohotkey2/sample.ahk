/*******************************************************************************
*  language-autohotkey
*
*  This is an example of an autohotkey file with syntax-highlighting via
*  the language-autohotkey package.  The themes shown below are neon-syntax
*  and steam-pirate-ui, with default settings.
*******************************************************************************/

; Directives
#SingleInstance force

; Commands & Control flow
While 1 < 2
{
  FileRead content, forever.txt
  Sleep, 1000
  Progress, Off
}

; Operators & literals
anInteger := 3
aFloat :=3.14
aString = "Three point one four"

; Functions
Add(x, y)
{
  aLog("the numbers are being added")
  return x + y
}

; Constants & built-in variables
version = %A_AhkVersion%
Send, {Space}

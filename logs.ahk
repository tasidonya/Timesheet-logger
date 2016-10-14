;AltGr + v
<^>!v:: 

FileRead , data_from_notepad , redmines.txt  ;  Reads redmines.txt into a variable
 
Loop , parse , data_from_notepad , `n  ;  Use a parse loop to add in the necessary delimiter used by comboboxes.
 combo_items := combo_items . "|" . A_LoopField 
 
StringReplace , combo_items , combo_items , `r , , All  ;  remove the returns so we have a single line.

; Make sure there is no global variable conflict if this 
; is called more than once
Gui Destroy 

startOrFinish := "" 

; Display gui with a field and 2 radio buttons 
; and an ok/cancel button
Gui, Add, Text,, Enter task Redmine:
Gui , Add , Combobox , vMyRedMine, %combo_items%
Gui, Add, Radio, gsetStart, Start
Gui, Add, Radio, gsetFinish, Finish
Gui, Add, Button, vMyOkButton x10 y90 gWriteRequiredTask, Ok
Gui, Add, Button, vMyCancelButton x40 y90 ghideWin, Cancel
Gui, Show, w150 h130, Log time

return ; Keyboard shortcut binding finishes


; Helper methods/functions
hideWin:
   Gui Cancel

setStart:
   startOrFinish := "Start"
   return

setFinish:
   startOrFinish := "Finish"
   return

WriteRequiredTask:
   startTime := A_Now
   GuiControlGet, MyRedmine
   aspace := " "
   writeThis := MyRedmine aspace startOrFinish aspace DateReadable(startTime)
   MsgBox %writeThis%
   writeLine(writeThis)
   return

writeLine(line) {
   FileAppend,
   (
   %line%

   ), timesheets.txt
}

DateReadable(datetimestr){
   FormatTime, TimeString, %datetimestr%, HH:mm:ss d/MM/yyyy
   return TimeString 
}

; From: https://github.com/polyethene/AutoHotkey-Scripts/blob/master/DateParse.ahk
; Convert back to YYYYMMDDHH24MISS
DateParse(str) {
   static e2 = "i)(?:(\d{1,2}+)[\s\.\-\/,]+)?(\d{1,2}|(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\w*)[\s\.\-\/,]+(\d{2,4})"
   str := RegExReplace(str, "((?:" . SubStr(e2, 42, 47) . ")\w*)(\s*)(\d{1,2})\b", "$3$2$1", "", 1)
   If RegExMatch(str, "i)^\s*(?:(\d{4})([\s\-:\/])(\d{1,2})\2(\d{1,2}))?"
      . "(?:\s*[T\s](\d{1,2})([\s\-:\/])(\d{1,2})(?:\6(\d{1,2})\s*(?:(Z)|(\+|\-)?"
      . "(\d{1,2})\6(\d{1,2})(?:\6(\d{1,2}))?)?)?)?\s*$", i)
      d3 := i1, d2 := i3, d1 := i4, t1 := i5, t2 := i7, t3 := i8
   Else If !RegExMatch(str, "^\W*(\d{1,2}+)(\d{2})\W*$", t)
      RegExMatch(str, "i)(\d{1,2})\s*:\s*(\d{1,2})(?:\s*(\d{1,2}))?(?:\s*([ap]m))?", t)
         , RegExMatch(str, e2, d)
   f = %A_FormatFloat%
   SetFormat, Float, 02.0
   d := (d3 ? (StrLen(d3) = 2 ? 20 : "") . d3 : A_YYYY)
      . ((d2 := d2 + 0 ? d2 : (InStr(e2, SubStr(d2, 1, 3)) - 40) // 4 + 1.0) > 0
         ? d2 + 0.0 : A_MM) . ((d1 += 0.0) ? d1 : A_DD) . t1
         + (t1 = 12 ? t4 = "am" ? -12.0 : 0.0 : t4 = "am" ? 0.0 : 12.0) . t2 + 0.0 . t3 + 0.0
   SetFormat, Float, %f%
   Return, d
}
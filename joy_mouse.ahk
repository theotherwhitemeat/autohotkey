; Using a Joystick as a Mouse
; http://www.autohotkey.com
; This script converts a joystick into a three-button mouse.  It allows each
; button to drag just like a mouse button and it uses virtually no CPU time.
; Also, it will move the cursor faster depending on how far you push the joystick
; from center. You can personalize various settings at the top of the script.

; Increase the following value to make the mouse cursor move faster:
JoyMultiplier = 5

; Decrease the following value to require less joystick displacement-from-center
; to start moving the mouse.  However, you may need to calibrate your joystick
; -- ensuring it's properly centered -- to avoid cursor drift. A perfectly tight
; and centered joystick could use a value of 1:
JoyThreshold = 3

; Change the following to true to invert the Y-axis, which causes the mouse to
; move vertically in the direction opposite the stick:
InvertYAxis := true

; Change these values to use joystick button numbers other than 1, 2, and 3 for
; the left, right, and middle mouse buttons.  Available numbers are 1 through 32.
; Use the Joystick Test Script to find out your joystick's numbers more easily.
ButtonLeft = 5

; If your joystick has a POV control, you can use it as a mouse wheel.  The
; following value is the number of milliseconds between turns of the wheel.
; Decrease it to have the wheel turn faster:
WheelDelay = 250

; If your system has more than one joystick, increase this value to use a joystick
; other than the first:
JoystickNumber = 1

; END OF CONFIG SECTION -- Don't change anything below this point unless you want
; to alter the basic nature of the script.

#SingleInstance

JoystickPrefix = %JoystickNumber%Joy
Hotkey, %JoystickPrefix%%ButtonLeft%, ButtonLeft

; Calculate the axis displacements that are needed to start moving the cursor:
JoyThresholdUpper := 50 + JoyThreshold
JoyThresholdLower := 50 - JoyThreshold
if InvertYAxis
	YAxisMultiplier = -1
else
	YAxisMultiplier = 1

SetTimer, WatchJoystick, 10  ; Monitor the movement of the joystick.

GetKeyState, JoyInfo, %JoystickNumber%JoyInfo
;IfInString, JoyInfo, P  ; Joystick has POV control, so use it as a mouse wheel.
;	SetTimer, MouseWheel, %WheelDelay%

return  ; End of auto-execute section.



Joy8::
Send {PgUp down}
SetTimer, WaitForButtonUp8, 10
return

WaitForButtonUp8:
if GetKeyState("Joy8")  ; The button is still, down, so keep waiting.
    return
; Otherwise, the button has been released.
Send {PgUp up}
SetTimer, WaitForButtonUp8, Off
return

Joy4::
Send {PgDn down}
SetTimer, WaitForButtonUp4, 10
return

WaitForButtonUp4:
if GetKeyState("Joy4")  ; The button is still, down, so keep waiting.
    return
; Otherwise, the button has been released.
Send {PgDn up}
SetTimer, WaitForButtonUp4, Off
return

Joy3::
Send {Tab down}
SetTimer, WaitForButtonUp3, 10
return

WaitForButtonUp3:
if GetKeyState("Joy3")  ; The button is still, down, so keep waiting.
    return
; Otherwise, the button has been released.
Send {Tab up}
SetTimer, WaitForButtonUp3, Off
return

Joy1::
Send {Control down}
SetTimer, WaitForButtonUp1, 10
return

WaitForButtonUp1:
if GetKeyState("Joy1")  ; The button is still, down, so keep waiting.
    return
; Otherwise, the button has been released.
Send {Control up}
SetTimer, WaitForButtonUp1, Off
return

Joy2::
Send {Alt down}
SetTimer, WaitForButtonUp2, 10
return

WaitForButtonUp2:
if GetKeyState("Joy2")  ; The button is still, down, so keep waiting.
    return
; Otherwise, the button has been released.
Send {Alt up}
SetTimer, WaitForButtonUp2, Off
return

Joy7::
Send {Shift down}
SetTimer, WaitForButtonUp7, 10
return

WaitForButtonUp7:
if GetKeyState("Joy7")  ; The button is still, down, so keep waiting.
    return
; Otherwise, the button has been released.
Send {Shift up}
SetTimer, WaitForButtonUp7, Off
return



; The subroutines below do not use KeyWait because that would sometimes trap the
; WatchJoystick quasi-thread beneath the wait-for-button-up thread, which would
; effectively prevent mouse-dragging with the joystick.

ButtonLeft:
SetMouseDelay, -1  ; Makes movement smoother.
MouseClick, left,,, 1, 0, D  ; Hold down the left mouse button.
SetTimer, WaitForLeftButtonUp, 10
return

WaitForLeftButtonUp:
if GetKeyState(JoystickPrefix . ButtonLeft)
	return  ; The button is still, down, so keep waiting.
; Otherwise, the button has been released.
SetTimer, WaitForLeftButtonUp, Off
SetMouseDelay, -1  ; Makes movement smoother.
MouseClick, left,,, 1, 0, U  ; Release the mouse button.
return

;WatchJoystick:
;MouseNeedsToBeMoved := false  ; Set default.
;SetFormat, float, 03
;GetKeyState, JoyX, %JoystickNumber%JoyX
;GetKeyState, JoyY, %JoystickNumber%JoyY
;if JoyX > %JoyThresholdUpper%
;{
;	MouseNeedsToBeMoved := true
;	DeltaX := JoyX - JoyThresholdUpper
;}
;else if JoyX < %JoyThresholdLower%
;{
;	MouseNeedsToBeMoved := true
;	DeltaX := JoyX - JoyThresholdLower
;}
;else
;	DeltaX = 0
;if JoyY > %JoyThresholdUpper%
;{
;	MouseNeedsToBeMoved := true
;	DeltaY := JoyY - JoyThresholdUpper
;}
;else if JoyY < %JoyThresholdLower%
;{
;	MouseNeedsToBeMoved := true
;	DeltaY := JoyY - JoyThresholdLower
;}
;else
;	DeltaY = 0
;if MouseNeedsToBeMoved
;{
;	SetMouseDelay, -1  ; Makes movement smoother.
;	MouseMove, DeltaX * JoyMultiplier, DeltaY * JoyMultiplier * YAxisMultiplier, 0, R
;}
;return

WatchJoystick:
GetKeyState, JoyPOV, %JoystickNumber%JoyPOV
if JoyPOV = -1  ; No angle.
	return
;; x
DeltaX := 0
DeltaY := 0
if (JoyPOV == 4500 or JoyPOV == 13500)
	DeltaX := JoyMultiplier
if (JoyPOV == 22500 or JoyPOV == 31500)
	DeltaX := -JoyMultiplier
if (JoyPOV == 9000)
	DeltaX := JoyMultiplier*2
if (JoyPOV == 27000)
	DeltaX := -JoyMultiplier*2
;; y
if (JoyPOV == 4500 or JoyPOV == 31500)
	DeltaY := JoyMultiplier
if (JoyPOV == 22500 or JoyPOV == 13500)
	DeltaY := -JoyMultiplier
if (JoyPOV == 0)
	DeltaY := JoyMultiplier*2
if (JoyPOV == 18000)
	DeltaY := -JoyMultiplier*2

;SetMouseDelay, -1  ; Makes movement smoother.
MouseMove, DeltaX, DeltaY * YAxisMultiplier, 0, R

; POVs possible:
; 0
; 4500
; 9000
; 13500
; 18000
; 22500
; 27000
; 31500

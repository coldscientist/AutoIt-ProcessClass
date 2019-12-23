#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         Eduardo Mozart de Oliveira

 Script Function:
	Now making Window name and executables/PIDs interchangable!.
	Credit to Cynagen
	https://www.autoitscript.com/forum/topic/95328-window-title-process-nameid/

#ce ----------------------------------------------------------------------------
; _ProcessGetName
#include <Process.au3>
; _WinAPI_GetParent
#include <WinAPIEx.au3>
; _ArrayAdd
#include <Array.au3>
; _WinAPI_ProcessGetPathname
#include "Includes\_WinAPI_ProcessGetPathname.au3"

Func _Win2Process($sWinTitle)
    If Not IsString($sWinTitle) Then Return -1
    $sWProc = WinGetProcess($sWinTitle)
    Return _ProcessGetName($sWProc)
 endfunc

Func _Process2Win($PID, $iTimeOutSecs = 8)
   ; ConsoleWrite("_Process2Win(" & $PID & ", " & $iTimeOutSecs & ")" & @CRLF)
   If IsString($PID) Then $PID = ProcessExists($PID)
   If $PID = 0 Then Return -1
   Local $iSecs = 0
   While 1
		Local $aWinMatch[1][4]
		$aWinMatch[0][0] = 0
		Local $aWinNotMatch[0][4]
		; $aWinNotMatch[0][0] = 0

		; Retrieve a list of window handles.
		Local $aWinList = WinList()

		; Run through GUIs to find those associated with the process
		For $i = 1 To $aWinList[0][0]
			; Loop through the array displaying only visible windows with a title.
			If $aWinList[$i][0] <> "" AND BitAnd(WinGetState($aWinList[$i][1]),2) Then
				; _WinListDebug($aWinList, $i)
				Local $iWPID = WinGetProcess($aWinList[$i][1])
				; ConsoleWrite("If " & $iWPID & " = " & $PID & " And (Not " & _WinAPI_GetParent($aWinList[$i][1]) & ") Then" & @CRLF & @CRLF)
				If $iWPID = $PID And (Not _WinAPI_GetParent($aWinList[$i][1])) Then
					; Return $aWinList[$i][1]
					$aWinMatch[0][0] = $aWinMatch[0][0] + 1
					ReDim $aWinMatch[UBound($aWinMatch) + 1][4]
					$aWinMatch[UBound($aWinMatch) - 1][0] = $aWinList[$i][0] ; Win Title
					$aWinMatch[UBound($aWinMatch) - 1][1] = $aWinList[$i][1] ; Win hWnd
					$aWinMatch[UBound($aWinMatch) - 1][2] = WinGetProcess($aWinList[$i][1]) ; Win Process ID (PID)
					$aWinMatch[UBound($aWinMatch) - 1][3] = _WinAPI_GetParent ( $aWinList[$i][1] ) ; Parent Win hWnd
				Else
					; $aWinNotMatch[0][0] = $aWinNotMatch[0][0] + 1
					ReDim $aWinNotMatch[UBound($aWinNotMatch) + 1][4]
					$aWinNotMatch[UBound($aWinNotMatch) - 1][0] = $aWinList[$i][0] ; Win Title
					$aWinNotMatch[UBound($aWinNotMatch) - 1][1] = $aWinList[$i][1] ; Win hWnd
					$aWinNotMatch[UBound($aWinNotMatch) - 1][2] = WinGetProcess($aWinList[$i][1]) ; Win Process ID (PID)
					$aWinNotMatch[UBound($aWinNotMatch) - 1][3] = _WinAPI_GetParent ( $aWinList[$i][1] ) ; Parent Win hWnd
				EndIf
			EndIf
		Next

		If $aWinMatch[0][0] > 0 Then
			ExitLoop
		Else
			Sleep(1000)
			$iSecs += 1
		EndIf

		; Timeout
		If $iTimeOutSecs > 0 And $iSecs = $iTimeOutSecs Then ExitLoop
	WEnd

	_ArrayConcatenate($aWinMatch, $aWinNotMatch)
	Return $aWinMatch
EndFunc

; https://www.autoitscript.com/forum/topic/44440-function-time-limits/
Func _WinChildDialogs($hWnd, $iTimeOutSecs = 8)
   ; ConsoleWrite("_WaitChildDialog(" & $hWnd & ", " & $iTimeOutSecs & ")" & @CRLF)
   Local $iSecs = 0
   While 1
	  Local $aWinMatch[1][4]
	  $aWinMatch[0][0] = 0
	  Local $aWinNotMatch[0][4]
	  ; $aWinNotMatch[0][0] = 0

	  ; Retrieve a list of window handles.
	  Local $aWinList = WinList()

	  ; Run through GUIs to find those associated with the process
	  For $i = 1 To $aWinList[0][0]
		 ; Loop through the array displaying only visible windows with a title.
		 If $aWinList[$i][0] <> "" And BitAND(WinGetState($aWinList[$i][1]), 2) Then
			; _WinListDebug($aWinList, $i)

			; ConsoleWrite("If " & _WinAPI_GetParent ( $aWinList[$i][1] ) & " = " & $hWnd & " Or (" & $aWinList[$i][1] & " <> " & $hWnd & " And " & WinGetProcess($aWinList[$i][1]) & " = " & WinGetProcess($hWnd) & ") Then" & @CRLF & @CRLF)
			If _WinAPI_GetParent ( $aWinList[$i][1] ) = $hWnd Or ($aWinList[$i][1] <> $hWnd And WinGetProcess($aWinList[$i][1]) = WinGetProcess($hWnd)) Then
				; https://www.autoitscript.com/forum/topic/97272-_arrayadd-to-multi-dimensional-array/
				$aWinMatch[0][0] = $aWinMatch[0][0] + 1
				ReDim $aWinMatch[UBound($aWinMatch) + 1][4]
				$aWinMatch[UBound($aWinMatch) - 1][0] = $aWinList[$i][0] ; Win Title
				$aWinMatch[UBound($aWinMatch) - 1][1] = $aWinList[$i][1] ; Win hWnd
				$aWinMatch[UBound($aWinMatch) - 1][2] = WinGetProcess($aWinList[$i][1]) ; Win Process ID (PID)
				$aWinMatch[UBound($aWinMatch) - 1][3] = _WinAPI_GetParent ( $aWinList[$i][1] ) ; Parent Win hWnd
		   Else
				; $aWinNotMatch[0][0] = $aWinNotMatch[0][0] + 1
				ReDim $aWinNotMatch[UBound($aWinNotMatch) + 1][4]
				$aWinNotMatch[UBound($aWinNotMatch) - 1][0] = $aWinList[$i][0] ; Win Title
				$aWinNotMatch[UBound($aWinNotMatch) - 1][1] = $aWinList[$i][1] ; Win hWnd
				$aWinNotMatch[UBound($aWinNotMatch) - 1][2] = WinGetProcess($aWinList[$i][1]) ; Win Process ID (PID)
				$aWinNotMatch[UBound($aWinNotMatch) - 1][3] = _WinAPI_GetParent ( $aWinList[$i][1] ) ; Parent Win hWnd
			EndIf
		 EndIf
	 Next

	  If $aWinMatch[0][0] > 0 Then
		 ExitLoop
	  Else
		 Sleep(1000)
		 $iSecs += 1
	  EndIf

	  ; Timeout
	  If $iTimeOutSecs > 0 And $iSecs = $iTimeOutSecs Then ExitLoop
   WEnd

	; _ArrayDisplay($aWinMatch)
	; _ArrayDisplay($aWinNotMatch)
	_ArrayConcatenate($aWinMatch, $aWinNotMatch)
	; _ArrayDisplay($aWinMatch)
   Return $aWinMatch
EndFunc   ;==>_WaitChildDialog

; Func _WinListDebug($aWinList, $i)
;   ConsoleWrite("Title: " & $aWinList[$i][0] & @CRLF & "Handle: " & $aWinList[$i][1] & " PID: " & WinGetProcess($aWinList[$i][1]) & " Parent ID: " & _WinAPI_GetParent ( $aWinList[$i][1] ) & @CRLF)
;EndFunc

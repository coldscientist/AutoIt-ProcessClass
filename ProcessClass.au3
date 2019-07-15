#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         Eduardo Mozart de Oliveira

 Script Function:
	Now making Window name and executables/PIDs interchangable!.
	Credit to Cynagen
	https://www.autoitscript.com/forum/topic/95328-window-title-process-nameid/

#ce ----------------------------------------------------------------------------

Func _Win2Process($wintitle)
    If IsString($wintitle) = 0 Then Return -1
    $wproc = WinGetProcess($wintitle)
    return _ProcessName($wproc)
 endfunc

Func _Process2Win($pid)
    If IsString($pid) Then $pid = ProcessExists($pid)
    If $pid = 0 Then Return -1
    $list = WinList()
    For $i = 1 To $list[0][0]
        If $list[$i][0] <> "" AND BitAnd(WinGetState($list[$i][1]),2) Then
            $wpid = WinGetProcess($list[$i][0])
            If $wpid = $pid Then Return $list[$i][0]
        EndIf
    Next
    Return -1
 EndFunc

Func _ProcessName($pid)
    If IsString($pid) Then $pid = ProcessExists($pid)
    If Not IsNumber($pid) Then Return -1
    $proc = ProcessList()
    For $p = 1 To $proc[0][0]
        If $proc[$p][1] = $pid Then Return $proc[$p][0]
    Next
    Return -1
EndFunc

; Function for getting HWND from PID
; https://www.autoitscript.com/wiki/FAQ#How_can_I_get_a_window_handle_when_all_I_have_is_a_PID.3F
Func _GetHwndFromPID($PID)
	$hWnd = 0
	Local $winlist[0] ; Initiate the array.
	$winlist = WinList()
	Local $iPID2 = Null
	Do
		For $i = 1 To $winlist[0][0]
			If $winlist[$i][0] <> "" Then
				$iPID2 = WinGetProcess($winlist[$i][1])
				If $iPID2 = $PID Then
					$hWnd = $winlist[$i][1]
					ExitLoop
				EndIf
			EndIf
		Next
	Until $hWnd <> 0
	Return $hWnd
EndFunc;==>_GetHwndFromPID

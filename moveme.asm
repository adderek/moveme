.386 
.model flat,stdcall 
option casemap:none 
include \masm32\include\windows.inc 
include \masm32\include\user32.inc 
include \masm32\include\kernel32.inc 
include \masm32\include\shell32.inc 
includelib \masm32\lib\user32.lib 
includelib \masm32\lib\kernel32.lib 
includelib \masm32\lib\shell32.lib
WM_SHELLNOTIFY equ WM_USER+5 
WM_SHELLANIM   equ WM_USER+6
IDI_TRAY equ 0 
IDI_TRAY2 equ 1 
IDM_EXIT equ 1010 
WinMain PROTO :DWORD,:DWORD,:DWORD,:DWORD

.data 
ClassName  db "MoveMeClass",0 
AppName	   db "MoveMe",0 
ExitString db "E&xit Program",0

myico1 dd 0
myico2 dd 0

.data? 
hInstance dd ? 
note NOTIFYICONDATA <> 
hPopupMenu dd ?
threadHandle dd ?

INPUT_MOUSE    equ 0
MOUSEEVENTF_MOVE equ 1

sMOUSEINPUT STRUCT
_dx DWORD ?
_dy DWORD ?
mouseData DWORD ?
dwFlags DWORD ?
time DWORD ?
dwExtraInfo DWORD ?
sMOUSEINPUT ENDS

INPUT STRUCT
_type DWORD ?
union
  mi sMOUSEINPUT <>
  ki KEYBDINPUT <>
  hi HARDWAREINPUT <>
ends
INPUT ENDS

ti INPUT <>

.code 
start: 
	invoke GetModuleHandle, NULL 
	mov	hInstance,eax 
	invoke WinMain, hInstance,NULL,NULL, SW_SHOWDEFAULT 
	invoke ExitProcess,eax

WinMain proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdLine:LPSTR,CmdShow:DWORD 
	LOCAL wc:WNDCLASSEX 
	LOCAL msg:MSG 
	LOCAL hwnd:HWND 
	mov   wc.cbSize,SIZEOF WNDCLASSEX 
	mov   wc.style, CS_HREDRAW or CS_VREDRAW or CS_DBLCLKS 
	mov   wc.lpfnWndProc, OFFSET WndProc 
	mov   wc.cbClsExtra,NULL 
	mov   wc.cbWndExtra,NULL 
	push  hInst 
	pop   wc.hInstance 
	mov   wc.hbrBackground,COLOR_APPWORKSPACE 
	mov   wc.lpszMenuName,NULL 
	mov   wc.lpszClassName,OFFSET ClassName 
	invoke LoadIcon,NULL,IDI_APPLICATION 
	mov   wc.hIcon,eax 
	mov   wc.hIconSm,eax 
	invoke LoadCursor,NULL,IDC_ARROW 
	mov   wc.hCursor,eax 
	invoke RegisterClassEx, addr wc 
	invoke CreateWindowEx,0,ADDR ClassName,ADDR AppName,\ 
			0,CW_USEDEFAULT,\ 
			CW_USEDEFAULT,350,200,NULL,NULL,\ 
			hInst,NULL 
	mov   hwnd,eax 

	.while TRUE 
		invoke GetMessage, ADDR msg,NULL,0,0 
		.BREAK .IF (!eax) 
		invoke TranslateMessage, ADDR msg 
		invoke DispatchMessage, ADDR msg 
	.endw 
	mov eax,msg.wParam 
	ret 
WinMain endp

WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM 
	LOCAL pt:POINT 
	.if uMsg==WM_CREATE 
		invoke CreatePopupMenu 
		mov hPopupMenu,eax 
		;invoke AppendMenu,hPopupMenu,MF_STRING,IDM_RESTORE,addr RestoreString 
		invoke AppendMenu,hPopupMenu,MF_STRING,IDM_EXIT,addr ExitString 
		mov note.cbSize,sizeof NOTIFYICONDATA 
		push hWnd 
		pop note.hwnd 
		mov note.uID,IDI_TRAY 
		mov note.uFlags,NIF_ICON+NIF_MESSAGE+NIF_TIP 
		mov note.uFlags,NIF_ICON+NIF_MESSAGE 
		mov note.uCallbackMessage,WM_SHELLNOTIFY 
		;invoke LoadIcon,NULL,IDI_WINLOGO 
		invoke LoadIcon,hInstance,500
		mov myico1,eax
		mov note.hIcon,eax 
		mov note.dwState, NIS_SHAREDICON
		mov note.dwStateMask, NIS_SHAREDICON
		invoke LoadIcon,hInstance,501
		mov myico2,eax
		invoke lstrcpy,addr note.szTip,addr AppName 
		invoke ShowWindow,hWnd,SW_HIDE 
		invoke Shell_NotifyIcon,NIM_ADD,addr note 
		mov  ebx,OFFSET ThreadProc
		invoke CreateThread,NULL,NULL,ebx,hWnd,0,ADDR threadHandle
	.elseif uMsg==WM_DESTROY 
		invoke DestroyMenu,hPopupMenu
		invoke CloseHandle, threadHandle
		invoke PostQuitMessage,NULL 
	.elseif uMsg==WM_COMMAND 
		.if lParam==0 
			invoke Shell_NotifyIcon,NIM_DELETE,addr note 
			mov eax,wParam 
			invoke DestroyWindow,hWnd 
		.endif
	.elseif uMsg==WM_SHELLANIM
		;push lParam
		;pop eax
		;mov eax,wParam
		;add eax,500
		;invoke LoadIcon,hInstance,eax
		mov eax,lParam
		mov note.hIcon, eax
		mov note.uFlags, NIF_ICON 
		invoke Shell_NotifyIcon,NIM_MODIFY,addr note 
	.elseif uMsg==WM_SHELLNOTIFY 
		.if wParam==IDI_TRAY 
			.if lParam==WM_RBUTTONDOWN 
				invoke GetCursorPos,addr pt 
				invoke SetForegroundWindow,hWnd 
				invoke TrackPopupMenu,hPopupMenu,TPM_RIGHTALIGN,pt.x,pt.y,NULL,hWnd,NULL 
				invoke PostMessage,hWnd,WM_NULL,0,0 
			.elseif lParam==WM_LBUTTONDBLCLK 
				invoke PostQuitMessage,NULL
			.endif 
		.endif 
	.else 
		invoke DefWindowProc,hWnd,uMsg,wParam,lParam 
		ret 
	.endif 
	xor eax,eax 
	ret 
WndProc endp

ThreadProc PROC hWnd:DWORD
	LOCAL pt:POINT 
	Loop1:
	invoke Sleep, 14500
	mov ti._type,INPUT_MOUSE
	mov ti.mi.dwFlags,MOUSEEVENTF_MOVE
	mov ti.mi._dx,1
	mov ti.mi._dy,1
	mov ti.mi.mouseData,0
	mov ti.mi.time,0
	call GetMessageExtraInfo
	mov ti.mi.dwExtraInfo,eax
	invoke SendInput,1,addr ti, SIZEOF INPUT
	sub ti.mi._dx,2
	sub ti.mi._dy,2
	invoke SendInput,1,addr ti, SIZEOF INPUT
	invoke SendMessage, hWnd, WM_SHELLANIM, 1, myico2
	invoke Sleep, 500
	invoke SendMessage, hWnd, WM_SHELLANIM, 0, myico1
	jmp Loop1
ThreadProc ENDP

end start 

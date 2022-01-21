;	Luis Maya
;	Assignment #4
;	Section #1002

; -----
;  This program will find the minimum, maximum, middle value, sum, and average of a list of numbers.
;  It will also find the sum of all positive numbers, the amount of positive numbers, and the average of the postive numbers.
;  It will do the same for all numbers evenly divisible by 3.
; ----------------------------------------------

section	.data

; -----
;  Define constants.

NULL		equ	0			; end of string

TRUE		equ	1
FALSE		equ	0

SUCCESS		equ	0			; successful operation
SYS_exit	equ	60			; call code for terminate

; -----

lst		dd	 1246,  1116,  1542,  1240,  1677
		dd	 1635,  2426,  1820,  1246, -2333
		dd	 2317, -1115,  2726,  2140,  2565
		dd	 2871,  1614,  2418,  2513,  1422
		dd	-2119,  1215, -1525, -1712,  1441
		dd	-3622,  -731, -1729,  1615,  1724
		dd	 1217, -1224,  1580,  1147,  2324
		dd	 1425,  1816,  1262, -2718,  2192
  		dd	-1432,  1235,  2764, -1615,  1310
		dd	 1765,  1954,  -967,  1515,  3556
		dd	 1342,  7321,  1556,  2727,  1227
		dd	-1927,  1382,  1465,  3955,  1435
		dd	-1225, -2419, -2534, -1345,  2467
		dd	 1315,  1961,  1335,  2856,  2553
  		dd	-1032,  1835,  1464,  1915, -1810
		dd	 1465,  1554, -1267,  1615,  1656
		dd	 2192, -1825,  1925,  2312,  1725
		dd	-2517,  1498, -1677,  1475,  2034
		dd	 1223,  1883, -1173,  1350,  1415
		dd	  335,  1125,  1118,  1713,  3025
len		dd	100

lstMin		dd	0
lstMid		dd	0
lstMax		dd	0
lstSum		dd	0
lstAve		dd	0

posCnt		dd	0
posSum		dd	0
posAve		dd	0

threeCnt	dd	0
threeSum	dd	0
threeAve	dd	0

numFour     dd  4
numThree    dd  3
numTwo      dd  2




; ----------------------------------------------

section	.text
global _start
_start:

; *****************************************

mov eax, dword [lst]            ; Move first value in list to eax
mov dword [lstMin], eax         ; Set min as first value
mov dword [lstMax], eax         ; Set max as first value
mov ecx, dword [len]            ; Move length value into ecx
mov r8d, dword [posCnt]         ; Move posCnt value to r8d
mov r9d, dword [threeCnt]       ; Move threeCnt value to r9d
mov rsi, 0                      ; i = 0

startLoop:
    mov eax, dword [lst + rsi]  ; Move lst[i] into eax
    add dword [lstSum], eax     ; lstSum += lst[i]
    cmp eax, dword [lstMax]     ; Compare lst[i] with curr Max
    jle maxDone
    mov dword [lstMax], eax     ; Swap lstMax with lst[i] if lst[i] > lstMax
maxDone:
    cmp eax, dword [lstMin]     ; Compare lst[i] with curr Min
    jge minDone
    mov dword [lstMin], eax     ; Swap lstMin with lst[i] if lst[i] < lstMin
minDone:
    cmp eax, 0                  ; Compare lst[i] with 0
    jle posCheckDone
    inc r8d                     ; Inc posCnt if lst[i] > 0
    add dword [posSum], eax     ; posSum += lst[i]
posCheckDone:
    cdq
    idiv dword [numThree]       ; lst[i]/3
    cmp edx, 0
    jne threeCheckDone          ; Check if lst[i] is divisible by 3
    inc r9d                     ; Inc threeCnt if lst[i] is divisible by 3
	mov eax, dword [lst + rsi]	; Restore current value of lst[i]
    add dword [threeSum], eax   ; threeSum += lst[i]
threeCheckDone:
    add rsi, 4                  ; Update lst[i]
    dec ecx                     ; length--
    cmp ecx, 0
    jne startLoop               ; If length != 0, jump to beginning

mov dword [posCnt], r8d         ; Move value of r8d into posCnt
mov dword [threeCnt], r9d       ; Move value of r9d into threeCnt

mov eax, dword [lstSum]         ; Move lstSum value into eax
cdq
idiv dword [len]                ; lstSum/len
mov dword [lstAve], eax         ; Move eax value into lstAve

mov eax, dword [posSum]         ; Move posSum value into eax
cdq
idiv dword [posCnt]             ; posSum/posCnt
mov dword [posAve], eax         ; Move eax value into posAve

mov eax, dword [threeSum]       ; Move threeSum value into eax
cdq
idiv dword [threeCnt]           ; threeSum/threeCnt
mov dword [threeAve], eax       ; Move eax value into threeAve

midLoop:
    mov eax, dword [len]        ; Move len value into eax
    cdq
    idiv dword [numTwo]         ; len/2
    cmp edx, 0
    jne oddLoop                 ; If length is odd jump to oddLoop
    mov eax, dword [len]        ; Move value of len into eax
    sub eax, 1                  ; Find first mid value, Length - 1
    cdq
    idiv dword [numTwo]         ; (Length - 1)/2
    imul dword [numFour]        ; Get address of first middle value
    mov esi, eax                ; Move address value of first middle value to midOne
    mov eax, dword [lst + esi]  ; Move value of lst[first middle value] into ebx
    add esi, 4                  ; Get address of second middle value
    mov ecx, dword [lst + esi]  ; Move value of lst[second middle value] into ecx
    add eax, ecx                ; Add first and second middle value, store in ebx
    cdq
    idiv dword [numTwo]         ; Divide eax to find average of middle values
    jmp midDone
oddLoop:
    mov eax, dword [len]        ; Move value of len into eax
    sub eax, 1                  ; Find middle value, Length - 1
    cdq
    idiv dword [numTwo]         ; (Length - 1)/2
    imul dword [numFour]        ; Get address of middle value and store it in eax
    mov esi, eax                ; Move address of middle value to rsi
    mov eax, dword [lst + esi]  ; Move value of middle value to eax
    jmp midDone
midDone:
    mov dword [lstMid], eax     ; Move middle value into lstMid

; *****************************************
;  Done, terminate program.

last:
	mov	eax, SYS_exit		; call code for exit (SYS_exit)
	mov	ebx, SUCCESS		; return SUCCESS (no error)
	syscall

;	Luis Maya
;	Assignment #5
;	Section #1002

; -----
;  This program will find the volume and surface area minimums, maximums, middle values, sums, and averages of a list of numbers.
; *****************************************************************

section	.data

; -----
;  Define constants

NULL		equ	0			; end of string

TRUE		equ	1
FALSE		equ	0

SUCCESS		equ	0			; successful operation
SYS_exit	equ	60			; call code for terminate

; -----
;  Provided Data Set

aSides		db	   10,    14,    13,    37,    54
		db	   31,    13,    20,    61,    36
		db	   14,    53,    44,    19,    42
		db	   27,    41,    53,    62,    10
		db	    9,     8,     4,    10,    15
		db	    5,    11,    22,    33,    70
		db	   15,    23,    15,    63,    26
		db	   24,    33,    10,    61,    15
		db	   14,    34,    13,    71,    81
		db	   38,    73,    29,    17,    93

bSides		dw	  133,   114,   173,   131,   115
		dw	  164,   173,   174,   123,   156
		dw	  144,   152,   131,   142,   156
		dw	  115,   124,   136,   175,   146
		dw	  113,   123,   153,   167,   135
		dw	  114,   129,   164,   167,   134
		dw	  116,   113,   164,   153,   165
		dw	  126,   112,   157,   167,   134
		dw	  117,   114,   117,   125,   153
		dw	  123,   173,   115,   106,    13

cSides		dd	 1145,  1135,  1123,  1123,  1123
		dd	 1254,  1454,  1152,  1164,  1542
		dd	 1353,  1457,   182,  1142,  1354
		dd	 1364,  1134,  1154,  1344,   142
		dd	 1173,  1543,  1151,  1352,  1434
		dd	 1355,  1037,   123,  1024,  1453
		dd	 1134,  2134,  1156,  1134,  1142
		dd	 1267,  1104,  1134,  1246,   123
		dd	 1134,  1161,  1176,  1157,  1142
		dd	 1153,  1193,  1184,   142,  2034

length		dd	50

vMin		dd	0
vMid		dd	0
vMax		dd	0
vSum		dd	0
vAve		dd	0

saMin		dd	0
saMid		dd	0
saMax		dd	0
saSum		dd	0
saAve		dd	0

; -----
; Additional variables (if any)
numFour		dd	4
numTwo		dd	2


; --------------------------------------------------------------
; Uninitialized data

section	.bss

volumes		resd	50
surfaceAreas	resd	50

; ----------------------------------------------

section	.text
global _start
_start:

; *****************************************

mov ecx, dword [length]                 	; Move lengh value into ecx
mov rsi, 0                              	; i = 0

volumeLoop:
	movzx ebx, word [bSides + rsi * 2]  	; Move bSides[i] into ebx
    movzx eax, byte [aSides + rsi]      	; Move aSides[i] into eax
	mul dword [cSides + rsi * 4]
    mul ebx                       			; aSides[i] * bSides[i] stored in ebx
    mov dword [volumes + rsi * 4], eax  	; Store into volumes[i]
    inc rsi                             	; update i
    dec ecx                             	; length--
    cmp ecx, 0
    jne volumeLoop                      	; Compare current length to 0, if != keep looping
    mov rsi, 0                          	; Reset i = 0
    mov ecx, dword [length]             	; Reset length value stored in ecx
    mov eax, dword [volumes]            	; Move first value of volumes to eax
    mov dword [vMin], eax               	; Set vMin to first value of volumes
    mov dword [vMax], eax               	; Set vMax to first value of volumes
volumeStats:
    mov eax, dword [volumes + rsi * 4]  	; Move volumes[i] into eax
    add dword [vSum], eax               	; vSum += volumes[i]
    cmp eax, dword [vMax]               	; Compare volumes[i] with curr Max
    jbe vMaxDone
    mov dword [vMax], eax               	; Swap vMax with volumes[i], if volumes[i] > vMax
vMaxDone:
    cmp eax, dword [vMin]               	; Compare volumes[i] with curr Min
    jae vMinDone
    mov dword [vMin], eax               	; Swap vMin with volumes[i], if volumes[i] < vMin
vMinDone:
    inc rsi                             	; Update volumes[i]
    dec ecx                             	; length--
    cmp ecx, 0
    jne volumeStats                     	; If ecx != 0, jump to volumeStats
    mov eax, dword [vSum]               	; Move value of vSum into eax
    mov edx, 0
    div dword [length]                  	; vSum/length stored in eax
    mov dword [vAve], eax               	; Set vAve to eax
	mov ecx, dword [length]					; Move length value into ecx
	mov rsi, 0								; i = 0
saLoop:
	movzx eax, byte [aSides + rsi]			; Move aSides[i] into eax
	mul dword [cSides + rsi * 4]			; aSides[i] * cSides[i] stored in eax
	mov r8d, eax							; Move ans to r8d
	movzx eax, word [bSides + rsi * 2]		; Move bSides[i] into eax
	mul dword [cSides + rsi * 4]			; bSides[i] * cSides[i] stored in eax
	mov r9d, eax							; Move ans to r9d
	movzx r10d, byte [aSides + rsi]			; Move aSides[i] into r10d
	movzx eax, word [bSides + rsi * 2]		; Move bSides[i] into eax
	mul r10d								; aSides[i] * bSides[i] stored in r9d
	add eax, r8d							; (aSides[i] * cSides[i]) + (bSides[i] * cSides[i]) stored in eax
	add eax, r9d							; eax + (aSides[i] * bSides[i]) stored in eax
	mul dword [numTwo]						; eax * 2 stored in eax
	mov dword [surfaceAreas + rsi * 4], eax	; Store in surfaceAreas[i]
	inc rsi									; Update i++
	dec ecx									; length--
	cmp ecx, 0
	jne saLoop								; If ecx != 0, jump to saLoop
	mov rsi, 0								; Reset i = 0
	mov ecx, dword [length]					; Reset length value stored in ecx
	mov eax, dword [surfaceAreas]			; Move first value of surfaceAreas to eax
	mov dword [saMin], eax					; Set saMin to first value of surfaceAreas
	mov dword [saMax], eax					; Set saMax to first value of surfaceAreas
saStats:
	mov eax, dword [surfaceAreas + rsi * 4]	; Move surfaceAreas[i] into eax
	add dword [saSum], eax					; saSum += surfaceAreas[i]
	cmp eax, dword [saMax]					; Compare surfaceAreas[i] with curr max
	jbe saMaxDone
	mov dword [saMax], eax					; Swap saMax with surfaceAreas[i], if surfaceAreas[i] > saMax
saMaxDone:
	cmp eax, dword [saMin]					; Compare surfaceAreas[i] with curr min
	jae saMinDone
	mov dword [saMin], eax					; Swap saMin with surfaceAreas[i], if surfaceAreas < saMin
saMinDone:
	inc rsi									; Update i++
	dec ecx									; length --
	cmp ecx, 0
	jne saStats								; If ecx != 0, jump to saStats
	mov eax, dword [saSum]					; Move saSum value into eax
	mov edx, 0
	div dword [length]						; saSum/length stored in eax
	mov dword [saAve], eax					; Set saAve to eax
MidLoop:
	mov eax, dword [length]        			; Move len value into eax
	mov edx, 0
	div dword [numTwo]         				; length/2
	cmp edx, 0
	jne oddLoop                 			; If length is odd jump to oddLoop
	mov eax, dword [length]        			; Move value of len into eax
	sub eax, 1                  			; Find first mid value, Length - 1
	mov edx, 0
	div dword [numTwo]         				; (Length - 1)/2
	mul dword [numFour]        				; Get address of first middle value
	mov esi, eax                			; Move address value of first middle value to esi from eax
	mov eax, dword [volumes + esi]  		; Move value of volumes[first middle value] into eax
	mov r8d, dword [surfaceAreas + esi]		; Move value of surfaceAreas[first middle value] into r8d
	add esi, 4                  			; Get address of second middle value
	mov ecx, dword [volumes + esi]  		; Move value of volumes[second middle value] into ecx
	mov r9d, dword [surfaceAreas + esi]		; Move value of surfaceAreas[second middle value] into r9d
	add eax, ecx                			; Add first and second middle values of volumes, store in eax
	mov edx, 0
	div dword [numTwo]         				; Divide eax to find average of middle values for volumes, stored in eax
	mov dword [vMid], eax					; Move middle value of volumes into vMid
	add r8d, r9d							; Add first and second middle values of surfaceAreas, store in r8d
	mov eax, r8d
	mov edx, 0
	div dword [numTwo]						; Divide eax to find average of middle values for surfaceAreas, stored in eax
	mov dword [saMid], eax					; Move middle value of surfaceAreas into saMid
	jmp midDone
oddLoop:
	mov eax, dword [length]        			; Move value of len into eax
	sub eax, 1                  			; Find middle value, Length - 1
	mov edx, 0
	div dword [numTwo]         				; (Length - 1)/2
	mul dword [numFour]        				; Get address of middle value and store it in eax
	mov esi, eax                			; Move address of middle value to esi from eax
	mov eax, dword [volumes + esi]  		; Move middle value of volumes to eax
	mov dword [vMid], eax					; Move middle value of volumes into vMid
	mov eax, dword [surfaceAreas + esi]		; Move middle value of surfaceAreas to r8d
	mov dword [saMid], eax					; Move middle value of surfaceAreas into saMid
	jmp midDone
midDone:

; *****************************************
;  Done, terminate program.

last:
	mov	eax, SYS_exit		; call code for exit (SYS_exit)
	mov	ebx, SUCCESS		; return SUCCESS (no error)
	syscall

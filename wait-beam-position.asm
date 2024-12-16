_CUSTOM				EQU $dff000
VPOSR				EQU $004
VHPOSR				EQU $006
COLOR00				EQU $180

_CIAA				EQU $bfe001
CIAPRA				EQU $000
CIAB_GAMEPORT0			EQU 6	; left mouse button

vert_beam_position		EQU $136 ; PAL


; Input
; Result
	CNOP 0,4
main
	lea	_CIAA,a4
	lea	_CUSTOM,a6
main_loop
	bsr	wait_vert_beam_position
;	bsr	routine1
;	bsr	routine2
;	bsr	routine3
	btst	#CIAB_GAMEPORT0,CIAPRA(a4)
	bne.s	main_loop
	rts


; Input
; a6	Custom chips base
; Result
	CNOP 0,4
wait_vert_beam_position
	move.l	#$0003ff00,d1		; only vertical position
	move.l  #vert_beam_position<<8,d2
	lea	VPOSR(a6),a0
	lea	VHPOSR(a6),a1
wait_vert_beam_position_loop
	move.w	(a0),d0			; VPOSR
	swap	d0			; adjust bits
	move.w	(a1),d0			; VHPOSR
	and.l	d1,d0			; only vertical position
	cmp.l	d2,d0			; vertical beam position reached ?
	blt.s	wait_vert_beam_position_loop
	rts

	END

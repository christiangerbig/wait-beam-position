_CUSTOM				EQU $dff000
VPOSR				EQU $004
VHPOSR				EQU $006
COLOR00				EQU $180

_CIAA				EQU $bfe001
CIAPRA				EQU $000
CIAB_GAMEPORT0			EQU 6	; left mouse button

beam_position			EQU $136 ; PAL: bottom of frame

vertical_position_bits		EQU $3ff ; V0..V9 position bits


; Input
; Result
	CNOP 0,4
main
	lea	_CIAA,a4
	lea	_CUSTOM,a6
main_loop
	bsr	wait_beam_position
;	bsr	routine1
;	bsr     routine2
;	bsr	routine3
	btst	#CIAB_GAMEPORT0,CIAPRA(a4)
	bne.s	main_loop
	rts


; Input
; a6.l	Custom chips base
; Result
	CNOP 0,4
wait_beam_position
	move.l	#vertical_position_bits<<8,d1
	move.l	#beam_position<<8,d2
	lea	VPOSR(a6),a0
	lea	VHPOSR(a6),a1
wait_beam_position_loop1
	move.w	(a0),d0
	swap	d0			; high word: VPOSR
	move.w	(a1),d0			; low word: VHPOSR
	and.l	d1,d0			; vertical position
	cmp.l	d2,d0			; one position per frame on 680x0 machines
	bge.s	wait_beam_position_loop1
wait_beam_position_loop2
	move.w	(a0),d0
	swap	d0			; high word: VPOSR
	move.w	(a1),d0			; low word: VHPOSR
	and.l	d1,d0			; vertical position
	cmp.l	d2,d0			; beam position reached ?
	blt.s	wait_beam_position_loop2
	rts

	END

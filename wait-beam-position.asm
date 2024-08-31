_CUSTOM				EQU $dff000
VPOSR				EQU $004
VHPOSR				EQU $006
COLOR00				EQU $180

_CIAA				EQU $bfe001
CIAPRA				EQU $000
CIAB_GAMEPORT0			EQU 6

vert_beam_position		EQU $135

rgb4_red			EQU $f00


main
	bsr	wait_vert_beam_position
;	bsr	swap_playfields
;	bsr	routine1
;	bsr	routine2
;	bsr	routine3
	move.w	#rgb4_red,COLOR00(a6)
	btst	#CIAB_GAMEPORT0,CIAPRA(a4)
	bne.s	main


; Waiting for a specific vertical beam position
; Input
; a6	... Custom chips base
; Result
; d0	... No return value
	CNOP 0,4
wait_vert_beam_position
	move.l	#$0003ff00,d1		; Mask out non vertical position bits
	move.l  #vert_beam_position<<8,d2
	lea	VPOSR(a6),a0
	lea	VHPOSR(a6),a1
wait_vert_beam_position_loop
	move.w	(a0),d0			; Get VPOSR bits
	swap	d0			; and shift them to the upper word
	move.w	(a1),d0			; Get VHPOSR bits lower word
	and.l	d1,d0			; Only vertical position
	cmp.l	d2,d0			; Wait for the rasterline
	blt.s	wait_vert_beam_position_loop
	rts

; ... routines

	END




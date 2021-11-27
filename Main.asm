; Bunny game
; made in 2021 by Mia/FLuffyFoxBunny 

*=$0801

        BYTE    $0B, $08, $0A, $00, $9E, $34, $39, $31, $35, $32, $00, $00, $00


*=$c000

start

 lda #$40 ;clean variables
 sta spritexlo
 lda #$f0
 sta spritexlo+1
 lda #$e0
 sta spritexlo+2

 lda #$bb
 sta spritey
 lda #$af
 sta spritey+1
 lda #$90
 sta spritey+2
 lda #0
 sta spritexhi
 sta buttondown
 sta gameover
         
;this is where things start
 jsr drawbackground
 jsr initsprites
loop
 jsr checkjoystick
loopcont
 jsr positionsprites
 jsr waitraster
 jsr checkgameover

 
 jmp loop


positionsprites
 ldx #$f
 ldy #$7
ploop
 lda spritey,y
 sta $d000,x
 dex
 lda spritexlo,y
 sta $d000,x
 lda spritexhi,y
 ror a
 rol $d010
 dex
 dey
 bpl ploop 
 rts


drawbackground

 lda #14
 sta $d020
 sta $d021
 ldx #$00
 

bgloop ;fill background chars
 lda bgchar+1,x
 sta $400,x
 lda bgchar+256,x
 sta $500,x
 lda bgchar+512,x
 sta $600,x
 lda bgchar+768,x
 sta $700,x
 inx
 bne bgloop
 ldx #$00

bgloop2 ;fill background colors
 lda bgcol,x
 sta $d800,x
 lda bgcol+256,x
 sta $d900,x
 lda bgcol+512,x
 sta $da00,x
 lda bgcol+768,x
 sta $db00,x
 inx
 bne bgloop2 
 
 rts

initsprites
 
 lda #$3
 sta $d015
 lda #$ff
 sta $d017 ;expand y
 sta $d01d ;expand x

 lda #9     ;sprite colors
 sta $d027
 lda #5
 sta $d028
 lda #4
 sta $d029


 lda #$80 ;sprite pointers
 sta $07f8
 lda #$83
 sta $07f9
 lda #$86
 sta $07fa

 rts

checkjoystick
 


 lda $dc00
 lsr a
 lsr a
 lsr a
 bcs checkright

 ldx #1
 stx walking
 dec spritexlo
 ldy spritexlo
 cpy #$ff
 bne checkright
 dec spritexhi
checkright
 lsr
 bcs chkbutton ;if right isn't pressed,branch
 ldx #1
 stx walking
 inc spritexlo
 bne chkbutton
 inc spritexhi

chkbutton
 lsr
 bcs end
 ldx buttondown
 cpx #1
 beq end
 ldx #1
 stx buttondown
 lda $d01e
 cmp #%00000011 ;check collision
 bne end
 inc $07f9
 ldx $07f9
 cpx #$85
 bne end
 ldx #1
 stx gameover

end 
 
 lda $dc00
 lsr a
 lsr a
 lsr a
 lsr a
 lsr a
 bcc end2
 lda #0
 sta buttondown

 lda $dc00
 lsr a
 lsr a
 lsr a
 bcc end2
 lsr a
 bcc end2
 lda #0
 sta walking
 ldx #$80
 stx $07f8

end2
  
 rts

waitraster

 ldx #$ff
waitff
 cpx $d012
 bne waitff
 inx

wait00
 cpx $d012
 bne wait00


 inc frames
 lda frames
 cmp #$10 ;animation stuff
 bne frend ;for walking animation
 lda #$0
 sta frames
frend
 ldx walking
 beq rend
 lda frames
 cmp #$0
 bne rend
 ldx $07f8
 cpx #$82
 bne rend2
 ldx #$80
 stx $07f8
 jmp rend
rend2
 ldx $07f8
 inx
 stx $07f8
 rts
 
rend
 
 
 
 rts

checkgameover  ;brinf up win sprite

 lda gameover
 cmp #1
 bne waitend
 lda #00
 sta $d020
 lda #$7
 sta $d015
 
waitend
 rts

spritexlo
 byte $40,$f0,$e0,$00,$00,$00,$00,$00
spritexhi
 byte $00,$00,$00,$00,$00,$00,$00,$00
spritey
 byte $bb,$af,$90,$00,$00,$00,$00,$00
walking
 byte $00
buttondown
 byte $00
gameover 
 byte $00
frames
 byte $00


*=$2000

sprites
 incbin "Sprites.spt",1,7,true

bgchar
 incbin "screen.sdd",1,1,CHAR
        
bgcol
 incbin "screen.sdd",1,1,COLOUR






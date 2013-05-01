; Text functions for kernel
; Inputs:    A: Character to print
;            D,E: X,Y
;            B: Left X (used for \n)
;            IY: Buffer
; Outputs:    Updates DE
drawChar:
drawCharOR:
    push af
    push hl
    push ix
    push bc
        cp '\n'
        jr nz, _
        ld a, e
        add a, 6
        ld e, a
        ld d, b
        jr ++_
    
_:      push de
            ld de, 6
            sub 0x20
            call DEMulA
            ex de, hl
            ld hl, kernel_font
            add hl, de
            ld a, (hl)
            inc hl
        pop de
        ld b, 5
        call putSpriteOR
        add a, d
        ld d, a
_:  pop bc
    pop ix
    pop hl
    pop af
    ret
    
drawCharAND:
    push af
    push hl
    push ix
    push bc
        cp '\n'
        jr nz, _
        ld a, e
        add a, 6
        ld e, a
        ld d, b
        jr ++_
    
_:      push de
            ld de, 6
            sub 0x20
            call DEMulA
            ex de, hl
            ld hl, kernel_font
            add hl, de
            ld a, (hl)
            inc hl
        pop de
        ld b, 5
        call putSpriteAND
        add a, d
        ld d, a
_:  pop bc
    pop ix
    pop hl
    pop af
    ret

drawCharXOR:
    push af
    push hl
    push ix
    push bc
        cp '\n'
        jr nz, _
        ld a, e
        add a, 6
        ld e, a
        ld d, b
        jr ++_
    
_:        push de
            ld de, 6
            sub 0x20
            call DEMulA
            ex de, hl
            ld hl, kernel_font
            add hl, de
            ld a, (hl)
            inc hl
        pop de
        ld b, 5
        call putSpriteXOR
        add a, d
        ld d, a
_:  pop bc
    pop ix
    pop hl
    pop af
    ret

; Inputs:    HL: String
;            DE: Location
;            B (Optional): Left X (Used for \n)
;            IY: Buffer
drawStr:
    push hl
    push af
_:      ld a, (hl)
        or a
        jr z, _
        call drawChar
        inc hl
        jr -_
_:  pop af
    pop hl
    ret

drawStrAND:
    push hl
    push af
_:      ld a, (hl)
        or a
        jr z, _
        call drawCharAND
        inc hl
        jr -_
_:  pop af
    pop hl
    ret
    
drawStrXOR:
    push hl
    push af
_:      ld a, (hl)
        or a
        jr z, _
        call drawCharXOR
        inc hl
        jr -_
_:  pop af
    pop hl
    ret
    ret

; Inputs:    B: Stream ID
; Prints a string from a stream
drawStrFromStream:
    push af
_:      call streamReadByte
        jr nz, _
        or a
        jr z, _
        call drawChar
        jr -_
_:  pop af
    ret
    
drawHexA:
   push af
   rrca
   rrca
   rrca
   rrca
   call dispha
   pop af
   call dispha
   ret
dispha:
   and 15
   cp 10
   jr nc, dhlet
   add a, 48
   jr dispdh
dhlet:
   add a, 55
dispdh:
   jp drawCharOR
   
; Inputs:    A: Character to measure
; Outputs:    A: Width of character (height is always 5)
; Note: The width of most characters include a column of
; whitespace on the right side.
measureChar:
    push hl
    push de
        ld de, 6
        sub 0x20
        call DEMulA
        ex de, hl
        ld hl, kernel_font
        add hl, de
        ld a, (hl)
    pop de
    pop hl
    ret

; Inputs:    HL: String to measure
; Outputs:    A: Width of string
measureStr:
    push hl
    push bc
_:     push af
            ld a, (hl)
            or a
            jr z, _
            call measureChar
        pop bc
        add a, b
        ld a, b
        inc hl
        jr -_
_:  pop af
    pop bc
    pop hl
    ret
    
#include "font.asm"
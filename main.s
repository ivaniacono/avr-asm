; =======================================================
;                        MACROS
; =======================================================

.equ PORTB, 0x05
.equ DDRB, 0x04
.equ DELAY_VAL, 0x0F

; Define registers r16, r17, r18, r19
PortBState = 16
PortBDirect = 17
InvertPb = 18
DelayReg = 19
IdxReg1 = 24
IdxReg2 = 25

; =======================================================
;                        INIT
; =======================================================

.org 0x0000 ; the next instruction has to be written to address 0x0000
rjmp start  ; the reset vector: jump to "start"

; =======================================================
;                        START
; =======================================================

start:
ldi PortBState, 0x0 ; onboard led p5 and p0 low
out PORTB, PortBState ;PORTB output

; set PortB as output
ldi PortBDirect, 0xFF
out DDRB, PortBDirect

nop ;syncronization

; xor bitmask
ldi InvertPb, 0xFF

eor PortBState, InvertPb
out PORTB, PortBState

clr IdxReg1
clr IdxReg2

; =======================================================
;                        MAIN LOOP
; =======================================================

loop:
rcall delay
eor PortBState, InvertPb
out PORTB, PortBState
rjmp loop

; =======================================================
;                        DELAY
; =======================================================

delay:
ldi DelayReg, DELAY_VAL

delay_loop:
adiw IdxReg1, 1 ;increment IdxReg1:IdxReg2
brvc delay_loop
clv ;clear overflow
dec DelayReg
cpi DelayReg, 0x0
brne delay_loop
ret

; =======================================================
;                        MACROS
; =======================================================
.include "m328Pdef.inc"

.equ TIMER_VAL, 3036 ; preload timer 65536-(16MHz/256/1Hz)

; Define registers
PortBState = 16
PortBDirect = 17
InvertPb = 18
StoreSreg = 20
LoadTimer = 19

; =======================================================
;                    INTERRUPT VECTOR
; =======================================================

.org 0x0000 ; the next instruction has to be written to address 0x0000
rjmp start  ; the reset vector: jump to "start"
.org INT0addr
reti
.org INT1addr
reti
.org PCI0addr
reti
.org PCI1addr
reti
.org PCI2addr
reti
.org WDTaddr
reti
.org OC2Aaddr
reti
.org OC2Baddr
reti
.org OVF2addr
reti
.org ICP1addr
reti
.org OC1Aaddr
reti
.org OC1Baddr
reti
.org OVF1addr
rcall isr_ovf1
.org OC0Aaddr
reti
.org OC0Baddr
reti
.org OVF0addr
reti
.org SPIaddr
reti
.org URXCaddr
reti
.org UDREaddr
reti
.org UTXCaddr
reti
.org ADCCaddr
reti
.org ERDYaddr
reti
.org ACIaddr
reti
.org TWIaddr
reti
.org SPMRaddr
reti

; =======================================================
;                        START
; =======================================================

start:
; Set stackpointer
ldi r16, lo8(RAMEND)
out SPL, r16
ldi r16, hi8(RAMEND)
out SPH, r16

ldi PortBState, 0x0
out PORTB, PortBState

; set PB5 as output
ldi PortBDirect, (1 << PB5)
out DDRB, PortBDirect

nop ;syncronization

; xor bitmask
ldi InvertPb, (1 << PB5)

cli ; disable global interrupt

rjmp init_timer1

; =======================================================
;                        TIMER1
; =======================================================

init_timer1:
ldi LoadTimer, 0x00
sts TCCR1A, LoadTimer

ldi LoadTimer, (1 << CS12) ;256 prescaler
sts TCCR1B, LoadTimer

ldi LoadTimer, lo8(TIMER_VAL)
sts TCNT1L, LoadTimer
ldi LoadTimer, hi8(TIMER_VAL)
sts TCNT1H, LoadTimer

ldi LoadTimer, (1 << TOIE1) ; overflow interrupt enable
sts TIMSK1, LoadTimer

sei ; enable global interrupt

; =======================================================
;                        MAIN LOOP
; =======================================================

loop:
rjmp loop

; =======================================================
;                        ISR
; =======================================================

isr_ovf1:
in StoreSreg, SREG

ldi LoadTimer, lo8(TIMER_VAL)
sts TCNT1L, LoadTimer
ldi LoadTimer, hi8(TIMER_VAL)
sts TCNT1H, LoadTimer

eor PortBState, InvertPb
out PORTB, PortBState

out SREG, StoreSreg
reti

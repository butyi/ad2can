; ==============================================================================
;                          MINI LAUSCH BOX 
; ==============================================================================
; Hardware: https://github.com/butyi/sci2can/
; ==============================================================================
#include "dz60.inc"
; ===================== CONFIG =================================================

; uC port definitions with line names in schematic
LED2            @pin    PTA,6
CANRX           @pin    PTE,7
CANTX           @pin    PTE,6
RxD1            @pin    PTE,1
RxD1_2          @pin    PTA,0
FET             @pin    PTD,2

; ===================== INCLUDE FILES ==========================================

#include "cop.asm"
#include "mcg.asm"
#include "rtc.asm"
#include "lib.asm"
#include "can.asm"
#include "adc.asm"

; ====================  VARIABLES  =============================================
#RAM

meascnt         ds      2
meascntmax      ds      2

; ====================  PROGRAM START  =========================================
#ROM

start:
        sei                     ; disable interrupts

        ldhx    #XRAM_END       ; H:X points to SP
        txs                     ; Init SP

        jsr     COP_Init
        jsr     PTX_Init        ; I/O ports initialization
        jsr     MCG_Init
        jsr     RTC_Init
        jsr     CAN_Init
        bsr     ADC_Init
        
        cli                     ; Enable interrupts

        clr     meascnt
        clr     meascnt+1
        clr     meascntmax
        clr     meascntmax+1
main
        ; AIN0
        ldx     #0
        bsr     ADC_read
        ldhx    ADCR
        cphx    adc_vals_max+0
        blo     nomax0
        sthx    adc_vals_max+0
nomax0
        cphx    adc_vals_min+0
        bhi     nomin0
        sthx    adc_vals_min+0
nomin0

        ; AIN1
        ldx     #1
        bsr     ADC_read
        ldhx    ADCR
        cphx    adc_vals_max+2
        blo     nomax1
        sthx    adc_vals_max+2
nomax1
        cphx    adc_vals_min+2
        bhi     nomin1
        sthx    adc_vals_min+2
nomin1

        ; AIN2
        ldx     #2
        jsr     ADC_read
        ldhx    ADCR
        cphx    adc_vals_max+4
        blo     nomax2
        sthx    adc_vals_max+4
nomax2
        cphx    adc_vals_min+4
        bhi     nomin2
        sthx    adc_vals_min+4
nomin2

        ; AIN3
        ldx     #3
        jsr     ADC_read
        ldhx    ADCR
        cphx    adc_vals_max+6
        blo     nomax3
        sthx    adc_vals_max+6
nomax3
        cphx    adc_vals_min+6
        bhi     nomin3
        sthx    adc_vals_min+6
nomin3

        ; AIN4
        ldx     #4
        jsr     ADC_read
        ldhx    ADCR
        cphx    adc_vals_max+8
        blo     nomax4
        sthx    adc_vals_max+8
nomax4
        cphx    adc_vals_min+8
        bhi     nomin4
        sthx    adc_vals_min+8
nomin4

        ; AIN5 (Ub)
        ldx     #5
        jsr     ADC_read
        ldhx    ADCR
        cphx    adc_vals_max+10
        blo     nomax5
        sthx    adc_vals_max+10
nomax5
        cphx    adc_vals_min+10
        bhi     nomin5
        sthx    adc_vals_min+10
nomin5


        ldhx    meascnt
        aix     #1
        sthx    meascnt
        cphx    meascntmax
        blo     main        
        sthx    meascntmax
        bra     main



        
; ===================== STRINGS ================================================

hexakars
        db '0123456789ABCDEF'


; ===================== SUB-ROUTINES ===========================================

; ------------------------------------------------------------------------------
; Parallel Input/Output Control
; To prevent extra current consumption caused by flying not connected input
; ports, all ports shall be configured as output. I have configured ports to
; low level output by default.
; There are only a few exceptions for the used ports, where different
; initialization is needed.
; Default init states are proper for OSCILL_SUPP pins, no exception needed.
PTX_Init
        ; All ports to be low level
        clra
        sta     PTA
        sta     PTB
        sta     PTC
        sta     PTD
        sta     PTE
        sta     PTF
        sta     PTG
        bset    CANTX.,CANTX            ; CANTX to be high
        bset    LED2.,LED2              ; LED2 to be On

        ; All ports to be output
        lda     #$FF
        sta     DDRA
        sta     DDRB
        sta     DDRC
        sta     DDRD
        sta     DDRE
        sta     DDRF
        sta     DDRG
        bclr    CANRX.,CANRX+1          ; CANRX to be input
        bclr    RxD1.,RxD1+1            ; RxD1 to be input
        bclr    RxD1_2.,RxD1_2+1        ; RxD1_2 to be input
        lda     #RxD1_2_
        sta     PTAPE                   ; RxD1_2 to be pulled up

        rts


; ===================== IT VECTORS =============================================
#VECTORS
        
        org     Vreset
        dw      start

; ===================== END ====================================================




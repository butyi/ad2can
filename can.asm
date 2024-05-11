; ===================== SUB-ROUTINES ===========================================
#ROM

; ------------------------------------------------------------------------------
; Freescale Controller Area Network (S08MSCANV1)
; Set up CAN for 500 kbit/s using 4 MHz external clock
; CAN will use in interrupt mode, but init does not enable interrupt.
; It will be enabled when transmission can be started, so when
; all bytes have been received from SCI.
;
;   Baud = fCANCLK / Prescaler / (1 + Tseg1 + Tseg2) = 
;     4MHz / 1 / (1+5+2) = 500k 
;   Sample point = 75% 
;     (1 + Tseg1)/(1 + Tseg1 + Tseg2) = (1+5)/(1+5+2) = 0.75
CAN_Init
        ; MSCAN Enable
        lda     #CAN_CANE_
        sta     CANCTL1

        ; Wait for Initialization Mode Acknowledge
ican1
        lda     CANCTL1
        and     #CAN_INITAK_
        beq     ican1

        ; SJW = 1 Tq, Prescaler value (P) = 3
        lda     #3
        sta     CANBTR0
        
        ; One sample per bit, Tseg2 = 2, Tseg1 = 5
        lda     #$14
        sta     CANBTR1

        ; Leave Initialization Mode
        clra
        sta     CANCTL0

        ; Wait for exit Initialization Mode Acknowledge
ican2
        lda     CANCTL1
        and     #CAN_INITAK_
        bne     ican2

        rts


SendMsg1
        ; Select first buffer
        lda     CANTFLG
        sta     CANTBSEL

        ; Set ID
        lda     #$C7
        sta     CANTIDR0
        lda     #$FE
        sta     CANTIDR1
        lda     #$03
        sta     CANTIDR2
        lda     #$32
        sta     CANTIDR3
        
        ; Set message data
        lda     <adc_vals_min+0
        sta     CANTDSR0
        lda     <adc_vals_min+1
        sta     CANTDSR1

        lda     <adc_vals_max+0
        sta     CANTDSR2
        lda     <adc_vals_max+1
        sta     CANTDSR3
        
        lda     <adc_vals_min+2
        sta     CANTDSR4
        lda     <adc_vals_min+3
        sta     CANTDSR5

        lda     <adc_vals_max+2
        sta     CANTDSR6
        lda     <adc_vals_max+3
        sta     CANTDSR7

        ; Set data length
        lda     #8
        sta     CANTDLR

        ; Transmit the message
        lda     CANTBSEL
        sta     CANTFLG

        rts

SendMsg2
        ; Select first buffer
        lda     CANTFLG
        sta     CANTBSEL

        ; Set ID
        lda     #$C7
        sta     CANTIDR0
        lda     #$FE
        sta     CANTIDR1
        lda     #$05
        sta     CANTIDR2
        lda     #$32
        sta     CANTIDR3
        
        ; Set message data
        lda     <adc_vals_min+4
        sta     CANTDSR0
        lda     <adc_vals_min+5
        sta     CANTDSR1

        lda     <adc_vals_max+4
        sta     CANTDSR2
        lda     <adc_vals_max+5
        sta     CANTDSR3
        
        lda     <adc_vals_min+6
        sta     CANTDSR4
        lda     <adc_vals_min+7
        sta     CANTDSR5

        lda     <adc_vals_max+6
        sta     CANTDSR6
        lda     <adc_vals_max+7
        sta     CANTDSR7

        ; Set data length
        lda     #8
        sta     CANTDLR

        ; Transmit the message
        lda     CANTBSEL
        sta     CANTFLG

        rts

SendMsg3
        ; Select first buffer
        lda     CANTFLG
        sta     CANTBSEL

        ; Set ID
        lda     #$C7
        sta     CANTIDR0
        lda     #$FE
        sta     CANTIDR1
        lda     #$07
        sta     CANTIDR2
        lda     #$32
        sta     CANTIDR3
        
        ; Set message data
        lda     <adc_vals_min+8
        sta     CANTDSR0
        lda     <adc_vals_min+9
        sta     CANTDSR1

        lda     <adc_vals_max+8
        sta     CANTDSR2
        lda     <adc_vals_max+9
        sta     CANTDSR3
        

        lda     <adc_vals_min+10
        sta     CANTDSR4
        lda     <adc_vals_min+11
        sta     CANTDSR5

;        lda     <meascntmax+0
        lda     <adc_vals_max+10
        sta     CANTDSR6
;        lda     <meascntmax+1
        lda     <adc_vals_max+11
        sta     CANTDSR7

        ; Set data length
        lda     #8
        sta     CANTDLR

        ; Transmit the message
        lda     CANTBSEL
        sta     CANTFLG

        rts

; ===================== IT VECTORS =============================================
#VECTORS
        
        


; ====================  VARIABLES  =============================================
#RAM

led_timer       ds      1       ; Timer for flash status LED


; ===================== Sub-Routines ==========================================
#ROM

; ------------------------------------------------------------------------------
; Real-Time Counter (S08RTCV1)
; This is periodic timer. (Like PIT in AZ60, TBM in GZ60 in the past) 
;  - Select external clock (RTCLKS = 1)
;  - Use interrupt to handle software timer variables (RTIE = 1)
;  - RTCPS = 11 (10^4 means 4MHz/10000 = 400Hz)
;  - RTCMOD = 3 (400Hz/4 = 100Hz -> 10ms)
; This will result 250ms periodic interrupt.
RTC_Init
        ; Set up registers
        mov     #RTIE_|RTCLKS0_|11,RTCSC
        mov     #3,RTCMOD

        mov     #50,led_timer
        
        rts

; RTC periodic interrupt service routine, hits in every 250ms
; This is used to flash status LED.
RTC_IT
        bset    RTIF.,RTCSC     ; Clear flag

        ; Handle Status LED
        dec     led_timer
        bne     RTC_IT_noledtime
        lda     LED2
        eor     #LED2_
        sta     LED2     
        mov     #50,led_timer
RTC_IT_noledtime
        jsr     SendMsg1
        jsr     SendMsg2
        jsr     SendMsg3
        clr     meascnt
        clr     meascnt+1
        jsr     ADC_Clear
RTC_IT_end
        rti
        

; ===================== IT VECTORS ==========================================
#VECTORS

        org     Vrtc
        dw      RTC_IT



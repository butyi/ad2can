; ====================  VARIABLES  =============================================
#RAM

adc_vals_min    ds      12
adc_vals_max    ds      12

; ===================== SUB-ROUTINES ===========================================
#ROM

; ADC module initialization
ADC_Init        
        ; Set first 5 PTA pins to analogue input
        mov     #$3F,APCTL1
        ; ADLPC = 0 (High speed config)
        ; ADIV = 00b (input clock / 1)
        ; ADLSMP = 1 (Long sample time) maybe filter out noise pulses
        ; MODE = 01b (12 bit mode)
        ; ADICLK = 00b (Bus clock divided by 1)
        mov     #ADLSMP_|MODE0_,ADCCFG
        rts
        



; Read ADC value non-interrupt way. X select the channel to be read.  
ADC_read
        stx     ADCSC1
ADC_read_loop
        jsr     KickCop
        brclr   COCO.,ADCSC1,ADC_read_loop
        rts                     ; Ready, value is on ADCRL

ADC_Clear
        clr     adc_vals_max+0
        clr     adc_vals_max+1

        clr     adc_vals_max+2
        clr     adc_vals_max+3

        clr     adc_vals_max+4
        clr     adc_vals_max+5

        clr     adc_vals_max+6
        clr     adc_vals_max+7

        clr     adc_vals_max+8
        clr     adc_vals_max+9

        clr     adc_vals_max+10
        clr     adc_vals_max+11

        lda     #$FF
        sta     adc_vals_min+0
        sta     adc_vals_min+1

        sta     adc_vals_min+2
        sta     adc_vals_min+3

        sta     adc_vals_min+4
        sta     adc_vals_min+5

        sta     adc_vals_min+6
        sta     adc_vals_min+7

        sta     adc_vals_min+8
        sta     adc_vals_min+9

        sta     adc_vals_min+10
        sta     adc_vals_min+11

        rts

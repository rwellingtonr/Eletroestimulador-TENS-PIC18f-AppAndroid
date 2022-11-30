
_VDelay_us:

;TCC.c,38 :: 		void VDelay_us(unsigned time_us){
;TCC.c,40 :: 		n_cyc = Clock_MHz()>>2;
	MOVLW       12
	MOVWF       VDelay_us_n_cyc_L0+0 
	MOVLW       0
	MOVWF       VDelay_us_n_cyc_L0+1 
;TCC.c,41 :: 		n_cyc *= time_us>>4;
	MOVF        FARG_VDelay_us_time_us+0, 0 
	MOVWF       R0 
	MOVF        FARG_VDelay_us_time_us+1, 0 
	MOVWF       R1 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	MOVLW       12
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	MOVWF       VDelay_us_n_cyc_L0+0 
	MOVF        R1, 0 
	MOVWF       VDelay_us_n_cyc_L0+1 
;TCC.c,42 :: 		while (n_cyc--) {
L_VDelay_us0:
	MOVF        VDelay_us_n_cyc_L0+0, 0 
	MOVWF       R0 
	MOVF        VDelay_us_n_cyc_L0+1, 0 
	MOVWF       R1 
	MOVLW       1
	SUBWF       VDelay_us_n_cyc_L0+0, 1 
	MOVLW       0
	SUBWFB      VDelay_us_n_cyc_L0+1, 1 
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_VDelay_us1
;TCC.c,43 :: 		asm nop;
	NOP
;TCC.c,44 :: 		asm nop;
	NOP
;TCC.c,45 :: 		asm nop;
	NOP
;TCC.c,46 :: 		}
	GOTO        L_VDelay_us0
L_VDelay_us1:
;TCC.c,47 :: 		}
L_end_VDelay_us:
	RETURN      0
; end of _VDelay_us

_limpa:

;TCC.c,51 :: 		void limpa()
;TCC.c,53 :: 		char msg[18]=""; // string that have to be parsed
;TCC.c,54 :: 		char tempo[20]="", freq[20]="", pulso[20]="", periodo[20]="", off[20]="";
;TCC.c,56 :: 		int freqint=120, pulsoint=250, temp=20, k;
;TCC.c,57 :: 		float pulsofloat, periodofloat, offfloat, freqfloat=120.0;
;TCC.c,58 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;TCC.c,59 :: 		}
L_end_limpa:
	RETURN      0
; end of _limpa

_sinal:

;TCC.c,63 :: 		void sinal()
;TCC.c,65 :: 		while (UART1_Data_Ready() == 0 && stop==1)
L_sinal2:
	CALL        _UART1_Data_Ready+0, 0
	MOVF        R0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_sinal3
	BTFSS       RB7_bit+0, BitPos(RB7_bit+0) 
	GOTO        L_sinal3
L__sinal113:
;TCC.c,67 :: 		cvrcon = 0xee; //POS
	MOVLW       238
	MOVWF       CVRCON+0 
;TCC.c,68 :: 		Vdelay_us (pulsofloat);
	MOVF        _pulsofloat+0, 0 
	MOVWF       R0 
	MOVF        _pulsofloat+1, 0 
	MOVWF       R1 
	MOVF        _pulsofloat+2, 0 
	MOVWF       R2 
	MOVF        _pulsofloat+3, 0 
	MOVWF       R3 
	CALL        _double2word+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_VDelay_us_time_us+0 
	MOVF        R1, 0 
	MOVWF       FARG_VDelay_us_time_us+1 
	CALL        _VDelay_us+0, 0
;TCC.c,69 :: 		cvrcon = 0xe0;   //NEG
	MOVLW       224
	MOVWF       CVRCON+0 
;TCC.c,70 :: 		Vdelay_us (pulsofloat);
	MOVF        _pulsofloat+0, 0 
	MOVWF       R0 
	MOVF        _pulsofloat+1, 0 
	MOVWF       R1 
	MOVF        _pulsofloat+2, 0 
	MOVWF       R2 
	MOVF        _pulsofloat+3, 0 
	MOVWF       R3 
	CALL        _double2word+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_VDelay_us_time_us+0 
	MOVF        R1, 0 
	MOVWF       FARG_VDelay_us_time_us+1 
	CALL        _VDelay_us+0, 0
;TCC.c,71 :: 		cvrcon = 0xe7;   // METADE = 0V
	MOVLW       231
	MOVWF       CVRCON+0 
;TCC.c,72 :: 		Vdelay_us (offfloat);
	MOVF        _offfloat+0, 0 
	MOVWF       R0 
	MOVF        _offfloat+1, 0 
	MOVWF       R1 
	MOVF        _offfloat+2, 0 
	MOVWF       R2 
	MOVF        _offfloat+3, 0 
	MOVWF       R3 
	CALL        _double2word+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_VDelay_us_time_us+0 
	MOVF        R1, 0 
	MOVWF       FARG_VDelay_us_time_us+1 
	CALL        _VDelay_us+0, 0
;TCC.c,74 :: 		if (UART1_Data_Ready() == 1)
	CALL        _UART1_Data_Ready+0, 0
	MOVF        R0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_sinal6
;TCC.c,76 :: 		y=1,x1=1; // define as variaveis para configuracao do BLUETOOTH ligado
	MOVLW       1
	MOVWF       _y+0 
	MOVLW       1
	MOVWF       _x1+0 
;TCC.c,77 :: 		delay_ms(200);
	MOVLW       13
	MOVWF       R11, 0
	MOVLW       45
	MOVWF       R12, 0
	MOVLW       215
	MOVWF       R13, 0
L_sinal7:
	DECFSZ      R13, 1, 1
	BRA         L_sinal7
	DECFSZ      R12, 1, 1
	BRA         L_sinal7
	DECFSZ      R11, 1, 1
	BRA         L_sinal7
	NOP
	NOP
;TCC.c,78 :: 		return;
	GOTO        L_end_sinal
;TCC.c,79 :: 		}
L_sinal6:
;TCC.c,80 :: 		if (stop==0 && sel==1)
	BTFSC       RB7_bit+0, BitPos(RB7_bit+0) 
	GOTO        L_sinal10
	MOVF        _sel+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_sinal10
L__sinal112:
;TCC.c,82 :: 		y=1,x1=1; // define as variaveis para configuracao do BLUETOOTH ligado
	MOVLW       1
	MOVWF       _y+0 
	MOVLW       1
	MOVWF       _x1+0 
;TCC.c,83 :: 		delay_ms(30);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       212
	MOVWF       R12, 0
	MOVLW       133
	MOVWF       R13, 0
L_sinal11:
	DECFSZ      R13, 1, 1
	BRA         L_sinal11
	DECFSZ      R12, 1, 1
	BRA         L_sinal11
	DECFSZ      R11, 1, 1
	BRA         L_sinal11
;TCC.c,84 :: 		UART1_Write_Text("off");
	MOVLW       ?lstr1_TCC+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr1_TCC+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;TCC.c,85 :: 		delay_ms(200);
	MOVLW       13
	MOVWF       R11, 0
	MOVLW       45
	MOVWF       R12, 0
	MOVLW       215
	MOVWF       R13, 0
L_sinal12:
	DECFSZ      R13, 1, 1
	BRA         L_sinal12
	DECFSZ      R12, 1, 1
	BRA         L_sinal12
	DECFSZ      R11, 1, 1
	BRA         L_sinal12
	NOP
	NOP
;TCC.c,86 :: 		return;
	GOTO        L_end_sinal
;TCC.c,87 :: 		}
L_sinal10:
;TCC.c,89 :: 		if (stop==0 && sel==0) //caso cancele com stop e tenha vindo do manual - volta para o manual
	BTFSC       RB7_bit+0, BitPos(RB7_bit+0) 
	GOTO        L_sinal15
	MOVF        _sel+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_sinal15
L__sinal111:
;TCC.c,91 :: 		y=0,x0=1; // define as variaveis para configuracao do aplicativo ligado
	CLRF        _y+0 
	MOVLW       1
	MOVWF       _x0+0 
;TCC.c,92 :: 		delay_ms(30);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       212
	MOVWF       R12, 0
	MOVLW       133
	MOVWF       R13, 0
L_sinal16:
	DECFSZ      R13, 1, 1
	BRA         L_sinal16
	DECFSZ      R12, 1, 1
	BRA         L_sinal16
	DECFSZ      R11, 1, 1
	BRA         L_sinal16
;TCC.c,93 :: 		UART1_Write_Text("off");
	MOVLW       ?lstr2_TCC+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr2_TCC+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;TCC.c,94 :: 		delay_ms(200);
	MOVLW       13
	MOVWF       R11, 0
	MOVLW       45
	MOVWF       R12, 0
	MOVLW       215
	MOVWF       R13, 0
L_sinal17:
	DECFSZ      R13, 1, 1
	BRA         L_sinal17
	DECFSZ      R12, 1, 1
	BRA         L_sinal17
	DECFSZ      R11, 1, 1
	BRA         L_sinal17
	NOP
	NOP
;TCC.c,95 :: 		return;
	GOTO        L_end_sinal
;TCC.c,96 :: 		}
L_sinal15:
;TCC.c,97 :: 		}
	GOTO        L_sinal2
L_sinal3:
;TCC.c,98 :: 		}
L_end_sinal:
	RETURN      0
; end of _sinal

_Display:

;TCC.c,102 :: 		void Display()
;TCC.c,104 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;TCC.c,107 :: 		FloatToStr_FixLen(periodofloat/1000, periodo, 5); //(converte 8330000us em 8.33 ms)
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       122
	MOVWF       R6 
	MOVLW       136
	MOVWF       R7 
	MOVF        _periodofloat+0, 0 
	MOVWF       R0 
	MOVF        _periodofloat+1, 0 
	MOVWF       R1 
	MOVF        _periodofloat+2, 0 
	MOVWF       R2 
	MOVF        _periodofloat+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_FloatToStr_FixLen_fnum+0 
	MOVF        R1, 0 
	MOVWF       FARG_FloatToStr_FixLen_fnum+1 
	MOVF        R2, 0 
	MOVWF       FARG_FloatToStr_FixLen_fnum+2 
	MOVF        R3, 0 
	MOVWF       FARG_FloatToStr_FixLen_fnum+3 
	MOVLW       _periodo+0
	MOVWF       FARG_FloatToStr_FixLen_str+0 
	MOVLW       hi_addr(_periodo+0)
	MOVWF       FARG_FloatToStr_FixLen_str+1 
	MOVLW       5
	MOVWF       FARG_FloatToStr_FixLen_len+0 
	CALL        _FloatToStr_FixLen+0, 0
;TCC.c,108 :: 		FloatToStr_FixLen(offfloat/1000, off, 5);         //(converte 7833333uS em 7.83mS)
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       122
	MOVWF       R6 
	MOVLW       136
	MOVWF       R7 
	MOVF        _offfloat+0, 0 
	MOVWF       R0 
	MOVF        _offfloat+1, 0 
	MOVWF       R1 
	MOVF        _offfloat+2, 0 
	MOVWF       R2 
	MOVF        _offfloat+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_FloatToStr_FixLen_fnum+0 
	MOVF        R1, 0 
	MOVWF       FARG_FloatToStr_FixLen_fnum+1 
	MOVF        R2, 0 
	MOVWF       FARG_FloatToStr_FixLen_fnum+2 
	MOVF        R3, 0 
	MOVWF       FARG_FloatToStr_FixLen_fnum+3 
	MOVLW       _off+0
	MOVWF       FARG_FloatToStr_FixLen_str+0 
	MOVLW       hi_addr(_off+0)
	MOVWF       FARG_FloatToStr_FixLen_str+1 
	MOVLW       5
	MOVWF       FARG_FloatToStr_FixLen_len+0 
	CALL        _FloatToStr_FixLen+0, 0
;TCC.c,110 :: 		Lcd_Out(1,1,"Frequencia: ");   Lcd_Out(1,11,freq);      Lcd_Out(1,18,"Hz");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr3_TCC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr3_TCC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       11
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _freq+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_freq+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       18
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr4_TCC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr4_TCC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;TCC.c,111 :: 		Lcd_Out(2,1,"Pulso: ");        Lcd_Out(2,11,pulso);     Lcd_Out(2,18,"us");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr5_TCC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr5_TCC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       11
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _pulso+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_pulso+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       18
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr6_TCC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr6_TCC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;TCC.c,112 :: 		Lcd_Out(3,1,"Periodo: ");      Lcd_Out(3,13,periodo);   Lcd_Out(3,18,"ms");
	MOVLW       3
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr7_TCC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr7_TCC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	MOVLW       3
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       13
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _periodo+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_periodo+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	MOVLW       3
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       18
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr8_TCC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr8_TCC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;TCC.c,113 :: 		Lcd_Out(4,1,"off: ");          Lcd_Out(4,13,off);       Lcd_Out(4,18,"ms");
	MOVLW       4
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr9_TCC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr9_TCC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	MOVLW       4
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       13
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _off+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_off+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	MOVLW       4
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       18
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr10_TCC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr10_TCC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;TCC.c,114 :: 		}
L_end_Display:
	RETURN      0
; end of _Display

_calculos:

;TCC.c,118 :: 		void calculos()
;TCC.c,122 :: 		periodofloat =  1. / freqint;             //periodo = 1/freq = 1/250 = 0.00833 segundos
	MOVF        _freqint+0, 0 
	MOVWF       R0 
	MOVF        _freqint+1, 0 
	MOVWF       R1 
	CALL        _int2double+0, 0
	MOVF        R0, 0 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       R5 
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
	MOVLW       0
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVLW       0
	MOVWF       R2 
	MOVLW       127
	MOVWF       R3 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _periodofloat+0 
	MOVF        R1, 0 
	MOVWF       _periodofloat+1 
	MOVF        R2, 0 
	MOVWF       _periodofloat+2 
	MOVF        R3, 0 
	MOVWF       _periodofloat+3 
;TCC.c,123 :: 		periodofloat = periodofloat * 1000000;    //Converte para uS = 833000000 us
	MOVLW       0
	MOVWF       R4 
	MOVLW       36
	MOVWF       R5 
	MOVLW       116
	MOVWF       R6 
	MOVLW       146
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__calculos+0 
	MOVF        R1, 0 
	MOVWF       FLOC__calculos+1 
	MOVF        R2, 0 
	MOVWF       FLOC__calculos+2 
	MOVF        R3, 0 
	MOVWF       FLOC__calculos+3 
	MOVF        FLOC__calculos+0, 0 
	MOVWF       _periodofloat+0 
	MOVF        FLOC__calculos+1, 0 
	MOVWF       _periodofloat+1 
	MOVF        FLOC__calculos+2, 0 
	MOVWF       _periodofloat+2 
	MOVF        FLOC__calculos+3, 0 
	MOVWF       _periodofloat+3 
;TCC.c,124 :: 		pulsofloat = pulsoint-53;                 //salva o valor do pulso *int na variavel de pulso *float - ctd de correcao
	MOVLW       53
	SUBWF       _pulsoint+0, 0 
	MOVWF       R0 
	MOVLW       0
	SUBWFB      _pulsoint+1, 0 
	MOVWF       R1 
	CALL        _int2double+0, 0
	MOVF        R0, 0 
	MOVWF       _pulsofloat+0 
	MOVF        R1, 0 
	MOVWF       _pulsofloat+1 
	MOVF        R2, 0 
	MOVWF       _pulsofloat+2 
	MOVF        R3, 0 
	MOVWF       _pulsofloat+3 
;TCC.c,125 :: 		offfloat = (periodofloat) - (2*pulsoint); ///off = periodo - (2*pulso) = 8330000us - 2*250us = 7833333uS
	MOVF        _pulsoint+0, 0 
	MOVWF       R0 
	MOVF        _pulsoint+1, 0 
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	CALL        _int2double+0, 0
	MOVF        R0, 0 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       R5 
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
	MOVF        FLOC__calculos+0, 0 
	MOVWF       R0 
	MOVF        FLOC__calculos+1, 0 
	MOVWF       R1 
	MOVF        FLOC__calculos+2, 0 
	MOVWF       R2 
	MOVF        FLOC__calculos+3, 0 
	MOVWF       R3 
	CALL        _Sub_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _offfloat+0 
	MOVF        R1, 0 
	MOVWF       _offfloat+1 
	MOVF        R2, 0 
	MOVWF       _offfloat+2 
	MOVF        R3, 0 
	MOVWF       _offfloat+3 
;TCC.c,127 :: 		}
L_end_calculos:
	RETURN      0
; end of _calculos

_receive:

;TCC.c,131 :: 		void receive()
;TCC.c,133 :: 		UART1_Read_Text(msg, "!", 20); //le a msg inteira até o !
	MOVLW       _msg+0
	MOVWF       FARG_UART1_Read_Text_Output+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_UART1_Read_Text_Output+1 
	MOVLW       ?lstr11_TCC+0
	MOVWF       FARG_UART1_Read_Text_Delimiter+0 
	MOVLW       hi_addr(?lstr11_TCC+0)
	MOVWF       FARG_UART1_Read_Text_Delimiter+1 
	MOVLW       20
	MOVWF       FARG_UART1_Read_Text_Attempts+0 
	CALL        _UART1_Read_Text+0, 0
;TCC.c,134 :: 		delay_ms(10);
	MOVLW       156
	MOVWF       R12, 0
	MOVLW       215
	MOVWF       R13, 0
L_receive18:
	DECFSZ      R13, 1, 1
	BRA         L_receive18
	DECFSZ      R12, 1, 1
	BRA         L_receive18
;TCC.c,135 :: 		set = strstr(msg,"on"); //caso tenha a informaçao de on na msg ele faz o proximo if
	MOVLW       _msg+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr12_TCC+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr12_TCC+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	MOVWF       _set+0 
	MOVF        R1, 0 
	MOVWF       _set+1 
;TCC.c,136 :: 		if (set != 0)
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__receive120
	MOVLW       0
	XORWF       R0, 0 
L__receive120:
	BTFSC       STATUS+0, 2 
	GOTO        L_receive19
;TCC.c,139 :: 		strcpy(tempo, strtok(msg , ";"));
	MOVLW       _msg+0
	MOVWF       FARG_strtok_s1+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_strtok_s1+1 
	MOVLW       ?lstr13_TCC+0
	MOVWF       FARG_strtok_s2+0 
	MOVLW       hi_addr(?lstr13_TCC+0)
	MOVWF       FARG_strtok_s2+1 
	CALL        _strtok+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strcpy_from+0 
	MOVF        R1, 0 
	MOVWF       FARG_strcpy_from+1 
	MOVLW       _tempo+0
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(_tempo+0)
	MOVWF       FARG_strcpy_to+1 
	CALL        _strcpy+0, 0
;TCC.c,140 :: 		strcpy(freq, strtok(0, ";"));
	CLRF        FARG_strtok_s1+0 
	CLRF        FARG_strtok_s1+1 
	MOVLW       ?lstr14_TCC+0
	MOVWF       FARG_strtok_s2+0 
	MOVLW       hi_addr(?lstr14_TCC+0)
	MOVWF       FARG_strtok_s2+1 
	CALL        _strtok+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strcpy_from+0 
	MOVF        R1, 0 
	MOVWF       FARG_strcpy_from+1 
	MOVLW       _freq+0
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(_freq+0)
	MOVWF       FARG_strcpy_to+1 
	CALL        _strcpy+0, 0
;TCC.c,141 :: 		strcpy(pulso , strtok(0, ";"));
	CLRF        FARG_strtok_s1+0 
	CLRF        FARG_strtok_s1+1 
	MOVLW       ?lstr15_TCC+0
	MOVWF       FARG_strtok_s2+0 
	MOVLW       hi_addr(?lstr15_TCC+0)
	MOVWF       FARG_strtok_s2+1 
	CALL        _strtok+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strcpy_from+0 
	MOVF        R1, 0 
	MOVWF       FARG_strcpy_from+1 
	MOVLW       _pulso+0
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(_pulso+0)
	MOVWF       FARG_strcpy_to+1 
	CALL        _strcpy+0, 0
;TCC.c,144 :: 		freqint = atol (freq);         //  Salva o *char freq na variavel *int freqint
	MOVLW       _freq+0
	MOVWF       FARG_atol_s+0 
	MOVLW       hi_addr(_freq+0)
	MOVWF       FARG_atol_s+1 
	CALL        _atol+0, 0
	MOVF        R0, 0 
	MOVWF       _freqint+0 
	MOVF        R1, 0 
	MOVWF       _freqint+1 
;TCC.c,145 :: 		pulsoint = atol (pulso);       //  Salva o *char pulso na variavel *int  pulsoint
	MOVLW       _pulso+0
	MOVWF       FARG_atol_s+0 
	MOVLW       hi_addr(_pulso+0)
	MOVWF       FARG_atol_s+1 
	CALL        _atol+0, 0
	MOVF        R0, 0 
	MOVWF       _pulsoint+0 
	MOVF        R1, 0 
	MOVWF       _pulsoint+1 
;TCC.c,148 :: 		calculos();
	CALL        _calculos+0, 0
;TCC.c,149 :: 		Display();
	CALL        _Display+0, 0
;TCC.c,150 :: 		sinal();
	CALL        _sinal+0, 0
;TCC.c,151 :: 		return;
	GOTO        L_end_receive
;TCC.c,152 :: 		}
L_receive19:
;TCC.c,153 :: 		set = strstr(msg,"off"); //caso tenha a informaçao de off na msg ele faz o proximo if
	MOVLW       _msg+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr16_TCC+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr16_TCC+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	MOVWF       _set+0 
	MOVF        R1, 0 
	MOVWF       _set+1 
;TCC.c,154 :: 		if (set != 0)
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__receive121
	MOVLW       0
	XORWF       R0, 0 
L__receive121:
	BTFSC       STATUS+0, 2 
	GOTO        L_receive20
;TCC.c,156 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;TCC.c,157 :: 		Lcd_Out(2,1,"   TERAPIA ENCERRADA  ");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr17_TCC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr17_TCC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;TCC.c,158 :: 		}
L_receive20:
;TCC.c,159 :: 		}
L_end_receive:
	RETURN      0
; end of _receive

_move:

;TCC.c,163 :: 		void move()
;TCC.c,165 :: 		if(b==0) //QUANDO A OPÇAO DO BOTAO NAO ESTA ACIONADA ELE SO NAVEGA ENTRE DUAS OPÇÕES (BOTAO / BLUETOOTH)
	MOVF        _b+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_move21
;TCC.c,167 :: 		if(down==0)
	BTFSC       RB5_bit+0, BitPos(RB5_bit+0) 
	GOTO        L_move22
;TCC.c,169 :: 		y++;
	INCF        _y+0, 1 
;TCC.c,170 :: 		if(y>1)y=0;
	MOVLW       128
	XORLW       1
	MOVWF       R0 
	MOVLW       128
	XORWF       _y+0, 0 
	SUBWF       R0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_move23
	CLRF        _y+0 
L_move23:
;TCC.c,171 :: 		while(down==0);
L_move24:
	BTFSC       RB5_bit+0, BitPos(RB5_bit+0) 
	GOTO        L_move25
	GOTO        L_move24
L_move25:
;TCC.c,172 :: 		}
L_move22:
;TCC.c,173 :: 		if(up==0)
	BTFSC       RB4_bit+0, BitPos(RB4_bit+0) 
	GOTO        L_move26
;TCC.c,175 :: 		y--;
	DECF        _y+0, 1 
;TCC.c,176 :: 		if(y<0)y=1;
	MOVLW       128
	XORWF       _y+0, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       0
	SUBWF       R0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_move27
	MOVLW       1
	MOVWF       _y+0 
L_move27:
;TCC.c,177 :: 		while(up==0);
L_move28:
	BTFSC       RB4_bit+0, BitPos(RB4_bit+0) 
	GOTO        L_move29
	GOTO        L_move28
L_move29:
;TCC.c,178 :: 		}
L_move26:
;TCC.c,179 :: 		}
L_move21:
;TCC.c,180 :: 		if(b==1) //QUANDO ELA ESTA ACIONADA ELE NAVEGA ENTRE 3 (BOTAO / FREQ / PULSO)
	MOVF        _b+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_move30
;TCC.c,182 :: 		if(down==0)
	BTFSC       RB5_bit+0, BitPos(RB5_bit+0) 
	GOTO        L_move31
;TCC.c,184 :: 		y++;
	INCF        _y+0, 1 
;TCC.c,185 :: 		if(y>3)y=0;
	MOVLW       128
	XORLW       3
	MOVWF       R0 
	MOVLW       128
	XORWF       _y+0, 0 
	SUBWF       R0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_move32
	CLRF        _y+0 
L_move32:
;TCC.c,186 :: 		if(y==1)y=2;
	MOVF        _y+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_move33
	MOVLW       2
	MOVWF       _y+0 
L_move33:
;TCC.c,187 :: 		while(down==0);
L_move34:
	BTFSC       RB5_bit+0, BitPos(RB5_bit+0) 
	GOTO        L_move35
	GOTO        L_move34
L_move35:
;TCC.c,188 :: 		}
L_move31:
;TCC.c,189 :: 		if(up==0)
	BTFSC       RB4_bit+0, BitPos(RB4_bit+0) 
	GOTO        L_move36
;TCC.c,191 :: 		y--;
	DECF        _y+0, 1 
;TCC.c,192 :: 		if(y<0)y=3;
	MOVLW       128
	XORWF       _y+0, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       0
	SUBWF       R0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_move37
	MOVLW       3
	MOVWF       _y+0 
L_move37:
;TCC.c,193 :: 		if(y==1)y=0;
	MOVF        _y+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_move38
	CLRF        _y+0 
L_move38:
;TCC.c,194 :: 		while(up==0);
L_move39:
	BTFSC       RB4_bit+0, BitPos(RB4_bit+0) 
	GOTO        L_move40
	GOTO        L_move39
L_move40:
;TCC.c,195 :: 		}
L_move36:
;TCC.c,196 :: 		}
L_move30:
;TCC.c,197 :: 		}
L_end_move:
	RETURN      0
; end of _move

_iniciar:

;TCC.c,201 :: 		void iniciar()
;TCC.c,203 :: 		if(start == 0)
	BTFSC       RB7_bit+0, BitPos(RB7_bit+0) 
	GOTO        L_iniciar41
;TCC.c,205 :: 		while(start==0);
L_iniciar42:
	BTFSC       RB7_bit+0, BitPos(RB7_bit+0) 
	GOTO        L_iniciar43
	GOTO        L_iniciar42
L_iniciar43:
;TCC.c,206 :: 		calculos();                                  //Realiza os calculos de periodo e off
	CALL        _calculos+0, 0
;TCC.c,207 :: 		Display();                                   //exibe os dados no display
	CALL        _Display+0, 0
;TCC.c,208 :: 		FloatToStr_FixLen(pulsofloat+27, pulso, 3);  //Converte o pulso float em char para exibir no display
	MOVF        _pulsofloat+0, 0 
	MOVWF       R0 
	MOVF        _pulsofloat+1, 0 
	MOVWF       R1 
	MOVF        _pulsofloat+2, 0 
	MOVWF       R2 
	MOVF        _pulsofloat+3, 0 
	MOVWF       R3 
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       88
	MOVWF       R6 
	MOVLW       131
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_FloatToStr_FixLen_fnum+0 
	MOVF        R1, 0 
	MOVWF       FARG_FloatToStr_FixLen_fnum+1 
	MOVF        R2, 0 
	MOVWF       FARG_FloatToStr_FixLen_fnum+2 
	MOVF        R3, 0 
	MOVWF       FARG_FloatToStr_FixLen_fnum+3 
	MOVLW       _pulso+0
	MOVWF       FARG_FloatToStr_FixLen_str+0 
	MOVLW       hi_addr(_pulso+0)
	MOVWF       FARG_FloatToStr_FixLen_str+1 
	MOVLW       3
	MOVWF       FARG_FloatToStr_FixLen_len+0 
	CALL        _FloatToStr_FixLen+0, 0
;TCC.c,209 :: 		freqfloat = freqint;                         // define freqfloat como freqint
	MOVF        _freqint+0, 0 
	MOVWF       R0 
	MOVF        _freqint+1, 0 
	MOVWF       R1 
	CALL        _int2double+0, 0
	MOVF        R0, 0 
	MOVWF       _freqfloat+0 
	MOVF        R1, 0 
	MOVWF       _freqfloat+1 
	MOVF        R2, 0 
	MOVWF       _freqfloat+2 
	MOVF        R3, 0 
	MOVWF       _freqfloat+3 
;TCC.c,210 :: 		FloatToStr_FixLen(freqfloat, freq, 3);       //Converte o freq float em char para exibir no display
	MOVF        R0, 0 
	MOVWF       FARG_FloatToStr_FixLen_fnum+0 
	MOVF        R1, 0 
	MOVWF       FARG_FloatToStr_FixLen_fnum+1 
	MOVF        R2, 0 
	MOVWF       FARG_FloatToStr_FixLen_fnum+2 
	MOVF        R3, 0 
	MOVWF       FARG_FloatToStr_FixLen_fnum+3 
	MOVLW       _freq+0
	MOVWF       FARG_FloatToStr_FixLen_str+0 
	MOVLW       hi_addr(_freq+0)
	MOVWF       FARG_FloatToStr_FixLen_str+1 
	MOVLW       3
	MOVWF       FARG_FloatToStr_FixLen_len+0 
	CALL        _FloatToStr_FixLen+0, 0
;TCC.c,211 :: 		UART1_Write_Text("on");delay_ms(100);        //envia sinal de on para o app
	MOVLW       ?lstr18_TCC+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr18_TCC+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
	MOVLW       7
	MOVWF       R11, 0
	MOVLW       23
	MOVWF       R12, 0
	MOVLW       106
	MOVWF       R13, 0
L_iniciar44:
	DECFSZ      R13, 1, 1
	BRA         L_iniciar44
	DECFSZ      R12, 1, 1
	BRA         L_iniciar44
	DECFSZ      R11, 1, 1
	BRA         L_iniciar44
	NOP
;TCC.c,212 :: 		sinal();                                     // vai para rotina gerar a onda
	CALL        _sinal+0, 0
;TCC.c,213 :: 		limpa();                                     // quando volta limpa as variaveis
	CALL        _limpa+0, 0
;TCC.c,214 :: 		}
L_iniciar41:
;TCC.c,215 :: 		}
L_end_iniciar:
	RETURN      0
; end of _iniciar

_fre:

;TCC.c,219 :: 		void fre()
;TCC.c,221 :: 		move();
	CALL        _move+0, 0
;TCC.c,222 :: 		iniciar();
	CALL        _iniciar+0, 0
;TCC.c,223 :: 		Lcd_Out(2,1," Botoes:   Ligado   ");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr19_TCC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr19_TCC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;TCC.c,224 :: 		Lcd_Out(3,1,">Frequ:             ");Lcd_Out(3,8,freq);Lcd_Out(3,18,"Hz");
	MOVLW       3
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr20_TCC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr20_TCC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	MOVLW       3
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       8
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _freq+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_freq+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	MOVLW       3
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       18
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr21_TCC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr21_TCC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;TCC.c,225 :: 		Lcd_Out(4,1," Pulso:             ");Lcd_Out(4,8,pulso);Lcd_Out(4,18,"us");
	MOVLW       4
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr22_TCC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr22_TCC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	MOVLW       4
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       8
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _pulso+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_pulso+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	MOVLW       4
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       18
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr23_TCC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr23_TCC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;TCC.c,229 :: 		if (enter==0)
	BTFSC       RB6_bit+0, BitPos(RB6_bit+0) 
	GOTO        L_fre47
;TCC.c,231 :: 		Lcd_Out(3,1," Freque: >");Lcd_Out(3,8,freq);Lcd_Out(3,18,"Hz");
	MOVLW       3
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr24_TCC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr24_TCC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	MOVLW       3
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       8
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _freq+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_freq+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	MOVLW       3
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       18
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr25_TCC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr25_TCC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;TCC.c,232 :: 		while(enter==0);
L_fre48:
	BTFSC       RB6_bit+0, BitPos(RB6_bit+0) 
	GOTO        L_fre49
	GOTO        L_fre48
L_fre49:
;TCC.c,233 :: 		while(1)
L_fre50:
;TCC.c,235 :: 		if(up==0)
	BTFSC       RB4_bit+0, BitPos(RB4_bit+0) 
	GOTO        L_fre52
;TCC.c,237 :: 		freqint=freqint+10;
	MOVLW       10
	ADDWF       _freqint+0, 0 
	MOVWF       R1 
	MOVLW       0
	ADDWFC      _freqint+1, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       _freqint+0 
	MOVF        R2, 0 
	MOVWF       _freqint+1 
;TCC.c,238 :: 		if (freqint>250){freqint=20;}
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       R2, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__fre125
	MOVF        R1, 0 
	SUBLW       250
L__fre125:
	BTFSC       STATUS+0, 0 
	GOTO        L_fre53
	MOVLW       20
	MOVWF       _freqint+0 
	MOVLW       0
	MOVWF       _freqint+1 
L_fre53:
;TCC.c,239 :: 		delay_ms(200);
	MOVLW       13
	MOVWF       R11, 0
	MOVLW       45
	MOVWF       R12, 0
	MOVLW       215
	MOVWF       R13, 0
L_fre54:
	DECFSZ      R13, 1, 1
	BRA         L_fre54
	DECFSZ      R12, 1, 1
	BRA         L_fre54
	DECFSZ      R11, 1, 1
	BRA         L_fre54
	NOP
	NOP
;TCC.c,240 :: 		}
L_fre52:
;TCC.c,241 :: 		if(down==0)
	BTFSC       RB5_bit+0, BitPos(RB5_bit+0) 
	GOTO        L_fre55
;TCC.c,243 :: 		freqint=freqint-10;
	MOVLW       10
	SUBWF       _freqint+0, 0 
	MOVWF       R1 
	MOVLW       0
	SUBWFB      _freqint+1, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       _freqint+0 
	MOVF        R2, 0 
	MOVWF       _freqint+1 
;TCC.c,244 :: 		if (freqint<20){freqint=250;}
	MOVLW       128
	XORWF       R2, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__fre126
	MOVLW       20
	SUBWF       R1, 0 
L__fre126:
	BTFSC       STATUS+0, 0 
	GOTO        L_fre56
	MOVLW       250
	MOVWF       _freqint+0 
	MOVLW       0
	MOVWF       _freqint+1 
L_fre56:
;TCC.c,245 :: 		delay_ms(200);
	MOVLW       13
	MOVWF       R11, 0
	MOVLW       45
	MOVWF       R12, 0
	MOVLW       215
	MOVWF       R13, 0
L_fre57:
	DECFSZ      R13, 1, 1
	BRA         L_fre57
	DECFSZ      R12, 1, 1
	BRA         L_fre57
	DECFSZ      R11, 1, 1
	BRA         L_fre57
	NOP
	NOP
;TCC.c,246 :: 		}
L_fre55:
;TCC.c,247 :: 		if(enter==0)
	BTFSC       RB6_bit+0, BitPos(RB6_bit+0) 
	GOTO        L_fre58
;TCC.c,249 :: 		while(enter==0);
L_fre59:
	BTFSC       RB6_bit+0, BitPos(RB6_bit+0) 
	GOTO        L_fre60
	GOTO        L_fre59
L_fre60:
;TCC.c,250 :: 		break;
	GOTO        L_fre51
;TCC.c,251 :: 		}
L_fre58:
;TCC.c,252 :: 		IntToStr(freqint, freq);     //int - char
	MOVF        _freqint+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _freqint+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _freq+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_freq+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;TCC.c,253 :: 		Lcd_Out(3,1," Frequ: >");Lcd_Out(3,8,freq);Lcd_Out(3,18,"Hz");
	MOVLW       3
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr26_TCC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr26_TCC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	MOVLW       3
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       8
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _freq+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_freq+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	MOVLW       3
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       18
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr27_TCC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr27_TCC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;TCC.c,254 :: 		}
	GOTO        L_fre50
L_fre51:
;TCC.c,255 :: 		}
L_fre47:
;TCC.c,257 :: 		}
L_fre46:
;TCC.c,258 :: 		}
L_end_fre:
	RETURN      0
; end of _fre

_pul:

;TCC.c,262 :: 		void pul()
;TCC.c,264 :: 		move();
	CALL        _move+0, 0
;TCC.c,265 :: 		iniciar();
	CALL        _iniciar+0, 0
;TCC.c,266 :: 		Lcd_Out(2,1," Botoes:   Ligado   ");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr28_TCC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr28_TCC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;TCC.c,267 :: 		Lcd_Out(3,1," Frequ:             ");Lcd_Out(3,8,freq);Lcd_Out(3,18,"Hz");
	MOVLW       3
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr29_TCC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr29_TCC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	MOVLW       3
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       8
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _freq+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_freq+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	MOVLW       3
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       18
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr30_TCC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr30_TCC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;TCC.c,268 :: 		Lcd_Out(4,1,">Pulso:             ");Lcd_Out(4,8,pulso);Lcd_Out(4,18,"us");
	MOVLW       4
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr31_TCC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr31_TCC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	MOVLW       4
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       8
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _pulso+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_pulso+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	MOVLW       4
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       18
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr32_TCC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr32_TCC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;TCC.c,272 :: 		if (enter==0)
	BTFSC       RB6_bit+0, BitPos(RB6_bit+0) 
	GOTO        L_pul63
;TCC.c,274 :: 		Lcd_Out(4,1," Pulso: >");Lcd_Out(4,8,pulsoint);Lcd_Out(4,18,"us");
	MOVLW       4
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr33_TCC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr33_TCC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	MOVLW       4
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       8
	MOVWF       FARG_Lcd_Out_column+0 
	MOVF        _pulsoint+0, 0 
	MOVWF       FARG_Lcd_Out_text+0 
	MOVF        _pulsoint+1, 0 
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	MOVLW       4
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       18
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr34_TCC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr34_TCC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;TCC.c,275 :: 		while(enter==0);
L_pul64:
	BTFSC       RB6_bit+0, BitPos(RB6_bit+0) 
	GOTO        L_pul65
	GOTO        L_pul64
L_pul65:
;TCC.c,276 :: 		while(1)
L_pul66:
;TCC.c,278 :: 		if(up==0)
	BTFSC       RB4_bit+0, BitPos(RB4_bit+0) 
	GOTO        L_pul68
;TCC.c,280 :: 		pulsoint=pulsoint+10;
	MOVLW       10
	ADDWF       _pulsoint+0, 0 
	MOVWF       R1 
	MOVLW       0
	ADDWFC      _pulsoint+1, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       _pulsoint+0 
	MOVF        R2, 0 
	MOVWF       _pulsoint+1 
;TCC.c,281 :: 		if (pulsoint>500){pulsoint=90;}
	MOVLW       128
	XORLW       1
	MOVWF       R0 
	MOVLW       128
	XORWF       R2, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__pul128
	MOVF        R1, 0 
	SUBLW       244
L__pul128:
	BTFSC       STATUS+0, 0 
	GOTO        L_pul69
	MOVLW       90
	MOVWF       _pulsoint+0 
	MOVLW       0
	MOVWF       _pulsoint+1 
L_pul69:
;TCC.c,282 :: 		delay_ms(200);
	MOVLW       13
	MOVWF       R11, 0
	MOVLW       45
	MOVWF       R12, 0
	MOVLW       215
	MOVWF       R13, 0
L_pul70:
	DECFSZ      R13, 1, 1
	BRA         L_pul70
	DECFSZ      R12, 1, 1
	BRA         L_pul70
	DECFSZ      R11, 1, 1
	BRA         L_pul70
	NOP
	NOP
;TCC.c,283 :: 		}
L_pul68:
;TCC.c,284 :: 		if(down==0)
	BTFSC       RB5_bit+0, BitPos(RB5_bit+0) 
	GOTO        L_pul71
;TCC.c,286 :: 		pulsoint=pulsoint-10;
	MOVLW       10
	SUBWF       _pulsoint+0, 0 
	MOVWF       R1 
	MOVLW       0
	SUBWFB      _pulsoint+1, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       _pulsoint+0 
	MOVF        R2, 0 
	MOVWF       _pulsoint+1 
;TCC.c,287 :: 		if (pulsoint<90){pulsoint=500;}
	MOVLW       128
	XORWF       R2, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__pul129
	MOVLW       90
	SUBWF       R1, 0 
L__pul129:
	BTFSC       STATUS+0, 0 
	GOTO        L_pul72
	MOVLW       244
	MOVWF       _pulsoint+0 
	MOVLW       1
	MOVWF       _pulsoint+1 
L_pul72:
;TCC.c,288 :: 		delay_ms(200);
	MOVLW       13
	MOVWF       R11, 0
	MOVLW       45
	MOVWF       R12, 0
	MOVLW       215
	MOVWF       R13, 0
L_pul73:
	DECFSZ      R13, 1, 1
	BRA         L_pul73
	DECFSZ      R12, 1, 1
	BRA         L_pul73
	DECFSZ      R11, 1, 1
	BRA         L_pul73
	NOP
	NOP
;TCC.c,289 :: 		}
L_pul71:
;TCC.c,290 :: 		if(enter==0)
	BTFSC       RB6_bit+0, BitPos(RB6_bit+0) 
	GOTO        L_pul74
;TCC.c,292 :: 		while(enter==0);
L_pul75:
	BTFSC       RB6_bit+0, BitPos(RB6_bit+0) 
	GOTO        L_pul76
	GOTO        L_pul75
L_pul76:
;TCC.c,293 :: 		break;
	GOTO        L_pul67
;TCC.c,294 :: 		}
L_pul74:
;TCC.c,295 :: 		IntToStr(pulsoint,pulso);
	MOVF        _pulsoint+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _pulsoint+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _pulso+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_pulso+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;TCC.c,296 :: 		Lcd_Out(4,1," Pulso: >");Lcd_Out(4,8,pulso);Lcd_Out(4,18,"us");
	MOVLW       4
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr35_TCC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr35_TCC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	MOVLW       4
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       8
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _pulso+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_pulso+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	MOVLW       4
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       18
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr36_TCC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr36_TCC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;TCC.c,297 :: 		}
	GOTO        L_pul66
L_pul67:
;TCC.c,298 :: 		}
L_pul63:
;TCC.c,300 :: 		}
L_pul62:
;TCC.c,301 :: 		}
L_end_pul:
	RETURN      0
; end of _pul

_botao:

;TCC.c,305 :: 		void botao()
;TCC.c,307 :: 		Lcd_Out(1,1,"  SELECIONE O MODO  ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr37_TCC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr37_TCC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;TCC.c,308 :: 		move();
	CALL        _move+0, 0
;TCC.c,309 :: 		if(enter==0)
	BTFSC       RB6_bit+0, BitPos(RB6_bit+0) 
	GOTO        L_botao77
;TCC.c,311 :: 		x0++;
	INCF        _x0+0, 1 
;TCC.c,312 :: 		if(x0>1)x0=0;
	MOVLW       128
	XORLW       1
	MOVWF       R0 
	MOVLW       128
	XORWF       _x0+0, 0 
	SUBWF       R0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_botao78
	CLRF        _x0+0 
L_botao78:
;TCC.c,313 :: 		while(enter==0);
L_botao79:
	BTFSC       RB6_bit+0, BitPos(RB6_bit+0) 
	GOTO        L_botao80
	GOTO        L_botao79
L_botao80:
;TCC.c,314 :: 		}
L_botao77:
;TCC.c,315 :: 		if(x0==0)
	MOVF        _x0+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_botao81
;TCC.c,317 :: 		b=0;
	CLRF        _b+0 
;TCC.c,318 :: 		Lcd_Out(2,1,">Botoes:   Desligado");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr38_TCC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr38_TCC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;TCC.c,319 :: 		Lcd_Out(3,1," Bluetooth:Desligado");
	MOVLW       3
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr39_TCC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr39_TCC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;TCC.c,320 :: 		Lcd_Out(4,1,"                    ");
	MOVLW       4
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr40_TCC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr40_TCC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;TCC.c,321 :: 		}
L_botao81:
;TCC.c,322 :: 		if(x0==1)
	MOVF        _x0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_botao82
;TCC.c,324 :: 		op = 0, sel=0, b=1;
	CLRF        _op+0 
	CLRF        _sel+0 
	MOVLW       1
	MOVWF       _b+0 
;TCC.c,325 :: 		IntToStr(freqint,freq); //int - char
	MOVF        _freqint+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _freqint+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _freq+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_freq+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;TCC.c,326 :: 		IntToStr(pulsoint,pulso); //int -> char
	MOVF        _pulsoint+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _pulsoint+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _pulso+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_pulso+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;TCC.c,327 :: 		Lcd_Out(2,1,">Botoes:   Ligado   ");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr41_TCC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr41_TCC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;TCC.c,328 :: 		Lcd_Out(3,1," Frequ:             "); Lcd_Out(3,8,freq); Lcd_Out(3,18,"Hz");
	MOVLW       3
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr42_TCC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr42_TCC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	MOVLW       3
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       8
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _freq+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_freq+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	MOVLW       3
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       18
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr43_TCC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr43_TCC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;TCC.c,329 :: 		Lcd_Out(4,1," Pulso:             "); Lcd_Out(4,8,pulso);Lcd_Out(4,18,"us");
	MOVLW       4
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr44_TCC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr44_TCC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	MOVLW       4
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       8
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _pulso+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_pulso+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	MOVLW       4
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       18
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr45_TCC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr45_TCC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;TCC.c,330 :: 		iniciar();
	CALL        _iniciar+0, 0
;TCC.c,332 :: 		}
L_botao82:
;TCC.c,333 :: 		}
L_end_botao:
	RETURN      0
; end of _botao

_bluetooth:

;TCC.c,337 :: 		void bluetooth()
;TCC.c,340 :: 		Lcd_Out(1,1,"  SELECIONE O MODO  ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr46_TCC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr46_TCC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;TCC.c,341 :: 		move();
	CALL        _move+0, 0
;TCC.c,343 :: 		if(enter==0)
	BTFSC       RB6_bit+0, BitPos(RB6_bit+0) 
	GOTO        L_bluetooth83
;TCC.c,345 :: 		x1++;
	INCF        _x1+0, 1 
;TCC.c,346 :: 		if(x1>1)x1=0;
	MOVLW       128
	XORLW       1
	MOVWF       R0 
	MOVLW       128
	XORWF       _x1+0, 0 
	SUBWF       R0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_bluetooth84
	CLRF        _x1+0 
L_bluetooth84:
;TCC.c,347 :: 		while(enter==0);
L_bluetooth85:
	BTFSC       RB6_bit+0, BitPos(RB6_bit+0) 
	GOTO        L_bluetooth86
	GOTO        L_bluetooth85
L_bluetooth86:
;TCC.c,348 :: 		}
L_bluetooth83:
;TCC.c,350 :: 		if(x1==0)
	MOVF        _x1+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_bluetooth87
;TCC.c,352 :: 		Lcd_Out(2,1," Botoes:   Desligado");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr47_TCC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr47_TCC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;TCC.c,353 :: 		Lcd_Out(3,1,">Bluetooth:Desligado");
	MOVLW       3
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr48_TCC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr48_TCC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;TCC.c,354 :: 		Lcd_Out(4,1,"                    ");
	MOVLW       4
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr49_TCC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr49_TCC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;TCC.c,355 :: 		}
L_bluetooth87:
;TCC.c,357 :: 		if(x1==1)
	MOVF        _x1+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_bluetooth88
;TCC.c,359 :: 		sel=1;
	MOVLW       1
	MOVWF       _sel+0 
;TCC.c,360 :: 		Lcd_Out(2,1," Botoes:   Desligado");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr50_TCC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr50_TCC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;TCC.c,361 :: 		Lcd_Out(3,1,">Bluetooth:Ligado   ");
	MOVLW       3
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr51_TCC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr51_TCC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;TCC.c,362 :: 		Lcd_Out(4,1," Aguardando Dados...");
	MOVLW       4
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr52_TCC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr52_TCC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;TCC.c,364 :: 		while (1)
L_bluetooth89:
;TCC.c,366 :: 		if(enter==0)
	BTFSC       RB6_bit+0, BitPos(RB6_bit+0) 
	GOTO        L_bluetooth91
;TCC.c,368 :: 		x1++;
	INCF        _x1+0, 1 
;TCC.c,369 :: 		if(x1>1)x1=0;
	MOVLW       128
	XORLW       1
	MOVWF       R0 
	MOVLW       128
	XORWF       _x1+0, 0 
	SUBWF       R0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_bluetooth92
	CLRF        _x1+0 
L_bluetooth92:
;TCC.c,370 :: 		while(enter==0);
L_bluetooth93:
	BTFSC       RB6_bit+0, BitPos(RB6_bit+0) 
	GOTO        L_bluetooth94
	GOTO        L_bluetooth93
L_bluetooth94:
;TCC.c,371 :: 		break;
	GOTO        L_bluetooth90
;TCC.c,372 :: 		}
L_bluetooth91:
;TCC.c,373 :: 		if (UART1_Data_Ready() == 1) // CASO RECEBA ALGUM DADO ELE VAI PARA ROTINA DE RECEBIMENTO
	CALL        _UART1_Data_Ready+0, 0
	MOVF        R0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_bluetooth95
;TCC.c,375 :: 		if(enter==0)
	BTFSC       RB6_bit+0, BitPos(RB6_bit+0) 
	GOTO        L_bluetooth96
;TCC.c,377 :: 		x1++;
	INCF        _x1+0, 1 
;TCC.c,378 :: 		if(x1>1)x1=0;
	MOVLW       128
	XORLW       1
	MOVWF       R0 
	MOVLW       128
	XORWF       _x1+0, 0 
	SUBWF       R0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_bluetooth97
	CLRF        _x1+0 
L_bluetooth97:
;TCC.c,379 :: 		while(enter==0);
L_bluetooth98:
	BTFSC       RB6_bit+0, BitPos(RB6_bit+0) 
	GOTO        L_bluetooth99
	GOTO        L_bluetooth98
L_bluetooth99:
;TCC.c,380 :: 		break;
	GOTO        L_bluetooth90
;TCC.c,381 :: 		}
L_bluetooth96:
;TCC.c,382 :: 		receive();
	CALL        _receive+0, 0
;TCC.c,383 :: 		limpa();
	CALL        _limpa+0, 0
;TCC.c,384 :: 		break;
	GOTO        L_bluetooth90
;TCC.c,385 :: 		}
L_bluetooth95:
;TCC.c,386 :: 		}
	GOTO        L_bluetooth89
L_bluetooth90:
;TCC.c,387 :: 		}
L_bluetooth88:
;TCC.c,388 :: 		}
L_end_bluetooth:
	RETURN      0
; end of _bluetooth

_main:

;TCC.c,392 :: 		void main() //ROTINA PRINCIPAL
;TCC.c,394 :: 		delay_ms(200);                  // Delay para estabilizar
	MOVLW       13
	MOVWF       R11, 0
	MOVLW       45
	MOVWF       R12, 0
	MOVLW       215
	MOVWF       R13, 0
L_main100:
	DECFSZ      R13, 1, 1
	BRA         L_main100
	DECFSZ      R12, 1, 1
	BRA         L_main100
	DECFSZ      R11, 1, 1
	BRA         L_main100
	NOP
	NOP
;TCC.c,395 :: 		CMCON = 0x07;                   //Desabilita os comparadores
	MOVLW       7
	MOVWF       CMCON+0 
;TCC.c,396 :: 		ADCON0 = 0x00;                  //Desabilita os conversores AD
	CLRF        ADCON0+0 
;TCC.c,397 :: 		ADCON1 = 0X0F;                  // Torna todo ADC Digital
	MOVLW       15
	MOVWF       ADCON1+0 
;TCC.c,398 :: 		cvrcon = 0xe0;                  //SAIDA ANALOGICA NO MAXIMO
	MOVLW       224
	MOVWF       CVRCON+0 
;TCC.c,400 :: 		TRISD=0x00;                     // define a porta d como saída
	CLRF        TRISD+0 
;TCC.c,401 :: 		TRISB=0XF0;                     // define a porta b0-3 como saida (0) e b4-7 como entrada (1) (11110000)
	MOVLW       240
	MOVWF       TRISB+0 
;TCC.c,403 :: 		PORTB = 0X00;
	CLRF        PORTB+0 
;TCC.c,405 :: 		UART1_Init(9600);               // Initialize UART module at 9600 bps
	BSF         BAUDCON+0, 3, 0
	MOVLW       4
	MOVWF       SPBRGH+0 
	MOVLW       225
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;TCC.c,406 :: 		Delay_ms(100);                  // Wait for UART module to stabilize
	MOVLW       7
	MOVWF       R11, 0
	MOVLW       23
	MOVWF       R12, 0
	MOVLW       106
	MOVWF       R13, 0
L_main101:
	DECFSZ      R13, 1, 1
	BRA         L_main101
	DECFSZ      R12, 1, 1
	BRA         L_main101
	DECFSZ      R11, 1, 1
	BRA         L_main101
	NOP
;TCC.c,408 :: 		Lcd_Init();                        // Initialize LCD
	CALL        _Lcd_Init+0, 0
;TCC.c,409 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;TCC.c,410 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;TCC.c,413 :: 		delay_ms(100);
	MOVLW       7
	MOVWF       R11, 0
	MOVLW       23
	MOVWF       R12, 0
	MOVLW       106
	MOVWF       R13, 0
L_main102:
	DECFSZ      R13, 1, 1
	BRA         L_main102
	DECFSZ      R12, 1, 1
	BRA         L_main102
	DECFSZ      R11, 1, 1
	BRA         L_main102
	NOP
;TCC.c,415 :: 		while(1)
L_main103:
;TCC.c,417 :: 		switch(y)
	GOTO        L_main105
;TCC.c,419 :: 		case 0: botao();
L_main107:
	CALL        _botao+0, 0
;TCC.c,420 :: 		break;
	GOTO        L_main106
;TCC.c,422 :: 		case 1: bluetooth();
L_main108:
	CALL        _bluetooth+0, 0
;TCC.c,423 :: 		break;
	GOTO        L_main106
;TCC.c,425 :: 		case 2: fre();
L_main109:
	CALL        _fre+0, 0
;TCC.c,426 :: 		break;
	GOTO        L_main106
;TCC.c,428 :: 		case 3: pul();
L_main110:
	CALL        _pul+0, 0
;TCC.c,429 :: 		break;
	GOTO        L_main106
;TCC.c,430 :: 		}
L_main105:
	MOVF        _y+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_main107
	MOVF        _y+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_main108
	MOVF        _y+0, 0 
	XORLW       2
	BTFSC       STATUS+0, 2 
	GOTO        L_main109
	MOVF        _y+0, 0 
	XORLW       3
	BTFSC       STATUS+0, 2 
	GOTO        L_main110
L_main106:
;TCC.c,431 :: 		}
	GOTO        L_main103
;TCC.c,432 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

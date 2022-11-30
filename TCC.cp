#line 1 "D:/OneDrive/Documentos/Faculdade/10º Semestre/TCC/mikroC/LCD/TCC.c"

sbit LCD_RS at RD2_bit;
sbit LCD_EN at RD3_bit;
sbit LCD_D4 at RD4_bit;
sbit LCD_D5 at RD5_bit;
sbit LCD_D6 at RD6_bit;
sbit LCD_D7 at RD7_bit;

sbit LCD_RS_Direction at TRISD2_bit;
sbit LCD_EN_Direction at TRISD3_bit;
sbit LCD_D4_Direction at TRISD4_bit;
sbit LCD_D5_Direction at TRISD5_bit;
sbit LCD_D6_Direction at TRISD6_bit;
sbit LCD_D7_Direction at TRISD7_bit;
#line 28 "D:/OneDrive/Documentos/Faculdade/10º Semestre/TCC/mikroC/LCD/TCC.c"
char msg[18], output[20];
char tempo[20], freq[20], pulso[20], periodo[20], off[20];
char *set;
int freqint=120, pulsoint=250, k;
float pulsofloat=251, periodofloat, offfloat, freqfloat=121;
short y=0, x0=0,x1=0, op=0, sel=0,b=0;




void VDelay_us(unsigned time_us){
 unsigned n_cyc;
 n_cyc = Clock_MHz()>>2;
 n_cyc *= time_us>>4;
 while (n_cyc--) {
 asm nop;
 asm nop;
 asm nop;
 }
}



void limpa()
{
 char msg[18]="";
 char tempo[20]="", freq[20]="", pulso[20]="", periodo[20]="", off[20]="";
 char *set;
 int freqint=120, pulsoint=250, temp=20, k;
 float pulsofloat, periodofloat, offfloat, freqfloat=120.0;
 Lcd_Cmd(_LCD_CLEAR);
}



void sinal()
{
 while (UART1_Data_Ready() == 0 &&  rb7_bit ==1)
 {
 cvrcon = 0xee;
 Vdelay_us (pulsofloat);
 cvrcon = 0xe0;
 Vdelay_us (pulsofloat);
 cvrcon = 0xe7;
 Vdelay_us (offfloat);

 if (UART1_Data_Ready() == 1)
 {
 y=1,x1=1;
 delay_ms(200);
 return;
 }
 if ( rb7_bit ==0 && sel==1)
 {
 y=1,x1=1;
 delay_ms(30);
 UART1_Write_Text("off");
 delay_ms(200);
 return;
 }

 if ( rb7_bit ==0 && sel==0)
 {
 y=0,x0=1;
 delay_ms(30);
 UART1_Write_Text("off");
 delay_ms(200);
 return;
 }
 }
}



void Display()
{
 Lcd_Cmd(_LCD_CLEAR);


 FloatToStr_FixLen(periodofloat/1000, periodo, 5);
 FloatToStr_FixLen(offfloat/1000, off, 5);

 Lcd_Out(1,1,"Frequencia: "); Lcd_Out(1,11,freq); Lcd_Out(1,18,"Hz");
 Lcd_Out(2,1,"Pulso: "); Lcd_Out(2,11,pulso); Lcd_Out(2,18,"us");
 Lcd_Out(3,1,"Periodo: "); Lcd_Out(3,13,periodo); Lcd_Out(3,18,"ms");
 Lcd_Out(4,1,"off: "); Lcd_Out(4,13,off); Lcd_Out(4,18,"ms");
}



void calculos()
{


 periodofloat = 1. / freqint;
 periodofloat = periodofloat * 1000000;
 pulsofloat = pulsoint-53;
 offfloat = (periodofloat) - (2*pulsoint);

}



void receive()
{
 UART1_Read_Text(msg, "!", 20);
 delay_ms(10);
 set = strstr(msg,"on");
 if (set != 0)
 {

 strcpy(tempo, strtok(msg , ";"));
 strcpy(freq, strtok(0, ";"));
 strcpy(pulso , strtok(0, ";"));


 freqint = atol (freq);
 pulsoint = atol (pulso);


 calculos();
 Display();
 sinal();
 return;
 }
 set = strstr(msg,"off");
 if (set != 0)
 {
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(2,1,"   TERAPIA ENCERRADA  ");
 }
}



void move()
{
 if(b==0)
 {
 if( rb5_bit ==0)
 {
 y++;
 if(y>1)y=0;
 while( rb5_bit ==0);
 }
 if( rb4_bit ==0)
 {
 y--;
 if(y<0)y=1;
 while( rb4_bit ==0);
 }
 }
 if(b==1)
 {
 if( rb5_bit ==0)
 {
 y++;
 if(y>3)y=0;
 if(y==1)y=2;
 while( rb5_bit ==0);
 }
 if( rb4_bit ==0)
 {
 y--;
 if(y<0)y=3;
 if(y==1)y=0;
 while( rb4_bit ==0);
 }
 }
}



void iniciar()
{
 if( rb7_bit  == 0)
 {
 while( rb7_bit ==0);
 calculos();
 Display();
 FloatToStr_FixLen(pulsofloat+27, pulso, 3);
 freqfloat = freqint;
 FloatToStr_FixLen(freqfloat, freq, 3);
 UART1_Write_Text("on");delay_ms(100);
 sinal();
 limpa();
 }
}



void fre()
 {
 move();
 iniciar();
 Lcd_Out(2,1," Botoes:   Ligado   ");
 Lcd_Out(3,1,">Frequ:             ");Lcd_Out(3,8,freq);Lcd_Out(3,18,"Hz");
 Lcd_Out(4,1," Pulso:             ");Lcd_Out(4,8,pulso);Lcd_Out(4,18,"us");

 while(1)
 {
 if ( rb6_bit ==0)
 {
 Lcd_Out(3,1," Freque: >");Lcd_Out(3,8,freq);Lcd_Out(3,18,"Hz");
 while( rb6_bit ==0);
 while(1)
 {
 if( rb4_bit ==0)
 {
 freqint=freqint+10;
 if (freqint>250){freqint=20;}
 delay_ms(200);
 }
 if( rb5_bit ==0)
 {
 freqint=freqint-10;
 if (freqint<20){freqint=250;}
 delay_ms(200);
 }
 if( rb6_bit ==0)
 {
 while( rb6_bit ==0);
 break;
 }
 IntToStr(freqint, freq);
 Lcd_Out(3,1," Frequ: >");Lcd_Out(3,8,freq);Lcd_Out(3,18,"Hz");
 }
 }
 break;
 }
 }



void pul()
 {
 move();
 iniciar();
 Lcd_Out(2,1," Botoes:   Ligado   ");
 Lcd_Out(3,1," Frequ:             ");Lcd_Out(3,8,freq);Lcd_Out(3,18,"Hz");
 Lcd_Out(4,1,">Pulso:             ");Lcd_Out(4,8,pulso);Lcd_Out(4,18,"us");

 while(1)
 {
 if ( rb6_bit ==0)
 {
 Lcd_Out(4,1," Pulso: >");Lcd_Out(4,8,pulsoint);Lcd_Out(4,18,"us");
 while( rb6_bit ==0);
 while(1)
 {
 if( rb4_bit ==0)
 {
 pulsoint=pulsoint+10;
 if (pulsoint>500){pulsoint=90;}
 delay_ms(200);
 }
 if( rb5_bit ==0)
 {
 pulsoint=pulsoint-10;
 if (pulsoint<90){pulsoint=500;}
 delay_ms(200);
 }
 if( rb6_bit ==0)
 {
 while( rb6_bit ==0);
 break;
 }
 IntToStr(pulsoint,pulso);
 Lcd_Out(4,1," Pulso: >");Lcd_Out(4,8,pulso);Lcd_Out(4,18,"us");
 }
 }
 break;
 }
 }



void botao()
{
 Lcd_Out(1,1,"  SELECIONE O MODO  ");
 move();
 if( rb6_bit ==0)
 {
 x0++;
 if(x0>1)x0=0;
 while( rb6_bit ==0);
 }
 if(x0==0)
 {
 b=0;
 Lcd_Out(2,1,">Botoes:   Desligado");
 Lcd_Out(3,1," Bluetooth:Desligado");
 Lcd_Out(4,1,"                    ");
 }
 if(x0==1)
 {
 op = 0, sel=0, b=1;
 IntToStr(freqint,freq);
 IntToStr(pulsoint,pulso);
 Lcd_Out(2,1,">Botoes:   Ligado   ");
 Lcd_Out(3,1," Frequ:             "); Lcd_Out(3,8,freq); Lcd_Out(3,18,"Hz");
 Lcd_Out(4,1," Pulso:             "); Lcd_Out(4,8,pulso);Lcd_Out(4,18,"us");
 iniciar();

 }
}



void bluetooth()
{

 Lcd_Out(1,1,"  SELECIONE O MODO  ");
 move();

 if( rb6_bit ==0)
 {
 x1++;
 if(x1>1)x1=0;
 while( rb6_bit ==0);
 }

 if(x1==0)
 {
 Lcd_Out(2,1," Botoes:   Desligado");
 Lcd_Out(3,1,">Bluetooth:Desligado");
 Lcd_Out(4,1,"                    ");
 }

 if(x1==1)
 {
 sel=1;
 Lcd_Out(2,1," Botoes:   Desligado");
 Lcd_Out(3,1,">Bluetooth:Ligado   ");
 Lcd_Out(4,1," Aguardando Dados...");

 while (1)
 {
 if( rb6_bit ==0)
 {
 x1++;
 if(x1>1)x1=0;
 while( rb6_bit ==0);
 break;
 }
 if (UART1_Data_Ready() == 1)
 {
 if( rb6_bit ==0)
 {
 x1++;
 if(x1>1)x1=0;
 while( rb6_bit ==0);
 break;
 }
 receive();
 limpa();
 break;
 }
 }
 }
}



void main()
{
 delay_ms(200);
 CMCON = 0x07;
 ADCON0 = 0x00;
 ADCON1 = 0X0F;
 cvrcon = 0xe0;

 TRISD=0x00;
 TRISB=0XF0;

 PORTB = 0X00;

 UART1_Init(9600);
 Delay_ms(100);

 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);


 delay_ms(100);

 while(1)
 {
 switch(y)
 {
 case 0: botao();
 break;

 case 1: bluetooth();
 break;

 case 2: fre();
 break;

 case 3: pul();
 break;
 }
 }
}

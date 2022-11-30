// LCD module connections
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
// End LCD module connections

/*========================================================================*/

#define up      rb4_bit
#define down    rb5_bit
#define enter   rb6_bit
#define start   rb7_bit
#define stop    rb7_bit

/*========================================================================*/
// criação das variaveis

char msg[18], output[20]; // string that have to be parsed
char tempo[20], freq[20], pulso[20], periodo[20], off[20];
char *set;
int freqint=120, pulsoint=250, k;
float pulsofloat=251, periodofloat, offfloat, freqfloat=121;
short y=0, x0=0,x1=0, op=0, sel=0,b=0;

/*========================================================================*/
//ROTINA DELAY EM MICROSEGUNDO

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
/*========================================================================*/
//LIMPAR VARIAVEIS

void limpa()
{
  char msg[18]=""; // string that have to be parsed
  char tempo[20]="", freq[20]="", pulso[20]="", periodo[20]="", off[20]="";
  char *set;
  int freqint=120, pulsoint=250, temp=20, k;
  float pulsofloat, periodofloat, offfloat, freqfloat=120.0;
  Lcd_Cmd(_LCD_CLEAR);               // Clear display
}
/*========================================================================*/
//GERAÇÃO DO SINAL

void sinal()
{
    while (UART1_Data_Ready() == 0 && stop==1)
    {
       cvrcon = 0xee; //POS
       Vdelay_us (pulsofloat);
       cvrcon = 0xe0;   //NEG
       Vdelay_us (pulsofloat);
       cvrcon = 0xe7;   // METADE = 0V
       Vdelay_us (offfloat);

    if (UART1_Data_Ready() == 1)
    {
      y=1,x1=1; // define as variaveis para configuracao do BLUETOOTH ligado
      delay_ms(200);
      return;
    }
    if (stop==0 && sel==1)
    {
      y=1,x1=1; // define as variaveis para configuracao do BLUETOOTH ligado
      delay_ms(30);
      UART1_Write_Text("off");
      delay_ms(200);
      return;
    }

    if (stop==0 && sel==0) //caso cancele com stop e tenha vindo do manual - volta para o manual
    {
      y=0,x0=1; // define as variaveis para configuracao do aplicativo ligado
      delay_ms(30);
      UART1_Write_Text("off");
      delay_ms(200);
      return;
    }
   }
}
/*========================================================================*/
//EXIBIÇÃO DOS VALORES DO DISPLAY

void Display()
{
  Lcd_Cmd(_LCD_CLEAR);               // Clear display

  //converte em texto novamente para exibir no display
  FloatToStr_FixLen(periodofloat/1000, periodo, 5); //(converte 8330000us em 8.33 ms)
  FloatToStr_FixLen(offfloat/1000, off, 5);         //(converte 7833333uS em 7.83mS)

  Lcd_Out(1,1,"Frequencia: ");   Lcd_Out(1,11,freq);      Lcd_Out(1,18,"Hz");
  Lcd_Out(2,1,"Pulso: ");        Lcd_Out(2,11,pulso);     Lcd_Out(2,18,"us");
  Lcd_Out(3,1,"Periodo: ");      Lcd_Out(3,13,periodo);   Lcd_Out(3,18,"ms");
  Lcd_Out(4,1,"off: ");          Lcd_Out(4,13,off);       Lcd_Out(4,18,"ms");
}
/*========================================================================*/
//TRATAMENTO E CALCULO DE PERIODO E DEADTIME (OFF)

void calculos()
{
  //EXEMPLO freq = 120 pulo=250
  //calculos
  periodofloat =  1. / freqint;             //periodo = 1/freq = 1/250 = 0.00833 segundos
  periodofloat = periodofloat * 1000000;    //Converte para uS = 833000000 us
  pulsofloat = pulsoint-53;                 //salva o valor do pulso *int na variavel de pulso *float - ctd de correcao
  offfloat = (periodofloat) - (2*pulsoint); ///off = periodo - (2*pulso) = 8330000us - 2*250us = 7833333uS

}
/*========================================================================*/
// RECEBIMENTO E TRATAMENTO DOS DADOS

void receive()
{
  UART1_Read_Text(msg, "!", 20); //le a msg inteira até o !
  delay_ms(10);
  set = strstr(msg,"on"); //caso tenha a informaçao de on na msg ele faz o proximo if
  if (set != 0)
   {
    //Salvando nas variaveis
    strcpy(tempo, strtok(msg , ";"));
    strcpy(freq, strtok(0, ";"));
    strcpy(pulso , strtok(0, ";"));

    //Convertendo em int
    freqint = atol (freq);         //  Salva o *char freq na variavel *int freqint
    pulsoint = atol (pulso);       //  Salva o *char pulso na variavel *int  pulsoint
    //temp = atol (tempo);           //  Salva o *char tempo na variavel *int temp

    calculos();
    Display();
    sinal();
    return;
   }
  set = strstr(msg,"off"); //caso tenha a informaçao de off na msg ele faz o proximo if
  if (set != 0)
   {
    Lcd_Cmd(_LCD_CLEAR);               // Clear display
    Lcd_Out(2,1,"   TERAPIA ENCERRADA  ");
   }
}
/*========================================================================*/
//ESCOLHA DAS OPÇÕES UP/DOWN

void move()
{
    if(b==0) //QUANDO A OPÇAO DO BOTAO NAO ESTA ACIONADA ELE SO NAVEGA ENTRE DUAS OPÇÕES (BOTAO / BLUETOOTH)
    {
     if(down==0)
      {
        y++;
        if(y>1)y=0;
        while(down==0);
      }
     if(up==0)
      {
         y--;
         if(y<0)y=1;
         while(up==0);
      }
    }
    if(b==1) //QUANDO ELA ESTA ACIONADA ELE NAVEGA ENTRE 3 (BOTAO / FREQ / PULSO)
    {
     if(down==0)
      {
        y++;
        if(y>3)y=0;
        if(y==1)y=2;
        while(down==0);
      }
     if(up==0)
      {
         y--;
         if(y<0)y=3;
         if(y==1)y=0;
         while(up==0);
      }
    }
}
/*========================================================================*/
//BOTAO START

void iniciar()
{
   if(start == 0)
   {
    while(start==0);
    calculos();                                  //Realiza os calculos de periodo e off
    Display();                                   //exibe os dados no display
    FloatToStr_FixLen(pulsofloat+27, pulso, 3);  //Converte o pulso float em char para exibir no display
    freqfloat = freqint;                         // define freqfloat como freqint
    FloatToStr_FixLen(freqfloat, freq, 3);       //Converte o freq float em char para exibir no display
    UART1_Write_Text("on");delay_ms(100);        //envia sinal de on para o app
    sinal();                                     // vai para rotina gerar a onda
    limpa();                                     // quando volta limpa as variaveis
   }
}
/*========================================================================*/
//FREQUENCIA

void fre()
 {
  move();
  iniciar();
  Lcd_Out(2,1," Botoes:   Ligado   ");
  Lcd_Out(3,1,">Frequ:             ");Lcd_Out(3,8,freq);Lcd_Out(3,18,"Hz");
  Lcd_Out(4,1," Pulso:             ");Lcd_Out(4,8,pulso);Lcd_Out(4,18,"us");
  
  while(1)
   {
     if (enter==0)
     {
      Lcd_Out(3,1," Freque: >");Lcd_Out(3,8,freq);Lcd_Out(3,18,"Hz");
      while(enter==0);
      while(1)
       {
        if(up==0)
         {
          freqint=freqint+10;
          if (freqint>250){freqint=20;}
          delay_ms(200);
         }
        if(down==0)
         {
          freqint=freqint-10;
          if (freqint<20){freqint=250;}
          delay_ms(200);
         }
         if(enter==0)
         {
          while(enter==0);
          break;
         }
          IntToStr(freqint, freq);     //int - char
          Lcd_Out(3,1," Frequ: >");Lcd_Out(3,8,freq);Lcd_Out(3,18,"Hz");
         }
     }
     break;
   }
 }
 /*========================================================================*/
// PULSO

void pul()
 {
  move();
  iniciar();
  Lcd_Out(2,1," Botoes:   Ligado   ");
  Lcd_Out(3,1," Frequ:             ");Lcd_Out(3,8,freq);Lcd_Out(3,18,"Hz");
  Lcd_Out(4,1,">Pulso:             ");Lcd_Out(4,8,pulso);Lcd_Out(4,18,"us");
  
  while(1)
   {
     if (enter==0)
     {
      Lcd_Out(4,1," Pulso: >");Lcd_Out(4,8,pulsoint);Lcd_Out(4,18,"us");
      while(enter==0);
      while(1)
       {
        if(up==0)
         {
          pulsoint=pulsoint+10;
          if (pulsoint>500){pulsoint=90;}
          delay_ms(200);
         }
        if(down==0)
         {
          pulsoint=pulsoint-10;
          if (pulsoint<90){pulsoint=500;}
          delay_ms(200);
         }
         if(enter==0)
         {
          while(enter==0);
          break;
         }
         IntToStr(pulsoint,pulso);
         Lcd_Out(4,1," Pulso: >");Lcd_Out(4,8,pulso);Lcd_Out(4,18,"us");
       }
     }
    break;
   }
 }
 /*========================================================================*/
//OFFILINE (BOTOES)

void botao()
{
  Lcd_Out(1,1,"  SELECIONE O MODO  ");
  move();
  if(enter==0)
   {
     x0++;
     if(x0>1)x0=0;
     while(enter==0);
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
    IntToStr(freqint,freq); //int - char
    IntToStr(pulsoint,pulso); //int -> char
    Lcd_Out(2,1,">Botoes:   Ligado   ");
    Lcd_Out(3,1," Frequ:             "); Lcd_Out(3,8,freq); Lcd_Out(3,18,"Hz");
    Lcd_Out(4,1," Pulso:             "); Lcd_Out(4,8,pulso);Lcd_Out(4,18,"us");
    iniciar();

   }
}
/*========================================================================*/
//BLUETOOTH

void bluetooth()
{   

  Lcd_Out(1,1,"  SELECIONE O MODO  ");
  move();

  if(enter==0)
  {
    x1++;
    if(x1>1)x1=0;
    while(enter==0);
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
      if(enter==0)
        {
          x1++;
          if(x1>1)x1=0;
          while(enter==0);
          break;
        }
      if (UART1_Data_Ready() == 1) // CASO RECEBA ALGUM DADO ELE VAI PARA ROTINA DE RECEBIMENTO
      {
        if(enter==0)
         {
          x1++;
          if(x1>1)x1=0;
          while(enter==0);
          break;
         }
        receive();
        limpa();
        break;
      }
    }
   }
}

/*========================================================================*/

void main() //ROTINA PRINCIPAL
{
  delay_ms(200);                  // Delay para estabilizar
  CMCON = 0x07;                   //Desabilita os comparadores
  ADCON0 = 0x00;                  //Desabilita os conversores AD
  ADCON1 = 0X0F;                  // Torna todo ADC Digital
  cvrcon = 0xe0;                  //SAIDA ANALOGICA NO MAXIMO

  TRISD=0x00;                     // define a porta d como saída
  TRISB=0XF0;                     // define a porta b0-3 como saida (0) e b4-7 como entrada (1) (11110000)

  PORTB = 0X00;

  UART1_Init(9600);               // Initialize UART module at 9600 bps
  Delay_ms(100);                  // Wait for UART module to stabilize

  Lcd_Init();                        // Initialize LCD
  Lcd_Cmd(_LCD_CLEAR);               // Clear display
  Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off


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
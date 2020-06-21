#include <stdio.h>
#include <avr/io.h>
#include <util/delay.h>
#include <inttypes.h>
#include <string.h>

#define LED PB5
#define LED_DDR DDRB
#define LED_PORT PORTB

#define BTN PB4
#define BTN_PIN PINB
#define BTN_PORT PORTB

#define TIMEFRAME 10
#define BUFFER_SIZE 7000 / TIMEFRAME

#define BAUD 9600
#define UBRR_VALUE ((F_CPU)/16/(BAUD)-1)

#define MAX_LINE_SIZE 255
#define MORSE_LINE 3000
#define MORSE_DOT 1000


char* letters[] = {
  ".-",   //a, A
  "-...",  //b, B
  "-.-.", //c, C
  "-..",  //d, D
  ".",    //e, E
  "..-.", //f, F
  "--.",  //g, G
	"....", //h, H
  "..",   //i, I
  ".---", //j, J
  "-.-",  //k, K
  ".-..", //l, L
  "--",   //m, M
	"-.",   //n, N
  "---",  //o, O
  ".--.", //p, P
  "--.-", //q, Q
  ".-.",  //r, R
  "...",  //s, S
  "-",    //t, T
	"..-",  //u, U
  "...-", //v, V
  ".--",  //w, W
  "-..-", //x, X
  "-.--", //y, Y
  "--.."  //z, Z
	};
	
char* digits[] = {"-----",    //0
                  ".----",    //1
                  "..---",    //2
                  "...--",    //3
                  "....-",    //4
                  ".....",    //5
                  "-....",    //6
                  "--...",    //7
                  "---..",    //8
                  "----.",    //9
                  };

char* sos[] = {"...---..."};

char message[9];
int8_t i;

int8_t buffer[BUFFER_SIZE];
int8_t position;

void uart_init()
{
  // ustaw baudrate
  UBRR0 = UBRR_VALUE;
  // wyczyść rejestr UCSR0A
  UCSR0A = 0;
  // włącz odbiornik i nadajnik
  UCSR0B = _BV(RXEN0) | _BV(TXEN0);
  // ustaw format 8n1
  UCSR0C = _BV(UCSZ00) | _BV(UCSZ01);
}

// transmisja jednego znaku
int uart_transmit(char data, FILE *stream)
{
  // czekaj aż transmiter gotowy
  while(!(UCSR0A & _BV(UDRE0)));
  UDR0 = data;
  return 0;
}

// odczyt jednego znaku
int uart_receive(FILE *stream)
{
  // czekaj aż znak dostępny
  while (!(UCSR0A & _BV(RXC0)));
  return UDR0;
}

void print_char_from_morse_seq() {
  char alphanum;
  for (int j=0; j<26; j++)
  {
    if (!(strcmp(letters[j], message)))
    {
      alphanum = j + 97;
      printf("%c", alphanum);
    }
  }
  for (int l=0; l<10; l++)
  {
    if (!(strcmp(digits[l], message)))
    {
      alphanum = l + 48;
      printf("%c", alphanum);
    }
  }
  if (!(strcmp(sos[0], message)))
  {
    printf("SOS");
  }
  //clear message
  for (int k=0; k<9; k++)
  {
    message[k] = 0;
  }
}

FILE uart_file;

int main() {
  // initialize UART
  uart_init();
  // configure iostream
  fdev_setup_stream(&uart_file, uart_transmit, uart_receive, _FDEV_SETUP_RW);
  stdin = stdout = stderr = &uart_file;

  //initialize buffer and fill with zeros
  BTN_PORT |= _BV(BTN);
  LED_DDR |= _BV(LED);

  int16_t signal_in = 0;
  int16_t signal_out = 0;
  int16_t i = 0;

  while(1) {
		if (!(BTN_PIN & _BV(BTN)))
		{
			_delay_ms(1);
			if (!(BTN_PIN & _BV(BTN)))
			{
        break;
      }
    }

  }

  // program exec loop
  while (1) {
  LED_PORT &= ~_BV(LED); //diode disable
	// if button is pushed in this timeframe
  if (BTN_PIN & _BV(BTN))
  {    
    signal_in = 1;
    signal_out++;
  }
  else
  {
    signal_out = 1;
    signal_in++;
  }
  if (signal_in >= 100)
  {
    if (signal_in == 100)
    {
      message[i++] = '.';
      LED_PORT |= _BV(LED); // diode enable
    }

    else if (signal_in == 100 * 3)
    {
      message[--i] = '-';  
      LED_PORT |= _BV(LED); // diode enable
    	_delay_ms(100);
      LED_PORT &= ~_BV(LED); //diode disable
    	_delay_ms(100);
      LED_PORT |= _BV(LED); // diode enable
      i++;    
    }
  }
  else if (signal_out >= 100)
  {
    if (signal_out == 100)
    {
      LED_PORT |= _BV(LED); // diode enable
    }
    else if (signal_out == 300)
    {
      LED_PORT |= _BV(LED); // diode enable
    	_delay_ms(100);
      LED_PORT &= ~_BV(LED); //diode disable
    	_delay_ms(100);
      LED_PORT |= _BV(LED); // diode enable

      message[i++] = '\0';
      print_char_from_morse_seq();
      i = 0;
    }
    else if (signal_out == 700)
    {
      LED_PORT |= _BV(LED); // diode enable
    	_delay_ms(100);
      LED_PORT &= ~_BV(LED); //diode disable
    	_delay_ms(100);
      LED_PORT |= _BV(LED); // diode enable
      LED_PORT |= _BV(LED); // diode enable
    	_delay_ms(100);
      printf(" ");
    }
  }
	_delay_ms(TIMEFRAME);
  }
}



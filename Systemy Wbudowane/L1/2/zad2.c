#include <stdio.h>
#include <avr/io.h>
#include <util/delay.h>
#include <inttypes.h>

#define LED PB5
#define LED_DDR DDRB
#define LED_PORT PORTB

#define BAUD 9600
#define UBRR_VALUE ((F_CPU)/16/(BAUD)-1)

#define MAX_LINE_SIZE 255
#define MORSE_LINE 300
#define MORSE_DOT 100

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

void display_morse_code(char morse_code[])
{
  int8_t i=0;

  while(1)
  { 
    if (morse_code[i] == '-')
    {
    LED_PORT |= _BV(LED);
    _delay_ms(MORSE_LINE);
    LED_PORT &= ~_BV(LED);
    _delay_ms(MORSE_DOT);
    }
    else if (morse_code[i] == '.')
    {
    LED_PORT |= _BV(LED);
    _delay_ms(MORSE_DOT);
    LED_PORT &= ~_BV(LED);
    _delay_ms(MORSE_DOT); //morse code pause = 1 dot off
    }
    else
    {
      break;
    }
    i++;
  }
    _delay_ms(MORSE_DOT * 2); //pause after letter: 3 = 2 + 1 (1 reached from morse code pause)
}

FILE uart_file;
int main() {
  // zainicjalizuj UART
  uart_init();
  // skonfiguruj strumienie wejścia/wyjścia
  fdev_setup_stream(&uart_file, uart_transmit, uart_receive, _FDEV_SETUP_RW);
  stdin = stdout = stderr = &uart_file;
  // włącz diodę
  LED_DDR |= _BV(LED);

  int8_t message[MAX_LINE_SIZE];
  int8_t i;
  while(1)
  {
    i = 0;

    scanf("%[^\r\n]%c", message);
    printf("Odczytano: %s\r\n", message);

    while(message[i] != '\0')
    {
      //sos
      if ((message[0] == 's' && message[1] == 'o' && message[2] == 's') || (message[0] == 'S' && message[1] == 'O' && message[2] == 'S'))
      {
        display_morse_code(sos[0]);
        break;
      }

      //digit
      if (message[i] >= 48 && message[i] <= 57)
      {	
				display_morse_code(digits[message[i] - 48]);
			} 
      //letter
      else if (message[i] >= 65 && message[i] <= 122)
      {
        if (message[i] <= 90) //A-Z
  				display_morse_code(letters[message[i] - 65]);
        else if (message[i] >= 97) //a-z
  				display_morse_code(letters[message[i] - 97]);          
			} 
      else if (message[i] == 32)
      {
        _delay_ms(MORSE_DOT * 4); //3 + 4 = 7 (3 dot pause reached in previous letter)
      }
      i++;
    }
  }
}


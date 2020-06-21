#include <avr/io.h>
#include <stdio.h>
#include <avr/interrupt.h>
#include <avr/sleep.h>
#include <inttypes.h>

#define BAUD 9600                          // baudrate
#define UBRR_VALUE ((F_CPU)/16/(BAUD)-1)   // zgodnie ze wzorem

#define BUFFER_SIZE 100

volatile char buffer_receive[BUFFER_SIZE];
volatile char buffer_transmit[BUFFER_SIZE];

volatile int8_t put_ptr_transmit = 0, put_ptr_receive = 0;
volatile int8_t get_ptr_transmit = 0, get_ptr_receive = 0;

volatile int8_t char_count_in_transmit_buffer = 0;
volatile int8_t char_count_in_receive_buffer = 0;

// inicjalizacja UART
void uart_init()
{
	// ustaw baudrate - liczbe przesylanych bitow w transmisji w 1 sekundzie
	UBRR0 = UBRR_VALUE;
	// wyczyść rejestr UCSR0A
	UCSR0A = 0;
	// włącz odbiornik i nadajnik
	UCSR0B = _BV(RXEN0) | _BV(TXEN0);
	// ustaw format 8n1 - 8 bitów transmitowanych na 1 bit stopu
	UCSR0C = _BV(UCSZ00) | _BV(UCSZ01);
	// wlacz przerwania UART
	UCSR0B |= _BV(RXCIE0);
	//wlacz globalny bit przerwan
	sei();
}


// 1. znaki z wejscia wrzucamy do bufora odbiornika od razu, w przerwaniu
ISR(USART_RX_vect)
{
  volatile char input_char;
  input_char = UDR0;

  buffer_receive[put_ptr_receive] = input_char;
  put_ptr_receive++;

  char_count_in_receive_buffer++;

  if (put_ptr_receive == BUFFER_SIZE)
  {
    put_ptr_receive = 0;
  }

}


// 2. odczyt jednego znaku - czekamy az cos sie pojawi w buforze odbiornika, do ktorego
// znaki wrzuca procedura obslugi przerwania inicjowana w momencie pojawienia sie znakow na stdin
int uart_receive(FILE *stream)
{
  while (char_count_in_receive_buffer == 0);

  volatile char input_char; 
  
  input_char = buffer_receive[get_ptr_receive];
  get_ptr_receive++;

  char_count_in_receive_buffer--;

  if (get_ptr_receive == BUFFER_SIZE)
  {
    get_ptr_receive = 0;
  }
  
  return input_char;
}

// 3. transmisja jednego znaku - poniewaz nie mozemy czekac na gotowosc transmitera,
// to zrzucamy znaki do bufora transmisji
int uart_transmit(char output_char, FILE *stream)
{
  //poczekaj az w buforze bedzie miejsce
  while(char_count_in_transmit_buffer ==  BUFFER_SIZE);

  //wrzuc dane do bufora transmisji
  buffer_transmit[put_ptr_transmit] = output_char;
  put_ptr_transmit++;

  char_count_in_transmit_buffer++;
  
  if (put_ptr_transmit == BUFFER_SIZE)
  {
    put_ptr_transmit = 0;
  }

  //ustaw bit UDRIE0, ze jest cos w buforze transmisji i mozna wysylac na stdout
  UCSR0B |= _BV(UDRIE0); 
  return 0;

}

// 4. ostatni etap - w momencie gotowosci transmitera inicjowane jest to przerwanie i w nim
// zrzucamy znaki z bufora transmisji na stdout
ISR(USART_UDRE_vect)
{
    // weź znak z bufora jeśli coś w nim jest
  if (char_count_in_transmit_buffer > 0) 
  {
    volatile char output_char;
    output_char = buffer_transmit[get_ptr_transmit];
    get_ptr_transmit++;
    
    char_count_in_transmit_buffer--;

    if (get_ptr_transmit == BUFFER_SIZE)
    {
      get_ptr_transmit = 0;
    }

    UDR0 = output_char;

  } 
  // jesli nic nie ma, zablokuj mozliwosc przerywania - dopiero funkcja, ktora cos wrzuci do bufora
  // transmisji to odblokuje
  else 
  {
    UCSR0B &= ~_BV(UDRIE0);
  }

}

FILE uart_file;

int main()
{
  // zainicjalizuj UART
  uart_init();
  // skonfiguruj strumienie wejścia/wyjścia
  fdev_setup_stream(&uart_file, uart_transmit, uart_receive, _FDEV_SETUP_RW);
  stdin = stdout = stderr = &uart_file;
  // program testowy
  sei();
  printf("Hello world\r\n");

  while(1) {
    int16_t a = 1;
    scanf("%"SCNd16, &a);
    printf("Odczytano: %"PRId16"\r\n", a);
  }
}
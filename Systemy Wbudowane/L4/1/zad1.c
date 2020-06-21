#include <avr/io.h>
#include <util/delay.h>
#include <stdio.h>
#include <inttypes.h>

#define BAUD 9600                          // baudrate
#define UBRR_VALUE ((F_CPU)/16/(BAUD)-1)   // zgodnie ze wzorem

// inicjalizacja UART
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


void timer1_init()
{
  TCCR1B = _BV(CS10); // clk I/O /1 (No prescaling)
}

FILE uart_file;


int main()
{
  // zainicjalizuj UART
  uart_init();
  // skonfiguruj strumienie wejścia/wy8jścia
  fdev_setup_stream(&uart_file, uart_transmit, uart_receive, _FDEV_SETUP_RW);
  stdin = stdout = stderr = &uart_file;
  // zainicjalizuj licznik
  timer1_init();
  // program testowy8
  while(1) {
    volatile uint16_t a, b;

    volatile int8_t x8, y8, result8;
    volatile int16_t x16, y16, result16;
    volatile int32_t x32, y32, result32;
    volatile int64_t x64, y64, result64;
    volatile float xf, yf, resultf;

    a = TCNT1; // wartość licznika przed czekaniem
    result8 = x8 + y8;    
    b = TCNT1; // wartość licznika po czekaniu
    printf("Zmierzony czas dodawania dla int8: %"PRIu16" cykli\r\n", b - a);
    _delay_ms(1000);

    a = b = 0;

    a = TCNT1; // wartość licznika przed czekaniem
    result8 = x8 * y8;    
    b = TCNT1; // wartość licznika po czekaniu
    printf("Zmierzony czas mnozenia dla int8: %"PRIu16" cykli\r\n", b - a);
    _delay_ms(1000);

    a = b = 0;

    a = TCNT1; // wartość licznika przed czekaniem
    result8 = x8 / y8;    
    b = TCNT1; // wartość licznika po czekaniu
    printf("Zmierzony czas dzielenia dla int8: %"PRIu16" cykli\r\n", b - a);
    _delay_ms(1000);

    a = TCNT1; // wartość licznika przed czekaniem
    result16 = x16 + y16;    
    b = TCNT1; // wartość licznika po czekaniu
    printf("Zmierzony czas dodawania dla int16: %"PRIu16" cykli\r\n", b - a);
    _delay_ms(1000);

    a = b = 0;

    a = TCNT1; // wartość licznika przed czekaniem
    result16 = x16 * y16;    
    b = TCNT1; // wartość licznika po czekaniu
    printf("Zmierzony czas mnozenia dla int16: %"PRIu16" cykli\r\n", b - a);
    _delay_ms(1000);

    a = b = 0;

    a = TCNT1; // wartość licznika przed czekaniem
    result16 = x16 / y16;    
    b = TCNT1; // wartość licznika po czekaniu
    printf("Zmierzony czas dzielenia dla int16: %"PRIu16" cykli\r\n", b - a);
    _delay_ms(1000);

    a = TCNT1; // wartość licznika przed czekaniem
    result32 = x32 + y32;    
    b = TCNT1; // wartość licznika po czekaniu
    printf("Zmierzony czas dodawania dla int32: %"PRIu16" cykli\r\n", b - a);
    _delay_ms(1000);

    a = b = 0;

    a = TCNT1; // wartość licznika przed czekaniem
    result32 = x32 * y32;    
    b = TCNT1; // wartość licznika po czekaniu
    printf("Zmierzony czas mnozenia dla int32: %"PRIu16" cykli\r\n", b - a);
    _delay_ms(1000);

    a = b = 0;

    a = TCNT1; // wartość licznika przed czekaniem
    result32 = x32 / y32;    
    b = TCNT1; // wartość licznika po czekaniu
    printf("Zmierzony czas dzielenia dla int32: %"PRIu16" cykli\r\n", b - a);
    _delay_ms(1000);

    a = TCNT1; // wartość licznika przed czekaniem
    result64 = x64 + y64;    
    b = TCNT1; // wartość licznika po czekaniu
    printf("Zmierzony czas dodawania dla int64: %"PRIu16" cykli\r\n", b - a);
    _delay_ms(1000);

    a = b = 0;

    a = TCNT1; // wartość licznika przed czekaniem
    result64 = x64 * y64;    
    b = TCNT1; // wartość licznika po czekaniu
    printf("Zmierzony czas mnozenia dla int64: %"PRIu16" cykli\r\n", b - a);
    _delay_ms(1000);

    a = b = 0;

    a = TCNT1; // wartość licznika przed czekaniem
    result64 = x64 / y64;    
    b = TCNT1; // wartość licznika po czekaniu
    printf("Zmierzony czas dzielenia dla int64: %"PRIu16" cykli\r\n", b - a);
    _delay_ms(1000);

    a = TCNT1; // wartość licznika przed czekaniem
    resultf = xf + yf;    
    b = TCNT1; // wartość licznika po czekaniu
    printf("Zmierzony czas dodawania dla float: %"PRIu16" cykli\r\n", b - a);
    _delay_ms(1000);

    a = b = 0;

    a = TCNT1; // wartość licznika przed czekaniem
    resultf = xf * yf;    
    b = TCNT1; // wartość licznika po czekaniu
    printf("Zmierzony czas mnozenia dla float: %"PRIu16" cykli\r\n", b - a);
    _delay_ms(1000);

    a = b = 0;

    a = TCNT1; // wartość licznika przed czekaniem
    resultf = xf / yf;    
    b = TCNT1; // wartość licznika po czekaniu
    printf("Zmierzony czas dzielenia dla float: %"PRIu16" cykli\r\n", b - a);
    _delay_ms(1000);


    _delay_ms(20000);
  }
}


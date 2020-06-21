#include <avr/io.h>
#include <stdio.h>
#include <stdint.h>

#define BAUD 9600
#define UBRR_VALUE ((F_CPU)/16/(BAUD)-1)


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

FILE uart_file;

int main()
{
  // zainicjalizuj UART
  uart_init();
  // skonfiguruj strumienie wejścia/wyjścia
  fdev_setup_stream(&uart_file, uart_transmit, uart_receive, _FDEV_SETUP_RW);
  stdin = stdout = stderr = &uart_file;
  // program testowy 
  int8_t a8, b8;
  int16_t a16, b16;
  int32_t a32, b32;
  int64_t a64, b64;
  float af, bf;

  int8_t s8, m8, d8;
  scanf("%"SCNd8, &a8);
  scanf("%"SCNd8, &b8);
  s8 = a8 + b8;
  m8 = a8 * b8;
  d8 = a8 / b8;
  printf("%"SCNd8, s8);
  printf("%"SCNd8, m8);
  printf("%"SCNd8, d8);

  int16_t s16, m16, d16;
  scanf("%"SCNd16, &a16);
  scanf("%"SCNd16, &b16);
  s16 = a16 + b16;
  m16 = a16 * b16;
  d16 = a16 / b16;
  printf("%"SCNd16, s16);
  printf("%"SCNd16, m16);
  printf("%"SCNd16, d16);


  int32_t s32, m32, d32;
  scanf("%"SCNd32, &a32);
  scanf("%"SCNd32, &b32);
  s32 = a32 + b32;
  m32 = a32 * b32;
  d32 = a32 / b32;
  printf("%"SCNd32, s32);
  printf("%"SCNd32, m32);
  printf("%"SCNd32, d32);


  float sf, mf, df;
  scanf("%f", &af);
  scanf("%f", &bf);
  sf = af + bf;
  mf = af * bf;
  df = af / bf;
  printf("%f", sf);
  printf("%f", mf);
  printf("%f", df);

  int64_t s64, m64, d64;
  scanf("%lld", &a64);
  scanf("%lld", &b64);
  s64 = a64 + b64;
  m64 = a64 * b64;
  d64 = a64 / b64;
  printf("%lld", s64);
  printf("%lld", m64);
  printf("%lld", d64);

}

#include <avr/io.h>
#include <util/delay.h>
#include <stdio.h>
#include <inttypes.h>
#include <math.h>

#define BAUD 9600                             // baudrate
#define UBRR_VALUE ((F_CPU) / 16 / (BAUD)-1)  // zgodnie ze wzorem

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
  while (!(UCSR0A & _BV(UDRE0)));
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

void init_adc() 
{
  ADMUX   = _BV(REFS0) | _BV(REFS1); // referencja AVcc, wejście ADC0
  DIDR0   = _BV(ADC0D); // wyłącz wejście cyfrowe na ADC0
  // częstotliwość zegara ADC 125 kHz (16 MHz / 128)
  ADCSRA  = _BV(ADPS0) | _BV(ADPS1) | _BV(ADPS2); // preskaler 128
  ADCSRA |= _BV(ADEN); // włącz ADC
}

int16_t read_adc() 
{
  ADCSRA |= _BV(ADSC); // wykonaj konwersję
  while (!(ADCSRA & _BV(ADIF))); // czekaj na wynik
  ADCSRA |= _BV(ADIF); // wyczyść bit ADIF (pisząc 1!)
  return (ADC); // zwroc wartosc ADC
}

int main() {
    // zainicjalizuj UART
    uart_init();
    // skonfiguruj strumienie wejścia/wyjścia
    fdev_setup_stream(&uart_file, uart_transmit, uart_receive, _FDEV_SETUP_RW);
    stdin = stdout = stderr = &uart_file;

    init_adc();

    volatile uint16_t adcValue;
    float U, R, T;
    const float KBASE = 273.0, CURTEMP = 22.0 + KBASE;
    const float R0 = 4700.0, Uzas = 1.3;
    const float T0 = 25.0 + KBASE;
    const float B = 6130.35;
    // float B;
    const float I = 0.00013;

    while(1) {
        adcValue = read_adc();
        U = ((float)adcValue / 1024) * Uzas;
        R = U / I;
        T = B / (B / T0 + logf(R / R0));

        printf("Temperatura: %.4f\r\n", T - KBASE);
        printf("Napięcie: %.4f\r\n", U);
        _delay_ms(1000);
    }

}
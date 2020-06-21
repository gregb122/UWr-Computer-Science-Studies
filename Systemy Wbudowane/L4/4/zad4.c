#include <avr/io.h>
#include <util/delay.h>
#include <stdio.h>
#include <inttypes.h>

#define LED PB1
#define LED_DDR DDRB
#define SENSOR PB0
#define LED_IN PB5


#define BAUD 9600							 // baudrate
#define UBRR_VALUE ((F_CPU) / 16 / (BAUD)-1) // zgodnie ze wzorem

////////////////////////////////////////////
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

void initTimer()
{
  // ustaw tryb licznika
  // COM1A = 10   -- non-inverting mode
  // WGM1  = 1110 -- fast PWM top=ICR1
  // CS1   = 101  -- prescaler 1024
  // ICR1  = 15624
  // 16000000 ÷ (1024 × (1 + 52))
  // wzór: datasheet 20.12.3 str. 164
  ICR1 = 52;
  TCCR1A = _BV(COM1A1) | _BV(WGM11);
  TCCR1B = _BV(WGM12) | _BV(WGM13) | _BV(CS11);
  // ustaw pin OC1A (PB1) jako wyjście
  DDRB |= _BV(PB1);
}


int main()
{
	// zainicjalizuj UART
	uart_init();
	// skonfiguruj strumienie wejścia/wyjścia
	fdev_setup_stream(&uart_file, uart_transmit, uart_receive, _FDEV_SETUP_RW);
	stdin = stdout = stderr = &uart_file;

	initTimer();

	LED_DDR |= _BV((LED) | _BV(LED_IN);


	while (1)
	{
		OCR1A = ICR1 / 3;

        if (PINB & _BV(SENSOR))
        {
            PORTB &= ~_BV(LED_IN);            
        }
        else
        {
            PORTB |= _BV(LED_IN);
        }
	}
}
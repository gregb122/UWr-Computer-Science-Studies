#include <avr/io.h>
#include <inttypes.h>
#include <avr/interrupt.h>
#include <avr/sleep.h>

#define BAUD 9600                            // baudrate
#define UBRR_VALUE ((F_CPU) / 16 / (BAUD)-1) // zgodnie ze wzorem

#define MAX_LINE_SIZE 255

volatile char input_char;

char buffer[MAX_LINE_SIZE];
int8_t index = 0;

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
	//wlacz globalny bit
	sei();
}

void transmitByte(uint8_t data) {
	while(!(UCSR0A & _BV(UDRE0))); // aktywne czekanie na USART Data Register Empty Bit w rejestrze UCSR0A
	UDR0 = data;
}

uint8_t receiveByte() {
	while (!(UCSR0A & _BV(RXC0))); // aktywne czekanie na USART Receive Complete Bit w rejestrze UCSR0A
    return UDR0;
}

void echoBuffer()
{
	for (int8_t i=0; i<index; i++)
	{
		transmitByte(buffer[i]);
	}
	transmitByte('\r');
	transmitByte('\n');

	index = 0;
}


ISR(USART_RX_vect)
{
	input_char = receiveByte();

	buffer[index] = input_char;

	index++;

	if(input_char == '\r')
    {
		transmitByte('\n');
		transmitByte(input_char);
		echoBuffer();
    }

	transmitByte(input_char);
}

int main()
{
	uart_init();
	set_sleep_mode(SLEEP_MODE_IDLE);	

	while (1)
	{
		sleep_mode();
	}
}
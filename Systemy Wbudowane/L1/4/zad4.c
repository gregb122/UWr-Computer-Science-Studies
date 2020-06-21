#include <inttypes.h>
#include <avr/io.h>
#include <util/delay.h>

#define LED_DDR DDRD
#define LED_PORT PORTD
#define LED_COUNTDOWN 1000

int main()
{
	LED_DDR  = 0xFF;
	UCSR0B &= ~ _BV ( RXEN0 ) & ~ _BV ( TXEN0 ) ;

	int8_t digits[10] = {
		0b11000000, //0
		0b11111001, //1
		0b10100100, //2
		0b10110000, //3
		0b10011001, //4
		0b10010010, //5
		0b00000010, //6
		0b11111000, //7
		0b10000000, //8
		0b00010000  //9
		};

	//countdown program
	for(int8_t i=9; i>=0; i--)
	{
		LED_PORT = digits[i];
		_delay_ms(LED_COUNTDOWN);
	}
}
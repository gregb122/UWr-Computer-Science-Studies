#include <inttypes.h>
#include <avr/io.h>
#include <util/delay.h>

#define LED_DDR DDRD
#define LED_PORT PORTD
#define LED_DELAY 40

int main()
{
	LED_DDR  = 0xFF;
	LED_PORT = 0x80;
	UCSR0B &= ~ _BV ( RXEN0 ) & ~ _BV ( TXEN0 ) ;

	while (1)
	{
		//ascending
		for (int8_t i=0; i<7; i++)
		{
			_delay_ms(LED_DELAY);
			LED_PORT >>= 1;
		}
		//descending
		for (int8_t j=0; j<7; j++)
		{
			_delay_ms(LED_DELAY);
			LED_PORT <<= 1;
		}
	}
}
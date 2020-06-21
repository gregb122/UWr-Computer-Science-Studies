#include <inttypes.h>
#include <avr/io.h>
#include <util/delay.h>

#define LED_DDR DDRD
#define LED_PORT PORTD
#define LED_COUNTDOWN 1000

#define SWITCHING_TIME 1
#define SWITCH_DDR DDRC
#define SWITCH_PORT PORTC


int main()
{
	LED_DDR  = 0xFF;
	SWITCH_DDR = 0xFF;

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
	int8_t i=0;
	while (1)
	{
		if (i == 60)
		{
			i = 0;
		}
		for(int16_t j=0; j<500; j++)
		{
			_delay_ms(SWITCHING_TIME);
			SWITCH_PORT = 0b00000010;
			LED_PORT = digits[i / 10];
			
			_delay_ms(SWITCHING_TIME);
			SWITCH_PORT = 0b00000001;
			LED_PORT = digits[i % 10];
		}
		i++;
	}
}
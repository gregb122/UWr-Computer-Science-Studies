#include <inttypes.h>
#include <avr/io.h>
#include <util/delay.h>

#define LED_DDR DDRD
#define LED_PORT PORTD

#define BTN_PORT PORTB

#define BTN_A PB4
#define BTN_B PB3
#define BTN_C PB2

#define BTN_PIN PINB

int16_t iterator;

int8_t get_gray_code(int16_t i)
{
	return i ^ (i >> 1);
}

int main()
{
	LED_DDR  = 0xFF;

	BTN_PORT = 0xFF;
	UCSR0B &= ~ _BV ( RXEN0 ) & ~ _BV ( TXEN0 ) ;

	int8_t pushed = 0;
	iterator = 0;
	LED_PORT = 0b00000000;
	while (1)
	{
		if (!(BTN_PIN & _BV(BTN_A)))
		{
			_delay_ms(1);
			//reset
			if (!(BTN_PIN & _BV(BTN_A)))
			{
				pushed = 1;
				LED_PORT = 0b00000000;
				iterator = 0;			
			}
			while(pushed)
			{
				if (BTN_PIN & _BV(BTN_A))	
				{
					_delay_ms(1);
					if (BTN_PIN & _BV(BTN_A))
					{
						pushed = 0;
					}
				}
			}

		}

		else if(!(BTN_PIN & _BV(BTN_B)))
		{
			_delay_ms(1);
			//next
			if(!(BTN_PIN & _BV(BTN_B)))
			{
				pushed = 1;
				iterator++;
				LED_PORT = get_gray_code(iterator);
			}
			while(pushed)
			{
				if (BTN_PIN & _BV(BTN_B))	
				{
					_delay_ms(1);
					if (BTN_PIN & _BV(BTN_B))
					{
						pushed = 0;
					}
				}
			}

		}

		else if(!(BTN_PIN & _BV(BTN_C)))
		{
			_delay_ms(1);
			//previous			
			if(!(BTN_PIN & _BV(BTN_C)))			
			{
				pushed = 1;
				iterator--;
				LED_PORT = get_gray_code(iterator);
			}
			while(pushed)
			{
				if (BTN_PIN & _BV(BTN_C))	
				{
					_delay_ms(1);
					if (BTN_PIN & _BV(BTN_C))
					{
						pushed = 0;
					}
				}
			}

		}
	}
}


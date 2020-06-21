#include <avr/io.h>
#include <inttypes.h>
#include <stdlib.h>
#include <util/delay.h>

#define LED_R PB1
#define LED_G PB2
#define LED_B PB3
#define LED_DDR DDRB

#define OCR_R OCR1A
#define OCR_G OCR1B
#define OCR_B OCR2A

#define SIZE 32

// this is table from previous list converted with:
// 127.5 * (1 + math.cos(math.pi*x/255)) - sinusoidal movement
const uint16_t gamma_values[SIZE] = 
{ 
  0,        2,      5,      9,      
  14,      20,     28,     36,     
  45,      55,     66,     77,    
  89,     101,    114,    126,    
  139,    151,    163,    175,    
  187,    197,    208,    217,    
  225,    233,    239,    245,    
  249,    252,    254,    255,
};

const int8_t colors[7][3] = {
//   R  G  B
	{1, 0, 0}, //red
	{0, 1, 0}, //green
	{0, 0, 1}, //blue
	{1, 0, 1}, //purple
	{1, 1, 0}, //yellow
	{0, 1, 1}, //sea color
};


void timer_init()
{
	// Fast PWM 8 bit - TOP - 0x00FF
	TCCR1A |= _BV(WGM10);
	TCCR1B |= _BV(WGM12);

	TCCR1B |= _BV(CS00);   // freq: no prescaler
	TCCR1A |= _BV(COM1A1); // OCR1A out
	TCCR1A |= _BV(COM1B1); // OCR1B out

	// Fast PWM 8 bit - TOP - 0x00FF 
	TCCR2A |= _BV(WGM20);
	TCCR2B |= _BV(WGM21);

	TCCR2B |= _BV(CS00);   // freq: no prescaler
	TCCR2A |= _BV(COM2A1); // OCR2A out
}

int main()
{

	LED_DDR |= _BV(LED_R);
	LED_DDR |= _BV(LED_G);
	LED_DDR |= _BV(LED_B);

	timer_init();
	uint8_t red, green, blue;

	//start seed
	srand(100);

	while (1)
	{
		int16_t hue = rand() % 360;
		int16_t hue_prime = hue / 60;

		red = colors[hue_prime][0];
		green = colors[hue_prime][1];
		blue = colors[hue_prime][2];

		//light up
		for (int8_t i=0; i<SIZE; i++)
		{
			OCR_R = 255 - (red * gamma_values[i]);
			OCR_G = 255 - (green * gamma_values[i]);
			OCR_B = 255 - (blue * gamma_values[i]);
			_delay_ms(15);
		}

		//light down
		for (int8_t i=SIZE-1; i>=0; i--)
		{
			OCR_R = 255 - (red * gamma_values[i]);
			OCR_G = 255 - (green * gamma_values[i]);
			OCR_B = 255 - (blue * gamma_values[i]);
			_delay_ms(15);

		}
	}
}
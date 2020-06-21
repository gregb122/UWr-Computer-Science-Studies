#include <avr/io.h>
#include <util/delay.h>
#include <inttypes.h>

#define LED PB5
#define LED_DDR DDRB
#define LED_PORT PORTB

#define BTN PB4
#define BTN_PIN PINB
#define BTN_PORT PORTB

#define TIMEFRAME 10
#define BUFFER_SIZE 1000 / TIMEFRAME

int main() {

  //initialize buffer and fill with zeros
  int8_t buffer[BUFFER_SIZE];
  for (int8_t i=0; i<BUFFER_SIZE; i++)
	buffer[i] = 0;

  int8_t position = 0;

  BTN_PORT |= _BV(BTN);
  LED_DDR |= _BV(LED);

  while (1) {
    LED_PORT |= _BV(LED); // diode disable
	if (position == BUFFER_SIZE)
		position = 0;

	//enable diode if 1 at current position
	if (buffer[position]){
	  LED_PORT &= ~_BV(LED); //turn on the light of diode
	  buffer[position] = 0; // after light clear this position in buffer
	}
	// if button is pushed in this timeframe
    if (BTN_PIN & _BV(BTN))
		buffer[position] = 1;
		
	position++;
	_delay_ms(TIMEFRAME);
  }
}
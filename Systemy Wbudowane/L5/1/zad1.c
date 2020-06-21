#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include <avr/sleep.h>

#define LED PB5
#define LED_DDR DDRB
#define LED_PORT PORTB

#define BTN PB4
#define BTN_PIN PINB
#define BTN_PORT PORTB

#define TIMEFRAME 10
#define BUFFER_SIZE 1000 / TIMEFRAME


int8_t position = 0;
int8_t buffer[BUFFER_SIZE];

void init_timer_interrupt()
{
	// CTC mode 0 -> OCR1A
	TCCR1B |= _BV(WGM12);
	// Prescaler /256
	TCCR1B |= _BV(CS12);			
	// Switch on interrput
	TIMSK1 |= _BV(OCIE1A);			// enable interrupt
	// Calculate OCR1A 100Hz = (16 * 10^6 Hz) / (256 * (1 + 624)
	OCR1A = 624;
	// Start timer from 0
	TCNT1 = 0;
}

ISR(TIMER1_COMPA_vect)	
{
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
}

int main()
{
    //initialize buffer and fill with zeros
    for (int8_t i=0; i<BUFFER_SIZE; i++)
        buffer[i] = 0;

    BTN_PORT |= _BV(BTN);
    LED_DDR |= _BV(LED);

	init_timer_interrupt();
	sei();
    set_sleep_mode(SLEEP_MODE_IDLE);

	while (1)
	{
		sleep_mode();
	}
}

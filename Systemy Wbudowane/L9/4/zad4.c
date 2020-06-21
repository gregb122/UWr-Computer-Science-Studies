#include <avr/pgmspace.h>
#include <avr/io.h>
#include <util/delay.h>

#define BUZZ PB1
#define BUZZ_DDR DDRB
#define BUZZ_PORT PORTB

#define MELODY_DURATION 102 

#define C5 523
#define D5 587
#define E5 659
#define F5 698
#define G5 784
#define A5 880
#define B5 988
#define C6 1046
#define PAUSE -1

#define N16 125
#define N8 250
#define N8_DOT 375
#define N4 500
#define N4_DOT 750
#define N2 1100

//koko eurospoko
static const int16_t notes[MELODY_DURATION] PROGMEM = {
    G5, G5, D5, F5, E5, C5, PAUSE, 
    C6, C6, F5, A5, A5, G5, PAUSE,
    C6, C6, F5, A5, A5, G5, PAUSE,
    E5, G5, D5, F5, E5, G5, PAUSE,
    C6, C6, F5, A5, A5, G5, PAUSE,
    E5, G5, D5, F5, E5, C5, PAUSE,
    C5, C5, C5, C5, C5, E5, G5, E5, F5, F5, F5, F5,
    F5, A5, C6, A5, C5, C5, C5, C5, C5, E5, G5, E5,
    G5, F5, E5, D5, C5, C5, C5, C5, C5, C5, C5, E5, 
    G5, E5, F5, F5, F5, F5, F5, A5, C6, A5, C5, C5, 
    C5, C5, C5, E5, G5, E5, G5, F5, E5, D5, C5, C5
};

static const int16_t duration[MELODY_DURATION] PROGMEM = {
    N4, N4, N4, N4, N8, N4_DOT, N2,
    N4, N4, N4, N4, N8, N4_DOT, N2,
    N4, N4, N4, N4, N8, N4_DOT, N2,
    N4, N4, N4, N4, N8, N4_DOT, N2,
    N4, N4, N4, N4, N8, N4_DOT, N2,
    N4, N4, N4, N4, N8, N4_DOT, N2,    
    N8, N8, N8, N8, N8, N16, N8_DOT, N8, 
    N8, N8, N8, N8, N8, N16, N8_DOT, N8, 
    N8, N8, N8, N8, N8, N16, N8_DOT, N8, 
    N8, N8, N8, N8, N4, N4, 
    N8, N8, N8, N8, N8, N16, N8_DOT, N8, 
    N8, N8, N8, N8, N8, N16, N8_DOT, N8, 
    N8, N8, N8, N8, N8, N16, N8_DOT, N8, 
    N8, N8, N8, N8, N4, N4
};

void wait_for_period(int16_t period)
{
    for (int16_t i = 0; i < period; i++) 
    {
      _delay_us(1);
    }
}

void play_note(int16_t i) 
{
  int16_t delay, freq; 
  uint32_t period;

  delay = pgm_read_word(&duration[i]);
  freq =  pgm_read_word(&notes[i]);

  if (freq == -1)
  {
      _delay_ms(N2);
  }
  else
  {
    period = (1.0 / freq) * 750000; //this constant is result of hearing comparison towards sound ref

    for (uint16_t i = 0; i < (uint32_t)1000 * (delay) / (period) / 2; i++) 
    {
        BUZZ_PORT |= _BV(BUZZ);
        wait_for_period(period);
        BUZZ_PORT &= ~_BV(BUZZ);
        wait_for_period(period);
    }
  }
}

int main()
{
  BUZZ_DDR |= _BV(BUZZ);
  while (1) 
  {
    for (int16_t i = 0; i < MELODY_DURATION; i++) 
    {
        play_note(i);
    }
    _delay_ms(2000);
  }
}

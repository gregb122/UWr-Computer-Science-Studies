#include <avr/io.h>
#include <util/delay.h>
#include <stdio.h>
#include <inttypes.h>

#define BAUD 9600                          // baudrate
#define UBRR_VALUE ((F_CPU)/16/(BAUD)-1)   // zgodnie ze wzorem

#define LED PB5
#define LED_DDRB DDRB
#define LED_PORT PORTB

#define POT_MAX 1024
#define SEGMENT_SIZE 32


// This values are based on gamma correction function:
const uint16_t gamma_values[32] = 
{ 
  0,        1,      4,      7,      
  16,      24,     35,     51,     
  65,      81,    102,    125,    
  148,    174,    202,    232,    
  264,    298,    330,    370,    
  412,    455,    497,    544,    
  592,    643,    696,    751,    
  807,    866,    929,    992,
};


// inicjalizacja UART
void uart_init()
{
  // ustaw baudrate
  UBRR0 = UBRR_VALUE;
  // włącz odbiornik i nadajnik
  UCSR0B = _BV(RXEN0) | _BV(TXEN0);
  // ustaw format 8n1
  UCSR0C = _BV(UCSZ00) | _BV(UCSZ01);
}

// transmisja jednego znaku
int uart_transmit(char data, FILE *stream)
{
  // czekaj aż transmiter gotowy
  while(!(UCSR0A & _BV(UDRE0)));
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

// inicjalizacja ADC
void adc_init()
{
  ADMUX   = _BV(REFS0); // referencja AVcc, wejście ADC0
  DIDR0   = _BV(ADC0D); // wyłącz wejście cyfrowe na ADC0
  // częstotliwość zegara ADC 125 kHz (16 MHz / 128)
  ADCSRA  = _BV(ADPS0) | _BV(ADPS1) | _BV(ADPS2); // preskaler 128
  ADCSRA |= _BV(ADEN); // włącz ADC
}

void blink_diode(uint16_t value)
{
  int16_t on, off, index;
  index = value / SEGMENT_SIZE;
  if (index == 0)
  {
    on = 0;
  }
  else if(index == 31)
  {
    on = 1023;
  }
  else
  {
    on = (gamma_values[index] + gamma_values[index + 1]) >> 1; //get and shape gamma value  
  }
  
  off = POT_MAX - on;
  LED_PORT |= _BV(LED); // wlacz diode
  for(int16_t i=0; i <=on; i++)
    _delay_ms(0.01);

  LED_PORT &= ~_BV(LED); //wylacz diode
  for(int16_t i=0; i <=off; i++)
    _delay_ms(0.01);
}


FILE uart_file;

int main()
{
  LED_DDRB |= _BV(LED);
  // zainicjalizuj UART
  uart_init();
  // skonfiguruj strumienie wejścia/wyjścia
  fdev_setup_stream(&uart_file, uart_transmit, uart_receive, _FDEV_SETUP_RW);
  stdin = stdout = stderr = &uart_file;
  // zainicjalizuj ADC
  adc_init();
  // mierz napięcie
  while(1) {
    LED_PORT &= ~_BV(LED); //wylacz diode
    ADCSRA |= _BV(ADSC); // wykonaj konwersję
    while (!(ADCSRA & _BV(ADIF))); // czekaj na wynik
    ADCSRA |= _BV(ADIF); // wyczyść bit ADIF (pisząc 1!)
    uint16_t v = ADC; // weź zmierzoną wartość (0..1023)
    blink_diode(v); //zaswiec dioda
  }
}


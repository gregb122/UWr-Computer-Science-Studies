#include <avr/io.h>
#include <util/delay.h>
#include <stdio.h>
#include <inttypes.h>

#define LED PB1
#define LED_DDR DDRB

#define OCR_LED OCR1A

#define ADC_MAX 1024
#define SEGMENT_SIZE 32

#define BAUD 9600                          // baudrate
#define UBRR_VALUE ((F_CPU)/16/(BAUD)-1)   // zgodnie ze wzorem

// inicjalizacja UART
void uart_init()
{
  // ustaw baudrate
  UBRR0 = UBRR_VALUE;
  // wyczyść rejestr UCSR0A
  UCSR0A = 0;
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

const uint16_t gamma_values[32] = 
{ 
  0,        1,      3,      5,      
  10,      17,     21,     25,     
  29,      39,     45,     51,    
  56,      68,     73,     81,    
  90,      99,    104,    110,    
  117,    124,    136,    149,    
  160,    172,    186,    201,    
  212,    232,    244,    255,
};


void initTimer()
{
  //Fast PWM 8-bit TOP 0xFF
	TCCR1A |= _BV(WGM10);
	TCCR1B |= _BV(WGM12);

	TCCR1B |= _BV(CS10);   // clk I/O /1 (No prescaling)
	TCCR1A |= _BV(COM1A1); // output on OCR1A
	
}

void adc_init()
{
	  ADMUX   = _BV(REFS0); // referencja AVcc, wejście ADC0
  	DIDR0   = _BV(ADC0D); // wyłącz wejście cyfrowe na ADC0
  	// częstotliwość zegara ADC 125 kHz (16 MHz / 128)
  	ADCSRA  = _BV(ADPS0) | _BV(ADPS1) | _BV(ADPS2); // preskaler 128
  	ADCSRA |= _BV(ADEN); // włącz AD
}

void blink_diode(uint16_t value)
{
  int16_t on, index;

  index = ((ADC_MAX - value) / SEGMENT_SIZE);
  if (index == 0)
  {
	  on = 0;
  }
  else if (index == 31)
  {
	  on = gamma_values[31];
  }
  else
  {
	  on = (gamma_values[index] + gamma_values[index+1]) >> 1;
  }

  printf("LIGHT VALUES: %"PRIu16"\r\n", on);
  OCR_LED = on;

}



FILE uart_file;

int main()
{
// zainicjalizuj UART
  uart_init();
  // skonfiguruj strumienie wejścia/wyjścia
  fdev_setup_stream(&uart_file, uart_transmit, uart_receive, _FDEV_SETUP_RW);
  stdin = stdout = stderr = &uart_file;
  // zainicjalizuj licznik

	adc_init();
	initTimer();

	LED_DDR |= _BV(LED);

	while (1)
	{
		ADCSRA |= _BV(ADSC); // wykonaj konwersję
		while (!(ADCSRA & _BV(ADIF))); // czekaj na wynik
		ADCSRA |= _BV(ADIF); // wyczyść bit ADIF (pisząc 1!)
		uint16_t v = ADC; // weź zmierzoną wartość (0..1023)

    printf("ADC: %"PRId16"\r\n", v); 
		blink_diode(v);
	}
}
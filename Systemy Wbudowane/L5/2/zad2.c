#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include <stdio.h>
#include <inttypes.h>

#define BTN PD2
#define BTN_PIN PIND
#define BTN_PORT PORTD

#define BAUD 9600                          // baudrate
#define UBRR_VALUE ((F_CPU)/16/(BAUD)-1)   // zgodnie ze wzorem

#define R1 10000 //10kohm rezystor

volatile uint16_t v;

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


void adc_init()
{
	ADMUX   = _BV(REFS0); // referencja AVcc, wejście ADC0
  	DIDR0   = _BV(ADC0D); // wyłącz wejście cyfrowe na ADC0
  	// częstotliwość zegara ADC 125 kHz (16 MHz / 128)
  	ADCSRA  = _BV(ADPS0) | _BV(ADPS1) | _BV(ADPS2); // preskaler 128
  	ADCSRA |= _BV(ADEN); // włącz AD
}

ISR(INT0_vect)
{
	ADCSRA |= _BV(ADSC); // wykonaj konwersję
	while (!(ADCSRA & _BV(ADIF))); // czekaj na wynik
	ADCSRA |= _BV(ADIF); // wyczyść bit ADIF (pisząc 1!)
	v = ADC; // weź zmierzoną wartość (0..1023)
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
	//przerwanie na narastajacym zboczu str 72
	EICRA |= _BV(ISC00) | _BV(ISC01);
	//wlacz INT0
	EIMSK |= _BV(INT0);

	sei();				
	//pull up
	PORTD |= _BV(PORTD2);				
	BTN_PORT |= _BV(BTN);

	int32_t fotoresistor_resistance;
	float voltage_out;
	while (1)
	{

		voltage_out = (float)v / 1024 * 5.0;
		fotoresistor_resistance = (int32_t)(R1 * ((5.0 / voltage_out) - 1.0));
	    printf("Rezystancja fotorezystora w Ohm: %"PRId32"\r\n", fotoresistor_resistance); 
		printf("Napiecie OUT w ms: %"PRId16"\r\n", (int16_t)(voltage_out * 1000)); 
		printf("Wartosc ADC: %"PRId16"\r\n", v);
		_delay_ms(1000);
	}
}




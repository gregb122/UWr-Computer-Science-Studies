#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/sleep.h>
#include <stdio.h>
#include <inttypes.h>

#define BAUD 9600                          // baudrate
#define UBRR_VALUE ((F_CPU)/16/(BAUD)-1)   // zgodnie ze wzorem

#define BUFFER_SIZE 100

int16_t buffer_adc_nr[BUFFER_SIZE];
int16_t buffer_adc[BUFFER_SIZE];
int8_t index;

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

FILE uart_file;

void adc_init()
{
  ADMUX  |= _BV(REFS0) | _BV(MUX1) | _BV(MUX2) | _BV(MUX3); // atmel datasheet page 255
  DIDR0   = _BV(ADC0D); // wyłącz wejście cyfrowe na ADC0
  // częstotliwość zegara ADC 125 kHz (16 MHz / 128)
  ADCSRA  = _BV(ADPS0) | _BV(ADPS1) | _BV(ADPS2); // preskaler 128
  ADCSRA |= _BV(ADEN); // włącz ADC

}

void adc_init_noise_reduction()
{
	//tryb uspienia procesora adc noise reduction (page 43)
	SMCR |= _BV(SM0);
	//wlacz przerwania adc				   
	ADCSRA |= _BV(ADIE);
}

int16_t read_ADC()
{
	ADCSRA |= _BV(ADSC); // wykonaj konwersję
	while (!(ADCSRA & _BV(ADIF))); // czekaj na wynik
	ADCSRA |= _BV(ADIF); // wyczyść bit ADIF (pisząc 1!)
	return ADC;
}

ISR(ADC_vect)
{
	buffer_adc_nr[index] = read_ADC();
}

int16_t calculate_var(int16_t adc_buffer[])
{
	int32_t result = 0, sum = 0;
	for(int16_t i = 0; i < 100; i++)
		sum += adc_buffer[i];
	
	for(int16_t i = 0; i < 100; i++)
		result = result + (adc_buffer[i] - (sum / 100)) * (adc_buffer[i] - (sum / 100)) ;
	
	return result / 100;
} 

int main()
{
	// zainicjalizuj UART
	uart_init();
	// skonfiguruj strumienie wejścia/wyjścia
	fdev_setup_stream(&uart_file, uart_transmit, uart_receive, _FDEV_SETUP_RW);
	stdin = stdout = stderr = &uart_file;

	adc_init();

	//pomiar bez noise reduction
	for (int8_t i=0; i<100; i++)
		buffer_adc[i] = read_ADC();

	//pomiar dla noise reduction
	sei();

	adc_init_noise_reduction();

	index = 0;

	while (index < 100)
	{
		sleep_mode();
		index++;
	}

	int16_t var = calculate_var(buffer_adc);
	int16_t var_noise_reduction = calculate_var(buffer_adc_nr);

	printf("No noise reduction: %"PRId16"\r\n", var);
	printf("With noise reduction: %"PRId16"\r\n", var_noise_reduction);
}
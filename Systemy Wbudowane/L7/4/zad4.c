#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>
#include <stdio.h>
#include <inttypes.h>

#define BAUD 9600                          // baudrate
#define UBRR_VALUE ((F_CPU)/16/(BAUD)-1)   // zgodnie ze wzorem

#define DDR_MASTER DDRD
#define DDR_SLAVE DDRB
#define MISO_SLAVE PB4
#define MISO_MASTER PD4
#define MOSI PD3
#define SCK PD5

volatile uint8_t number = 0; 
volatile uint8_t received = 0;


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

//SPI Serial Transfer Complete
ISR(SPI_STC_vect)
{
	received = SPDR;
	printf("Odebrano: %"PRIu8"\r\n", received);
  SPDR = received;
}

// odczyt jednego znaku
int uart_receive(FILE *stream)
{
  // czekaj aż znak dostępny
  while (!(UCSR0A & _BV(RXC0)));
  return UDR0;
}

// inicjalizacja SPI
void spi_init()
{
    // ustaw jako wyjścia mastera szyny zegara i danych SCK i MOSI
	  DDR_MASTER |= _BV(SCK) | _BV(MOSI);	
    // włącz SPI
    SPCR |= _BV(SPE);
    // włącz przerwania
    SPCR |= _BV(SPIE);
    // ustaw jako wyjścia slave MISO SLAVE
    DDR_SLAVE |= _BV(MISO_SLAVE);
 
}


//https://en.wikipedia.org/wiki/Bit_banging
void send_8bit_serial_data(uint8_t data)
{  
    // wyslij do mastera dane po szynie danych i poinformuj mastera po kazdym przeslanym bicie po szynie
    // zegara
    // send bits 7..0
   printf("Wysłano z mastera: %"PRIu8"\r\n", data);
   for (int8_t i = 0; i < 8; i++)
   {
       // consider leftmost bit
       // set line high if bit is 1, low if bit is 0
       if (data & 0x80)
       {
        PORTD |= _BV(MOSI); //output_high(SD_DI);
       }
       else
       {
        PORTD &= ~_BV(MOSI); //output_low(SD_DI);
       }

       // pulse clock to indicate that bit value should be read
		  PORTD |= _BV(SCK);				
		  PORTD &= ~_BV(SCK);

       // shift byte left so next bit will be leftmost
       data <<= 1;
   }
}

FILE uart_file;


int main()
{
  // zainicjalizuj UART
  uart_init();
  // skonfiguruj strumienie wejścia/wyjścia
  fdev_setup_stream(&uart_file, uart_transmit, uart_receive, _FDEV_SETUP_RW);
  stdin = stdout = stderr = &uart_file;
  // zainicjalizuj SPI
  spi_init();
  // odmaskuj przerwania
  sei();

  while(1) 
  {
	send_8bit_serial_data(number);
	_delay_ms(1000);
    number++;
    if(number == 255)
        number = 0;
  }
}
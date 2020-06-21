#include <avr/io.h>
#include <stdio.h>
#include <inttypes.h>
#include<util/delay.h>

#define LA_PIN DDB1
#define OE_PIN DDB2
#define LED_DDR DDRB
#define LED_PORT PORTB


uint8_t digits[10] = {
		0b00111111, //0
		0b00000110, //1
		0b01011011, //2
		0b01001111, //3
		0b01100110, //4
		0b01101101, //5
		0b11111101, //6
		0b00000111, //7
		0b01111111, //8
		0b11101111  //9
};

// inicjalizacja SPI
void spi_init()
{
	// ustaw piny MOSI i SCK jako wyjscia
    DDRB |= _BV(DDB3) | _BV(DDB5);
    // włącz SPI w trybie master z zegarem 250 kHz
    SPCR = _BV(SPE) | _BV(MSTR) | _BV(SPR1);
	// ustaw piny LA i OE jako wyjscia	
	DDRB |= _BV(LA_PIN) | _BV(OE_PIN);
}


// transfer jednego bajtu
uint8_t spi_transfer(uint8_t data)
{
    // rozpocznij transmisję
    SPDR = data;
    // czekaj na ukończenie transmisji
    while (!(SPSR & _BV(SPIF)));
    // wyczyść flagę przerwania
    SPSR |= _BV(SPIF);
    // zwróć otrzymane dane
    return SPDR;
}


int main()
{
	//ustaw piny portu B w tryb wyjścia
	LED_DDR |= 0xFF;
	spi_init();

	uint8_t number = 0;

	while(1) 
	{
		// wyłącz świecenie diod na czas ładowania wartosci z rejestru przesuwnego
		LED_PORT |= _BV(OE_PIN);
		//przeslij dane do sterownika led
		spi_transfer(digits[number]);
		//zaladuj nowe wartosci z rejestru przesuwnego
		LED_PORT |= _BV(LA_PIN);
		//wylacz ladowanie wartosci
		LED_PORT &= ~_BV(LA_PIN);
		// włącz świecenie diod stanem niskim
		LED_PORT &= ~_BV(OE_PIN);				
	
		_delay_ms(1000);

		number++;		
		if (number == 10)
		{
			number = 0;
		}
	}
}

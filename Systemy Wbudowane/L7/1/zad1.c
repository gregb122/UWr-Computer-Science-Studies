#include <avr/io.h>
#include<util/delay.h>
#include <stdio.h>
#include <inttypes.h>
#include "i2c.h"

#define BAUD 9600                          // baudrate
#define UBRR_VALUE ((F_CPU)/16/(BAUD)-1)   // zgodnie ze wzorem

//p. 3.16 device code: 1010 (b7-b4)
#define EEPROM_DEVICE_CODE 0xa0

#define i2cCheck(code, msg) \
	if ((TWSR & 0xf8) != (code)) { \
		printf(msg " failed, status: %.2x\r\n", TWSR & 0xf8); \
		i2cReset(); \
	}


void write(int16_t addr, int8_t v)
{
    i2cStart();
    i2cCheck(0x08, "I2C start")
    i2cSend(EEPROM_DEVICE_CODE | 0x00); // RW (b0) = 0 Byte Write
    i2cCheck(0x18, "I2C EEPROM write request")
    i2cSend(addr);
    i2cCheck(0x28, "I2C EEPROM set address")
	i2cSend(v);
    i2cCheck(0x28, "I2C EEPROM write value")
	i2cStop();    
    i2cCheck(0xf8, "I2C stop writing")
	_delay_ms(50);

}

uint8_t read(int16_t addr)
{
    i2cStart();
    i2cCheck(0x08, "I2C start")
    i2cSend(EEPROM_DEVICE_CODE | 0x00); // RW (b0) = 0 Byte Write;
    i2cCheck(0x18, "I2C EEPROM write request")
    i2cSend(addr);
    i2cCheck(0x28, "I2C EEPROM set address")
    
    i2cStart();
    i2cCheck(0x10, "I2C second start")
    i2cSend(EEPROM_DEVICE_CODE | 0x01); // RW (b0) = 1 Current Address Read
    i2cCheck(0x40, "I2C EEPROM read request")
    uint8_t data = i2cReadNoAck();
    i2cCheck(0x58, "I2C EEPROM read")
    i2cStop();
    i2cCheck(0xf8, "I2C stop")
    _delay_ms(50);
    return data;
}

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

//device code
const uint8_t eeprom_addr = 0xa0; 

int main()
{
  // zainicjalizuj UART
  uart_init();
  // skonfiguruj strumienie wejścia/wyjścia
  fdev_setup_stream(&uart_file, uart_transmit, uart_receive, _FDEV_SETUP_RW);
  stdin = stdout = stderr = &uart_file;
  // zainicjalizuj I2C
  i2cInit();
  // program testowy
  int8_t command_id;
  uint8_t value = 0;
  int16_t address = 0;

  while(1)
	{
        printf("Wybierz polecenie:\r\n");
		printf("0: read\r\n");
        printf("1: write\r\n");
		scanf("%"PRIu8, &command_id);
        
        //write
        if (command_id == 1)
        {
            printf("Wybrano: write. Podaj adres: \r\n");
            scanf("%"PRId16, &address);
            printf("Podaj wartosc bajtu: \r\n");
            scanf("%"PRIu8, &value);
            write(address, value);
            printf("Zapisano %"PRIu8" pod adres: %"PRId16"\r\n", value, address);
        }
        //read
        else if(command_id == 0)
        {
            printf("Wybrano: read. Podaj adres: \r\n");
            scanf("%"PRId16, &address);
            uint8_t data = read(address);
            printf("Odczytano %"PRIu8" pod adresem: %"PRId16"\r\n", data, address);
        }
    }
}


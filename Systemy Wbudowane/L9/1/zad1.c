#include <avr/io.h>
#include <util/delay.h>
#include <stdio.h>
#include <inttypes.h>
#include "hd44780.h"

#define ROW_CHAR_COUNT 16
#define ROW_NUM 2

#define BAUD 9600                          // baudrate
#define UBRR_VALUE ((F_CPU)/16/(BAUD)-1)   // zgodnie ze wzorem

volatile char buffer[ROW_CHAR_COUNT] = {0};
volatile int row = 0;
volatile int current_row = 0;
volatile int position = 0;


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

// odczyt 
int uart_receive(FILE *stream)
{
  // czekaj aż znak dostępny
  while (!(UCSR0A & _BV(RXC0)));
  return UDR0;
}

int hd44780_transmit(char data, FILE *stream)
{
  LCD_WriteData(data);
  return 0;
}

FILE hd44780_file;


int main()
{
  LCD_Initialize();
  LCD_Clear();
  uart_init();

  fdev_setup_stream(&hd44780_file, hd44780_transmit, uart_receive, _FDEV_SETUP_RW);
  stdin = stdout = stderr = &hd44780_file;

  char cursor = 124;
  volatile char c;

  //main loop program
  while(1) {
    // current row is full
    if(position == 16)
    {
      // if current row isnt first row written by user
      if(current_row)
      {
        LCD_Clear();
        LCD_GoTo(0, 0);
        if(buffer[0] != 0)
        {
          for(int8_t i = 0; i < position; i++)
          {
            printf("%c", buffer[i]);
          }
        }
      }
      // if its first row written, just skip to the 2nd, no need to clear 1st.
      else
      {
        current_row = 1;
      }
      // reset position
      position = 0;
      // go to position and 2nd row
      LCD_GoTo(position, 1);
    }

    printf("%c", cursor);
    LCD_GoTo(position, current_row);

    scanf("%c", &c);
    //if new line char appears
    if(c == 13)
    {
      if(current_row)
      {
        LCD_Clear();
        LCD_GoTo(0, 0);
        if(buffer[0] != 0)
        {
          for(int8_t i = 0; i < position; i++)
          {
            printf("%c", buffer[i]);
          }
        }
      }
      else
      {
        current_row = 1;
        printf("%c", 32);
      }

      position = 0;
      LCD_GoTo(position, 1);
      continue;
    }
    //wyswietl znak
    printf("%c", c);
    //zapisz go w buforze w celu odtworzenia juz wyswietlonego rzedu w nowej linii
    buffer[position] = c;
    position++;
  }

}

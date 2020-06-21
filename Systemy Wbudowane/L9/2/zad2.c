#include <avr/io.h>
#include <util/delay.h>
#include <stdio.h>
#include <inttypes.h>
#include "hd44780.h"

#define ROW_CHAR_COUNT 16
#define WRITE_ADDRESS 0x40


uint8_t progress_bar[ROW_CHAR_COUNT] = {
	0, 6, 13, 19, 26, 
	33, 39, 45, 52, 59,
	66, 72, 79, 86, 93,
	100 
};

// indeksy kolumn: 4 - 0 od lewej
// dla kazdej kolumny wypelniamy ja 8 razy wartosciami - 8x1 dla pelnego znaku
uint8_t new_chars[5] = {
	0b00010000,
	0b00011000,
	0b00011100,
	0b00011110,
	0b00011111
};

// transmisja 
int hd44780_transmit(char data, FILE *stream)
{
  LCD_WriteData(data);
  return 0;
}

FILE hd44780_file;

void write_new_char(uint8_t addr, uint8_t new_char_index)
{
	// 8, 16, 24, 32, 40
	//kolejne adresy: 0b00001000  0b00010000,  0b00011000, 0b00100000, 0b00101000
	LCD_WriteCommand(WRITE_ADDRESS | ((addr & 0b00000111) << 3));

	uint8_t new_char = new_chars[new_char_index];
	for(int8_t i = 0; i < 8; i++)
	{
		LCD_WriteData(new_char);
	}
}


int main()
{
	// skonfiguruj wyświetlacz
	LCD_Initialize();
	LCD_Clear();
	// skonfiguruj strumienie wyjściowe
	fdev_setup_stream(&hd44780_file, hd44780_transmit, NULL, _FDEV_SETUP_WRITE);
	stdout = stderr = &hd44780_file;

	write_new_char(1, 0);
	write_new_char(2, 1);
	write_new_char(3, 2);
	write_new_char(4, 3);
	write_new_char(5, 4);

	int8_t position = 0;

	int8_t column, sign;
	while(1)
	{
		LCD_GoTo(0, 0);
		printf("Progress bar:%"PRId8"%c", progress_bar[position / 5], 37);

		column = position / 6;
		LCD_GoTo(column, 1);
		sign = position % 6;

		if(sign != 0)
		{
			printf("%c", sign);
		}

		position++;
		
		if(position == 81)
		{
			position = 0;
			LCD_Clear();
		}
		_delay_ms(300);
	}
}

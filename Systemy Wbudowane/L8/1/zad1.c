/******************************************************************************
 * Header file inclusions.
 ******************************************************************************/

#include "FreeRTOS.h"
#include "task.h"

#include <avr/io.h>

#include <inttypes.h>
#include <stdio.h>
#include "uart.h"


/******************************************************************************
 * Private macro definitions.
 ******************************************************************************/

#define mainLED_TASK_PRIORITY   2

#define mainSERIAL_TASK_PRIORITY 1

#define LED PB5
#define LED_DDR DDRB
#define LED_PORT PORTB

#define BTN PB4
#define BTN_PIN PINB
#define BTN_PORT PORTB

#define LED_DDR_D DDRD
#define LED_PORT_D PORTD
#define LED_DELAY 40

#define TIMEFRAME 10
#define BUFFER_SIZE 1000 / TIMEFRAME


/******************************************************************************
 * Private function prototypes.
 ******************************************************************************/

static void vBlinkLed(void* pvParameters);

static void vSerial(void* pvParameters);

/******************************************************************************
 * Public function definitions.
 ******************************************************************************/

/**************************************************************************//**
 * \fn int main(void)
 *
 * \brief Main function.
 *
 * \return
 ******************************************************************************/
int main(void)
{
    // Create task.
    xTaskHandle blink_handle;
    xTaskHandle serial_handle;

    xTaskCreate
        (
         vBlinkLed,
         "blink",
         configMINIMAL_STACK_SIZE,
         NULL,
         mainLED_TASK_PRIORITY,
         &blink_handle
        );

    xTaskCreate
        (
         vSerial,
         "serial",
         configMINIMAL_STACK_SIZE,
         NULL,
         mainSERIAL_TASK_PRIORITY,
         &serial_handle
        );

    // Start scheduler.
    vTaskStartScheduler();

    return 0;
}

/**************************************************************************//**
 * \fn static vApplicationIdleHook(void)
 *
 * \brief
 ******************************************************************************/
void vApplicationIdleHook(void)
{

}

/******************************************************************************
 * Private function definitions.
 ******************************************************************************/

/**************************************************************************//**
 * \fn static void vBlinkLed(void* pvParameters)
 *
 * \brief
 *
 * \param[in]   pvParameters
 ******************************************************************************/
static void vBlinkLed(void* pvParameters)
{
  int8_t buffer[BUFFER_SIZE];
  for (int8_t i=0; i<BUFFER_SIZE; i++)
	buffer[i] = 0;

  int8_t position = 0;

  BTN_PORT |= _BV(BTN);
  LED_DDR |= _BV(LED);

  while (1) {
    LED_PORT |= _BV(LED); // diode disable
	if (position == BUFFER_SIZE)
		position = 0;

	//enable diode if 1 at current position
	if (buffer[position]){
	  LED_PORT &= ~_BV(LED); //turn on the light of diode
	  buffer[position] = 0; // after light clear this position in buffer
	}
	// if button is pushed in this timeframe
    if (BTN_PIN & _BV(BTN))
		buffer[position] = 1;
		
	position++;
    vTaskDelay(10 / portTICK_PERIOD_MS);
  }
}


/**************************************************************************//**
 * \fn static void vSerial(void* pvParameters)
 *
 * \brief
 *
 * \param[in]   pvParameters
 ******************************************************************************/
static void vSerial(void* pvParameters)
{
	LED_DDR_D  = 0xFF;
	LED_PORT_D = 0x80;
	UCSR0B &= ~ _BV ( RXEN0 ) & ~ _BV ( TXEN0 ) ;

	while (1)
	{
		//ascending
		for (int8_t i=0; i<7; i++)
		{
            vTaskDelay(50 / portTICK_PERIOD_MS);
			LED_PORT_D >>= 1;
		}
		//descending
		for (int8_t j=0; j<7; j++)
		{
            vTaskDelay(50 / portTICK_PERIOD_MS);
			LED_PORT_D <<= 1;
		}
	}
}



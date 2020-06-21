/******************************************************************************
 * Header file inclusions.
 ******************************************************************************/

#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"
#include <avr/io.h>

#include <inttypes.h>
#include <stdio.h>
#include "uart.h"


/******************************************************************************
 * Private macro definitions.
 ******************************************************************************/

#define TASK1_PRIORITY 1

#define TASK2_PRIORITY 2

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

static void vTask1_sender(void* pvParameters);

static void vTask2_receiver(void* pvParameters);

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
QueueHandle_t xQueue;

int main(void)
{
    // Create task.
    xTaskHandle sender_handle;
    xTaskHandle receiver_handle;

    // Create FREERTOS queue
    xQueue = xQueueCreate(50, sizeof( int16_t ) );

if( xQueue != NULL )
 {
 
    xTaskCreate
        (
         vTask1_sender,
         "sender",
         configMINIMAL_STACK_SIZE,
         NULL,
         1,
         &sender_handle
        );

    xTaskCreate
        (
         vTask2_receiver,
         "receiver",
         configMINIMAL_STACK_SIZE,
         NULL,
         2,
         &receiver_handle
        );
 }
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
 * \fn static void vTask1_sender(void* pvParameters)
 *
 * \brief
 *
 * \param[in]   pvParameters
 ******************************************************************************/
static void vTask1_sender(void* pvParameters)
{
    uart_init();

    BaseType_t xStatus;
    stdin = stdout = stderr = &uart_file;
    int16_t input;
    for (;;)
    {
      printf("Podaj liczbe: \r\n");
      scanf("%"PRId16, &input);
      printf("Podano liczbe: %"PRId16"\r\n", input);
      xStatus = xQueueSendToBack(xQueue, &input, 0 );

    }

}

/**************************************************************************//**
 * \fn static void vTask2_receiver(void* pvParameters)
 *
 * \brief
 *
 * \param[in]   pvParameters
 ******************************************************************************/
static void vTask2_receiver(void* pvParameters)
{
    LED_DDR |= _BV(LED);
    int16_t received_value;
    const TickType_t xTicksToWait = pdMS_TO_TICKS( 100 );
    BaseType_t xStatus;

    for (;;)
    {
      xStatus = xQueueReceive(xQueue, &received_value, xTicksToWait );
      if (xStatus == pdPASS)
      {

        LED_PORT |= _BV(LED);
        vTaskDelay(received_value / portTICK_PERIOD_MS);
        LED_PORT &= ~_BV(LED);
        vTaskDelay(100 / portTICK_PERIOD_MS); // make 100 ms pauses between diode signalling
      }
    }

}



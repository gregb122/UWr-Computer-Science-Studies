#include <avr/io.h>
#include <stdio.h>
#include <inttypes.h>
#include <util/delay.h>
#include <avr/interrupt.h>


#define BAUD 9600                          // baudrate
#define UBRR_VALUE ((F_CPU)/16/(BAUD)-1)   // zgodnie ze wzorem

// #define LED_DDR DDRD
// #define LED_PORT PORTD
// #define R PD6
// #define Y PD5
// #define G PD4

#define BUFF_SIZE 32

typedef struct {
  volatile char buf[BUFF_SIZE];
  int first;
  int last;
  int size;
} circular_buffer;

volatile circular_buffer trans_buff = {.first = 0, .last = 0, .size =0};
volatile circular_buffer receive_buff = {.first = 0, .last = 0, .size =0};

// void blink(int pin)
// {
//   LED_PORT |= (1 << pin);
//   _delay_ms(50);
//   LED_PORT = 0;
//   _delay_ms(50);
// }

void put_char_to_buff(char read_char, volatile circular_buffer *buffer)
{
  buffer->buf[buffer->last] = read_char;
  buffer->last = (buffer->last + 1) % BUFF_SIZE;
  (buffer->size)++;
}

char get_char_from_buff(volatile circular_buffer *buffer)
{
  char read_char = buffer->buf[buffer->first];
  buffer->first = (buffer->first + 1) % BUFF_SIZE;
  (buffer->size)--;

  return read_char;
}

// inicjalizacja UART
void uart_init()
{
	// set baud rate
  UBRR0 = UBRR_VALUE;
	// clear UCSR0A register
	UCSR0A = 0;
	// turn on receiver and transmitter
  UCSR0B = (1 << RXEN0) | (1 << TXEN0);
  // set 8-bit character size for rec. and trans.
	UCSR0C = (1 << UCSZ00) | (1 << UCSZ01);
	// enable interrupt for receiver
	UCSR0B |= (1 << RXCIE0);
}

// interrupt handler for receiver
ISR(USART_RX_vect)
{
  volatile char read_char;
  read_char = UDR0;
  put_char_to_buff(read_char, &receive_buff);
}

// interrupt handler for registers clearence
ISR(USART_UDRE_vect)
{
  // read from transmit buffer
  if (trans_buff.size > 0) {
    UDR0 = get_char_from_buff(&trans_buff);
  } else {
    UCSR0B &= ~(1 << UDRIE0);
  }
}

// read one char
int uart_receive(FILE *stream)
{
  // wait for nonempty buffer
  while(receive_buff.size == 0) {}
  char buff_char = receive_buff.buf[receive_buff.first];
  receive_buff.first = (receive_buff.first + 1) % BUFF_SIZE;
  (receive_buff.size)--;
  return buff_char;
}

// transmit one char
int uart_transmit(char data, FILE *stream)
{
  // wait for free space in buffer
  while(trans_buff.size ==  BUFF_SIZE) {}
  put_char_to_buff(data, &trans_buff);

	// enable interrupt for registers clearence
	UCSR0B |= (1 << UDRIE0); 
  return 0;
}

FILE uart_file;

int main()
{
  // LED_DDR |= 0xFF;
  
  // zainicjalizuj UART
  uart_init();
  // skonfiguruj strumienie wejścia/wyjścia
  fdev_setup_stream(&uart_file, uart_transmit, uart_receive, _FDEV_SETUP_RW);
  stdin = stdout = stderr = &uart_file;
  sei();

  // program testowy
  printf("Hello world!\r\n");
  while(1) {
    int16_t a = 1;
    scanf("%"SCNd16, &a);
    printf("Odczytano: %"PRId16"\r\n", a);
  }
}
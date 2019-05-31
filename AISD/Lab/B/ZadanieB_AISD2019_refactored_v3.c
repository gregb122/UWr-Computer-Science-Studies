/*  
    Algorytmy i Struktury Danych 2019 - Pracownia
    Zadanie B
    Autor: Adam Kufel 
    Nr indeksu: 292345
*/

#include <stdio.h>
#include <stdlib.h>

#define swap(a, b) {a = a ^ b; b = a ^ b; a = a ^ b;}

#define HEAP_FRAME_SIZE 50000
#define UINT_MAX 4294967295

unsigned int* heap_realloc(unsigned int* heap_p, unsigned int heap_max_size);

void heapify (unsigned int i, unsigned int* heap_p, unsigned int heap_size);
unsigned int* insert(unsigned int* heap_p, unsigned int heap_size, unsigned int e);
unsigned int* delete_max(unsigned int* heap_p, unsigned int heap_size);


int main()
{   
    /*
        HEAP DATA STRUCTURES
    */

    unsigned int *heap_A_p, *heap_B_p, *heap_C_p; //pointers to heaps
    unsigned int heap_size_A, heap_size_B, heap_size_C; //current size of heaps
    
    // for dynamic memory allocation purpose
    unsigned int heap_A_fr, heap_B_fr, heap_C_fr; //memory frame rate of heaps
    unsigned int heap_A_max_size, heap_B_max_size, heap_C_max_size; //max sizes of heaps

    heap_A_fr = heap_B_fr = heap_C_fr = 1;

    //heaps init
    heap_A_p = (unsigned int* ) malloc(HEAP_FRAME_SIZE * sizeof(unsigned int));
    heap_B_p = (unsigned int* ) malloc(HEAP_FRAME_SIZE * sizeof(unsigned int));
    heap_C_p = (unsigned int* ) malloc(HEAP_FRAME_SIZE * sizeof(unsigned int));

    heap_A_max_size = HEAP_FRAME_SIZE * heap_A_fr;
    heap_B_max_size = HEAP_FRAME_SIZE * heap_B_fr;
    heap_C_max_size = HEAP_FRAME_SIZE * heap_C_fr;

    // heap_size init
    heap_size_A = heap_size_B = heap_size_C = 1;

    /*
        ALGORITHM DATA STRUCTURES
    */
    
    unsigned long current_value, prev_value = 0; //store values from heap deal with duplicates
    unsigned long counter_ret = 0;
    unsigned long col = 1;
    unsigned long col_guard = 0;
    
    //for conversion long->int purpose
    unsigned int modulo;
    unsigned long division, divisionA, divisionB, divisionC;

    //reading data from stdin
    unsigned long m, k;     
    scanf("%lu%lu", &m, &k);

    //init for 1st M * M elem
    current_value = m * m; 
    printf("%lu\n", current_value);
    counter_ret++;
    
    division = current_value / UINT_MAX;
    divisionA = division;
    divisionB = division - 1;
    divisionC = division - 2;

    while (counter_ret < k)
    {
        //pushing elements into queue
        for(unsigned long row=0; row<=col; row++)
        {
            //encode number
            current_value = (m - col) * (m - row);
            division = current_value / UINT_MAX;
            modulo = (unsigned int)(current_value % UINT_MAX);

            //push modulo and division
            if (division == divisionA)
            {
                if (heap_size_A >= heap_A_max_size)
                {
                    heap_A_fr++;
                    heap_A_max_size = heap_A_fr * HEAP_FRAME_SIZE;
                    heap_A_p = heap_realloc(heap_A_p, heap_A_max_size);
                }

                heap_A_p = insert(heap_A_p, heap_size_A, modulo);       
                heap_size_A++;
            }
            else if (division == divisionB)
            {
                if (heap_size_B >= heap_B_max_size)
                {
                    heap_B_fr++;
                    heap_B_max_size = heap_B_fr * HEAP_FRAME_SIZE;
                    heap_B_p = heap_realloc(heap_B_p, heap_B_max_size);
                }

                heap_B_p = insert(heap_B_p, heap_size_B, modulo);       
                heap_size_B++;
            }
            else if (division == divisionC)
            {
                if (heap_size_C >= heap_C_max_size)
                {
                    heap_C_fr++;
                    heap_C_max_size = heap_C_fr * HEAP_FRAME_SIZE;
                    heap_C_p = heap_realloc(heap_C_p, heap_C_max_size);
                }

                heap_C_p = insert(heap_C_p, heap_size_C, modulo);       
                heap_size_C++;
            }
        }

        col++;
        col_guard = (m - col) * m;
        
        /* 
            POP ELEMENTS FROM HEAP(S) 
        */
        modulo = heap_A_p[1];

        //decode number
        current_value = UINT_MAX * divisionA + (unsigned long)modulo;

        while (current_value >= col_guard && heap_size_A > 1)
        {
            
            if (prev_value != current_value)
            {   printf("%lu\n", current_value);
                counter_ret++;
            }
            prev_value = current_value;
                //pop element
                if (heap_size_A < heap_A_max_size - HEAP_FRAME_SIZE && heap_A_fr > 1)
                {
                    heap_A_fr--;
                    heap_A_max_size = heap_A_fr * HEAP_FRAME_SIZE;
                    heap_A_p = heap_realloc(heap_A_p, heap_A_max_size);
                }
                heap_A_p = delete_max(heap_A_p, heap_size_A);
                heap_size_A--;
                modulo = heap_A_p[1];


            //decode value
            current_value = UINT_MAX * divisionA + (unsigned long)modulo;

            if (counter_ret == k)
            {
                exit(0);
            }
        }
        //case if in 2nd heap are elements
        if(current_value >= col_guard && heap_size_B > 1)
        {
                modulo = heap_B_p[1];
                current_value = UINT_MAX * divisionB + (unsigned long)modulo;

            while (current_value >= col_guard && heap_size_B > 1)
            {
                if (prev_value != current_value)
                {   printf("%lu\n", current_value);
                    counter_ret++;
                }
                prev_value = current_value;
                if (heap_size_B < heap_B_max_size - HEAP_FRAME_SIZE && heap_B_fr > 1)
                {
                    heap_B_fr--;
                    heap_B_max_size = heap_B_fr * HEAP_FRAME_SIZE;
                    heap_B_p = heap_realloc(heap_B_p, heap_B_max_size);
                }
                heap_B_p = delete_max(heap_B_p, heap_size_B);
                heap_size_B--;
                modulo = heap_B_p[1];

                //decode value
                current_value = UINT_MAX * divisionB + (unsigned long)modulo;

                if (counter_ret == k)
                {
                    exit(0);
                }
            }
        }
        //case if in 3rd heap are elements
        if(current_value >= col_guard && heap_size_C > 1)
              {
            modulo = heap_C_p[1];
            current_value = UINT_MAX * divisionC + (unsigned long)modulo;
        while (current_value >= col_guard && heap_size_C > 1)
        {
            if (prev_value != current_value)
            {   printf("%lu\n", current_value);
                counter_ret++;
            }
            prev_value = current_value;
            //pop element
                if (heap_size_C < heap_C_max_size - HEAP_FRAME_SIZE && heap_C_fr > 1)
                {
                    heap_C_fr--;
                    heap_C_max_size = heap_C_fr * HEAP_FRAME_SIZE;
                    heap_C_p = heap_realloc(heap_C_p, heap_C_max_size);
                }
                heap_C_p = delete_max(heap_C_p, heap_size_C);
                heap_size_C--;
                modulo = heap_C_p[1];

            //decode value
            current_value = UINT_MAX * divisionC + (unsigned long)modulo;

            if (counter_ret == k)
            {
                exit(0);
            }
        }
        }
  

    }
    return 0;
}

unsigned int* heap_realloc(unsigned int* heap_p, unsigned int heap_max_size)
{
    heap_p = (unsigned int* )realloc(heap_p, heap_max_size * sizeof(unsigned int));
    return heap_p;
}


unsigned int* insert(unsigned int* heap_p, unsigned int heap_size, unsigned int e)
{
    heap_p[heap_size] = e;

    unsigned int k = heap_size;

    while (k > 1 && heap_p[k] > heap_p[k / 2])
    {
        swap(heap_p[k], heap_p[k / 2]);
        k /= 2;
    }

    return heap_p;
}

unsigned int* delete_max(unsigned int* heap_p, unsigned int heap_size)
{

    heap_p[1] = heap_p[heap_size - 1];
    heap_size--;

    heapify(1, heap_p, heap_size);

    return heap_p;
}

void heapify (unsigned int i, unsigned int* heap_p, unsigned int heap_size)
{
    unsigned int max_value, left, right;

    left = 2 * i;
    right = 2 * i + 1;

    if (left <= heap_size && heap_p[left] > heap_p[i])
        max_value = left; 
    else 
        max_value = i;

    if (right <= heap_size && heap_p[right] > heap_p[max_value])
        max_value = right;

    if (max_value != i)
    {
        swap(heap_p[i], heap_p[max_value]);
        heapify(max_value, heap_p, heap_size);
    }
}

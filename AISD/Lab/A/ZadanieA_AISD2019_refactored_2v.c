/*  Algorytmy i Struktury Danych 2019 - Pracownia
    Zadanie A
    Autor: Adam Kufel 
    Nr indeksu: 292345
*/

#include <stdio.h>

#define MIN(a, b) ( ( a < b) ? a : b ) 

int main()
{
    unsigned long sum, longest_road, road_ab, new_longest_road, max_value;
    int n;

    //data reading from stdin
    scanf("%d", &n);
    sum = longest_road = road_ab = 0;

    unsigned long d[n];

    for(int i=0; i<n; i++)
    {
        scanf("%ld", &d[i]);
        sum += d[i];
    }


    longest_road = MIN(d[0], sum - d[0]);
    road_ab = d[0];
    new_longest_road = longest_road;
    max_value = sum / 2;

    //algorithm
    int i = 0, j = 1;
    while (longest_road < max_value && i < n)
    {
        if (new_longest_road <= max_value)
        {
            road_ab += d[j++];
            if (j == n)
                j = 0;
        }

        else if (new_longest_road > max_value)
            road_ab -= d[i++];

        new_longest_road = road_ab;

        if (new_longest_road >= longest_road && new_longest_road <= max_value)
            longest_road = new_longest_road;
    }

    printf("%ld", longest_road);

    return 0;
}
/*  
    Algorytmy i Struktury Danych 2019 - Pracownia
    Zadanie D
    Autor: Adam Kufel 
    Nr indeksu: 292345
*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <limits.h>

#define MIN(a, b) ( ( a < b) ? a : b ) 
#define SORT_BY_1 1
#define SORT_BY_2 2

struct Point {
    int x;
    int y;
};

struct ClosestPoints {
    struct Point A;
    struct Point B;
    double distance;
};

double find_distance(struct Point A, struct Point B);
  
struct ClosestPoints find_closest_pairs(struct Point points[], int n);

void merge(struct Point points[], int p, int q, int r, int sort_flag_arg);
void mergesort(struct Point points[], int p, int r, int sort_flag_arg);

int main()
{
    //reading n from input
    int n;
    scanf("%d", &n);

    //reading points from input
    int a, b;
    struct Point points[n];
    struct ClosestPoints closest_pair_points;

    for(int i=0; i<n; i++)
    {
        scanf("%d %d", &a, &b);
        points[i].x = a;
        points[i].y = b;
    }

    mergesort(points, 0, n-1, SORT_BY_1);
    closest_pair_points = find_closest_pairs(points, n);

    printf("%d %d\n", closest_pair_points.A.x, closest_pair_points.A.y);
    printf("%d %d\n", closest_pair_points.B.x, closest_pair_points.B.y);   

    return 0;
}

struct ClosestPoints find_closest_pairs(struct Point points[], int n)
{
    // I. search closest pairs inside of both A, B sets
    if (n == 1)
    {
        struct ClosestPoints one_point;
        one_point.distance = __DBL_MAX__;
        one_point.A = points[0];
        return one_point;
    }

    if (n == 2)  
    {
        struct ClosestPoints AB;
        AB.distance = find_distance(points[0], points[1]);
        AB.A = points[0];
        AB.B = points[1];
        return AB;
    }


    struct ClosestPoints AB_left = find_closest_pairs(points, n/2);
    struct ClosestPoints AB_right = find_closest_pairs(points + n/2, n/2);
    struct ClosestPoints AB;

    if (AB_left.distance < AB_right.distance)
        AB = AB_left;
    else
        AB = AB_right;

    // II. search closest pairs between A, B sets
    struct Point MidPoint = points[n/2];

    struct Point points_between_line[n];      
    int points_between_line_size = 0;

    // creating Y set which contains points with distance 
    // (x coord) from mid point x < current min distance  
    int distance_from_mid_point;  
    for (int i = 0; i < n; i++)  
    {
        distance_from_mid_point = abs(points[i].x - MidPoint.x);
        if (distance_from_mid_point < AB.distance)  
        {
            points_between_line[points_between_line_size] = points[i]; 
            points_between_line_size++; 
        }
    }

    //sorting by y coord
    mergesort(points_between_line, 0, points_between_line_size -1, SORT_BY_2);

    struct ClosestPoints closest_points_between_line;
    closest_points_between_line.distance = AB.distance;

    for (int i = 0; i < points_between_line_size; i++)  
    {
        for (int j = 1; j < MIN(7, points_between_line_size - i); j++)  
        {
            if (find_distance(points_between_line[i], points_between_line[i + j]) < closest_points_between_line.distance)
            {
                closest_points_between_line.distance = find_distance(points_between_line[i], points_between_line[i + j]);  
                closest_points_between_line.A = points_between_line[i];
                closest_points_between_line.B = points_between_line[i + j];
            }  
        }
    }

    //return min from both inside/between sets searching results as final result
    if (AB.distance <= closest_points_between_line.distance)
        return AB;
    else
        return closest_points_between_line;

}

//helpers for custom sorting and finding distance between points
double find_distance(struct Point A, struct Point B)  
{  
    long p1x, p2x, p1y, p2y, distance; 

    p1x = (long)A.x, p2x = (long)B.x;
    p1y = (long)A.y, p2y = (long)B.y;

    distance = (p1x - p2x)*(p1x - p2x) + (p1y - p2y)*(p1y - p2y);

    return sqrt(distance);  
}  

void mergesort(struct Point points[], int p, int r, int sort_flag_arg)
{
    if (p != r)
    {
        int q = (p + r)/2;
        mergesort(points, p, q, sort_flag_arg);
        mergesort(points, q + 1, r, sort_flag_arg);
        merge(points, p, q, r, sort_flag_arg);
    }
}

void merge(struct Point points[], int p, int q, int r, int sort_flag_arg)
{
    struct Point temp[r - p];
    int i, j, k;
    k = 0;
    i = p;
    j = q + 1;

    while(i <= q && j <= r)
    {
        if (sort_flag_arg == SORT_BY_1) 
        {
            if (points[j].x < points[i].x)
            {
                temp[k] = points[j];
                j++;
            }
            else
            {
                temp[k] = points[i];
                i++;
            }
            k++;
        }
        if (sort_flag_arg == SORT_BY_2) 
        {
            if (points[j].y < points[i].y)
            {
                temp[k] = points[j];
                j++;
            }
            else
            {
                temp[k] = points[i];
                i++;
            }
            k++;
        }
    }
    
    if (i <= q)
    {
        while (i <= q)
        {
            temp[k] = points[i];
            i++;
            k++;
        }
    }
    else 
    {
        while (j <= r)
        {
            temp[k] = points[j];
            j++;
            k++;
        }
    }
    for (int h=0; h <= r - p; h++)
    {
        points[p + h] = temp[h];
    }
}
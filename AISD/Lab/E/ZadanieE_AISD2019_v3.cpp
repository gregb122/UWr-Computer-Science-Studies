/*  
    Algorytmy i Struktury Danych 2019 - Pracownia
    Zadanie E
    Autor: Adam Kufel 
    Nr indeksu: 292345
*/

#include <stdio.h>
#include <vector>

#define MIN(a, b) ( ( a < b) ? a : b ) 

using namespace std;

void dfs_T(pair<char, char> visited[], pair<int, int> R[], pair<vector<int>,bool> T[], int n);
pair<int, int> get_set_div_num(pair<char, char> visited[], pair<int, int> R[], pair<vector<int>,bool> T[], int n);

int main()
{
    //0. read n - size of input
    int n, a, b;
    scanf("%d", &n);

    //1. create adjacenty list representation of T
    pair<vector<int>, bool> T[n+1];

    for (int i=1; i<n; i++)
    {
        scanf("%d %d", &a, &b);
        T[a].first.push_back(b);
        T[b].first.push_back(a);
    }

    //2. mark each v if its leaf or not
    T[1].second = false; // root

    for (int i=2; i<=n; i++)
    {
        if (T[i].first.size() == 1)
        {
            T[i].second = true; //leaf
        }
        else
        {
            T[i].second = false;
        }
    }

    //3. process T with DFS
    pair<char, char> visited[n+1];

    for (int i=1; i<n+1; i++)
    {
        visited[i].first = 0; //for dfs
        visited[i].second = 0; //for processing results
    }


    pair<int, int> R[n+1];  //prepare array of pair with dynamic results

    dfs_T(visited, R, T, 1);

    printf("%d\n", MIN(R[1].first, R[1].second));  //print result

    return 0;
}

void dfs_T(pair<char, char> visited[], pair<int, int> R[] ,pair<vector<int>,bool> T[], int n)
{
    visited[n].first = 1; 

    for (vector<int>::iterator iter = T[n].first.begin(); iter != T[n].first.end(); iter++)
    {
        if (!visited[*iter].first)
        {
            dfs_T(visited, R, T, *iter);
        }
    }

    // printf("V-DFS ORDER: %d\n", n);

    if (T[n].second) //edge case for leaf
    {
        R[n].first = 1;
        R[n].second = 1;

        visited[n].second = 1;
    }
    else
    {
        R[n] = get_set_div_num(visited, R, T, n);
    }

}

pair<int, int> get_set_div_num(pair<char, char> visited[], pair<int, int> R[], pair<vector<int>,bool> T[], int n)
{
    pair<int, int> v_result;
    int v;
    int efficient_v;
    int number_of_efficient_v = 0;

    v_result.first = 0;
    v_result.second = 0;
    // first - result for subtree(root=v), when v is connected with another 1 vertice
    // second - result for subtree(root=v), when v is connected with another 2 vertices

    for (vector<int>::iterator iter = T[n].first.begin(); iter != T[n].first.end(); iter++)
    {
        if (visited[*iter].second)
        {
            if (R[*iter].second == R[*iter].first && number_of_efficient_v < 2)
            {
                efficient_v = *iter;
                number_of_efficient_v += 1;
                v_result.first += R[efficient_v].first;
                v_result.second += R[efficient_v].first;
            }
            else
            {
                v = *iter;
                v_result.first += R[v].second;
                v_result.second += R[v].second;
            }
        }
    }

    if (number_of_efficient_v == 0)
    {
        v_result.first += 1;
        v_result.second += 2;
    }
    else if (number_of_efficient_v == 1)
    {
        v_result.second += 1;
    }

    v_result.second -= 1;

    visited[n].second = 1;

    return v_result;
}
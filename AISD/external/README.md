# Algorytmy i struktury danych 2020

# Linki 
* [Wykład](https://sites.google.com/a/cs.uni.wroc.pl/aisd/?pli=1) - strona wykładu
* [Wykład KLo](https://www.youtube.com/playlist?list=PL-8S7CQuqZzyAIGwj7yKRyNH1Hrf7dY3L) - nagrania wykładów
* [Pracownia](http://www.ii.uni.wroc.pl/~mbi/dyd/aisd_20s/) - treści zadań, wyniki (aisd / wyniki.2020)
* [Sprawdzaczka](https://aisd.ii.uni.wroc.pl/main.pl) - wrzucanie rozwiązań pracowni
* [Themis](https://themis.ii.uni.wroc.pl)

#### Notatki do wykładu
Notatki prowadzę na podstawie wykładów w taki sposób, by przygotowując się do egzaminu, wystarczyły mi notatki KLo i moje (brak konieczności powrotu do czasochłonnych materiałów wideo). Stąd notatki są bardzo szczegółowe, prawie transkrypt. Lista **spisanych** wykładów: 0, 1, 2, 3, 4, 5, 6, 7, **8**, 9, **10**, 11 WIP, **12**, **13**, **14**, **15**, **16**, **17**, 18, 20, 21, 22, 23, 24.

#### Wykłady MIT
* [Introduction to Algorithms](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-006-introduction-to-algorithms-fall-2011/lecture-videos/)
* [Design and Analysis of Algorithms](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-046j-design-and-analysis-of-algorithms-spring-2015/lecture-videos/?fbclid=IwAR2gK8l0oPDjYF4CY-dFztuSyAtyRHuSak_D-93ANJPJgbxyijiTFJy6GlM)


# Ćwiczenia (SDUD)
[wideo](https://drive.google.com/drive/folders/1mdioAWOESoZbitvsvGxtMx8pjNm_p_Qc?fbclid=IwAR035ixuy15NNQuqBz_zpJqZDjdmepqOKHT41hYDQqwWwMExLIqqJPaK__w)
* [L1, L2](https://hackmd.io/vAdDbVT6QCuIk6r7Ef6_tg) - 31.03.2020 
* [L2](https://hackmd.io/NqseJUN-QGyB5y3McIPyLg) - 07.04.2020
* [L2, L3](https://hackmd.io/dF73Gk6HRaKeNz7SqjsOPg?both) - 20.04.2020
* [L3, L4](https://hackmd.io/7kpZgn45R7WbMqoiBwtL3A) - 28.04.2020
* [L4](https://hackmd.io/zld-hKqmRuOPyxaTTHESPA) - 12.05.2020
* [L5](https://hackmd.io/OZ9-ITVeRa6yjHZi-Hlj8g) - 20.05.2020

# Wykłady 

## Wykłady stacjonarne

#### Wykład -1 - "już wiemy"
* zagadnienia: 
    * sortowanie: mergesort
    * Euklides zwykły i rozszerzony
    * DFS, BFS 
    * MST: Prim, Kruskal
    * Dijkstra, Bellman-Ford - znajdowanie najkrótszych ścieżek w grafe od zadanego źródła
    * Warshall-Floyd - znajdowanie najkrótszych ścieżek między wszystkimi parami wierzchołków
    * Ford-Fulkerson - znajdowanie maksymalnego przepływu w sieci
* MIT:
    * [Depth-First Search (DFS), Topological Sort](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-006-introduction-to-algorithms-fall-2011/lecture-videos/lecture-14-depth-first-search-dfs-topological-sort/)
    * [Breadth-First Search (BFS)](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-006-introduction-to-algorithms-fall-2011/lecture-videos/lecture-13-breadth-first-search-bfs/)
    *  [Dijkstra](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-006-introduction-to-algorithms-fall-2011/lecture-videos/lecture-16-dijkstra/), [Speeding up Dijkstra](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-006-introduction-to-algorithms-fall-2011/lecture-videos/lecture-18-speeding-up-dijkstra/)
    *  [Bellman-Ford](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-006-introduction-to-algorithms-fall-2011/lecture-videos/lecture-17-bellman-ford/)
    *  [Warshall-Floyd](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-046j-design-and-analysis-of-algorithms-spring-2015/lecture-videos/lecture-11-dynamic-programming-all-pairs-shortest-paths/)

#### Wykład 0 - Preliminaria (26.02.2020)
* [notatka](https://github.com/annakaras/aisd/blob/master/Wykład/Notatki%20KLo/1.%20Preliminaria.pdf)
* zagadnienia:
    * mnożenie po rosyjsku
    * metoda macierzowa obl. liczb Fib.
    * kryteria wyznaczania złożoności alg.: jednorodne i logarytmiczne
    * sortowanie: bubble, insert, select
    * sortowanie stabilne 
    * notacje rzędów funkcji: O, o, theta, omega 

#### Wykład 1 - Kopiec (27.02.2020)
* notatki: [KLo](https://github.com/annakaras/aisd/blob/master/Wykład/Notatki%20KLo/2.%20Kopiec.pdf), [studenci](https://github.com/annakaras/aisd/blob/master/Wykład/Notatki%20KLo/2.%20Kopiec%20-%20notatka.pdf)
* zagadnienia:
    * kopiec def.
    * heapsort
* MIT: [Heaps and Heap Sort](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-006-introduction-to-algorithms-fall-2011/lecture-videos/lecture-4-heaps-and-heap-sort/)

#### Wykład 2 - Algorytmy zachłanne (04.03.2020)
* notatki: [KLo](https://github.com/annakaras/aisd/blob/master/Wykład/Notatki%20KLo/3.%20Algorytmy%20zachłanne.pdf), [studenci](https://github.com/annakaras/aisd/blob/master/Wykład/Notatki%20KLo/3.%20Algorytmy%20zachłanne%20-%20notatka.pdf)
* zagadnienia:
    * wydawanie reszty
    * MST: Prim, Kruskal (dowód), Boruvka
    * set cover
    * szeregowanie zadań
* MIT: [Greedy Algorithms: Minimum Spanning Tree](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-046j-design-and-analysis-of-algorithms-spring-2015/lecture-videos/lecture-12-greedy-algorithms-minimum-spanning-tree/)

#### Wykład 3 - Dziel i zwyciężaj (05.03.2020)
* notatki: [KLo](https://github.com/annakaras/aisd/blob/master/Wykład/Notatki%20KLo/4.%20Dziel%20i%20zwyciężaj.pdf), [studenci](https://github.com/annakaras/aisd/blob/master/Wykład/Notatki%20KLo/4.%20Dziel%20i%20zwyciężaj%20-%20notatka.pdf)
* zagadnienia:
    * mergesort
    * Master's Theorem (tw. o rekurencji uniwersalnej)
    * mnożenie dużych liczb (alg. Karatsuby)
* MIT: 
    * [Insertion Sort, Merge Sort](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-006-introduction-to-algorithms-fall-2011/lecture-videos/lecture-3-insertion-sort-merge-sort/)    
    * [Integer Arithmetic, Karatsuba Multiplication](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-006-introduction-to-algorithms-fall-2011/lecture-videos/lecture-11-integer-arithmetic-karatsuba-multiplication/)
    * [Divide & Conquer: Convex Hull, Median Finding](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-046j-design-and-analysis-of-algorithms-spring-2015/lecture-videos/lecture-2-divide-conquer-convex-hull-median-finding/)

#### ~~Wykład (11.03.2020)~~ koronaferie

#### ~~Wykład (12.03.2020)~~ koronaferie

#### ~~Wykład (18.03.2020)~~ koronaferie

#### ~~Wykład (19.03.2020)~~ koronaferie

## Wykłady zdalne

#### Wykład 4 - Dziel i zwyciężaj cd. (25.03.2020)
* [notatka](https://github.com/annakaras/aisd/blob/master/Wykład/Notatki%20KLo/5.%20Dziel%20i%20zwyciężaj%20cd.pdf)
* zagadnienia:
    * sieć permutacyjna Benesa-Waksmana
    * najbliżej położona para punktów

#### Wykład 5 - Programowanie dynamiczne (26.03.2020)
* [notatka](https://github.com/annakaras/aisd/blob/master/Wykład/Notatki%20KLo/6.%20Programowanie%20dynamiczne.pdf)
* [wykład](https://www.youtube.com/watch?v=db6XOWgBkzo&list=PL-8S7CQuqZzyAIGwj7yKRyNH1Hrf7dY3L&index=2&t=0s)
* zagadnienia:
    * spamiętywanie
    * obliczanie współczynnika dwumianowego
    * przejście przez tablicę kwadratową
    * kolejność mnożenia macierzy
* MIT: 
    * [Dynamic Programming I: Fibonacci, Shortest Paths](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-006-introduction-to-algorithms-fall-2011/lecture-videos/lecture-19-dynamic-programming-i-fibonacci-shortest-paths/)
    * [Dynamic Programming II: Text Justification, Blackjack](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-006-introduction-to-algorithms-fall-2011/lecture-videos/lecture-20-dynamic-programming-ii-text-justification-blackjack/)
    * [Dynamic Programming III: Parenthesization, Edit Distance, Knapsack](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-006-introduction-to-algorithms-fall-2011/lecture-videos/lecture-21-dp-iii-parenthesization-edit-distance-knapsack/)
    * [Dynamic Programming IV: Guitar Fingering, Tetris, Super Mario Bros.](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-006-introduction-to-algorithms-fall-2011/lecture-videos/lecture-22-dp-iv-guitar-fingering-tetris-super-mario-bros/)
    * [Dynamic Programming: Advanced DP](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-046j-design-and-analysis-of-algorithms-spring-2015/lecture-videos/lecture-10-dynamic-programming-advanced-dp/)

#### Wykład 6 - Programowanie dynamiczne cd. (01.04.2020)
* [notatka](https://github.com/annakaras/aisd/blob/master/Wykład/Notatki%20KLo/7.%20Programowanie%20dynamiczne%20-%20cd.pdf)
* [wykład](https://www.youtube.com/watch?v=mh1qfMJa2EA&list=PL-8S7CQuqZzyAIGwj7yKRyNH1Hrf7dY3L&index=2)
* zagadnienia:
    * Przynależność do języka bezkontekstowego
    * Drzewa rozpinające drabin

#### Wykład 7 - Programowanie dynamiczne cd. (02.04.2020)
* [notatka](https://github.com/annakaras/aisd/blob/master/Wykład/Notatki%20KLo/7.%20Programowanie%20dynamiczne%20-%20cd.pdf)
* [wykład](https://www.youtube.com/watch?v=DVujoJxk3cM&list=PL-8S7CQuqZzyAIGwj7yKRyNH1Hrf7dY3L&index=3)
* zagadnienia:
    * problem plecakowy (z powtórzeniami, bez powtórzeń)
    * problemy NP-zupełne
* MIT: 
    * [Computational Complexity](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-006-introduction-to-algorithms-fall-2011/lecture-videos/lecture-23-computational-complexity/)
    * [Complexity: P, NP, NP-completeness, Reductions](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-046j-design-and-analysis-of-algorithms-spring-2015/lecture-videos/lecture-16-complexity-p-np-np-completeness-reductions/)

#### Wykład 8 - Dolne granice (08.04.2020)
* notatki: [KLo](https://github.com/annakaras/aisd/blob/master/Wykład/Notatki%20KLo/8.%20Dolne%20granice.pdf), [AK](https://github.com/annakaras/aisd/tree/master/Wyk%C5%82ad/Notatki%20do%20wyk%C5%82adu/8.%20Dolne%20granice)
* wykład: [wstęp](https://youtu.be/DVujoJxk3cM?t=4521), [ciąg dalszy](https://youtu.be/cKrKKSnIHc0?t=114)
* zagadnienia:
    * dolne granice
    * gra z adwersarzem
    * liniowe drzewa decyzyjne
* MIT: [Counting Sort, Radix Sort, Lower Bounds for Sorting](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-006-introduction-to-algorithms-fall-2011/lecture-videos/lecture-7-counting-sort-radix-sort-lower-bounds-for-sorting/)

#### Wykład 9 - Sortowanie (09.04.2020)
* notatki: [KLo](https://github.com/annakaras/aisd/blob/master/Wykład/Notatki%20KLo/9.%20Sortowanie.pdf), [Cormen](https://github.com/annakaras/aisd/blob/master/Wykład/Notatki%20KLo/9.%20Sortowanie%20-%20cd.pdf)
* [wykład](https://www.youtube.com/watch?v=miSNXlx3RIY&list=PL-8S7CQuqZzyAIGwj7yKRyNH1Hrf7dY3L&index=5)
* zagadnienia:
    * sortowanie przez zliczanie
    * sortowanie kubełkowe
    * sortowanie leksykograficzne
    * izomorfizm drzew
* MIT: [Counting Sort, Radix Sort, Lower Bounds for Sorting](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-006-introduction-to-algorithms-fall-2011/lecture-videos/lecture-7-counting-sort-radix-sort-lower-bounds-for-sorting/)

#### ~~Wykład (15.04.2020)~~ przerwa świąteczna
    
#### Wykład 10 - Quicksort (16.04.2020)
* notatki: [KLo](https://github.com/annakaras/aisd/blob/master/Wykład/Notatki%20KLo/10.%20Quicksort.pdf), AK
* [wykład](https://www.youtube.com/watch?v=pdBXR68ONeM&list=PL-8S7CQuqZzyAIGwj7yKRyNH1Hrf7dY3L&index=6)
* zagadnienia:
    * metody wyboru pivota
    * analiza czasu oczekiwanego działania
    * usprawnienia quicksorta
* MIT: [Randomization: Matrix Multiply, Quicksort](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-046j-design-and-analysis-of-algorithms-spring-2015/lecture-videos/lecture-6-randomization-matrix-multiply-quicksort/)

#### Wykład 11 - Selekcja (22.04.2020)
* notatki: [KLo](https://github.com/annakaras/aisd/blob/master/Wykład/Notatki%20KLo/11.%20Selekcja.pdf), AK (work in progress)
* [wykład](https://www.youtube.com/watch?v=7bafs7PSWkU&list=PL-8S7CQuqZzyAIGwj7yKRyNH1Hrf7dY3L&index=7)
* zagadnienia:
    * znajdowanie drugiego co do wielkości elementu
    * algorytm magicznych piątek
    * algorytm Hoare'a
    * algorytm Lazy Select

#### Wykład 12 - Drzewa zbalansowane (23.04.2020)
* notatki: [KLo](https://github.com/annakaras/aisd/blob/master/Wykład/Notatki%20KLo/12.%20Drzewa%20Avl.pdf), [AK](https://github.com/annakaras/aisd/tree/master/Wykład/Notatki%20do%20wykładu/12.%20Drzewa%20AVL)
* [wykład](https://www.youtube.com/watch?v=08okPH7-U9s&list=PL-8S7CQuqZzyAIGwj7yKRyNH1Hrf7dY3L&index=8)
* zagadnienia: drzewa AVL
* MIT: [AVL Trees, AVL Sort](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-006-introduction-to-algorithms-fall-2011/lecture-videos/lecture-6-avl-trees-avl-sort/)

#### Wykład 13 - Drzewa zbalansowane cd. (29.04.2020)
* notatki KLo: [drzewa cz-cz](https://github.com/annakaras/aisd/blob/master/Wykład/Notatki%20KLo/13.%20Drzewa%20czerwono-czarne.pdf), [b-drzewa](https://github.com/annakaras/aisd/blob/master/Wykład/Notatki%20KLo/14.%20B-drzewa.pdf)
* notatki AK: [drzewa cz-cz](https://github.com/annakaras/aisd/tree/master/Wykład/Notatki%20do%20wykładu/13.%20Drzewa%20czerwono-czarne), [b-drzewa](https://github.com/annakaras/aisd/tree/master/Wykład/Notatki%20do%20wykładu/14.%20B-drzewa)
* [wykład](https://www.youtube.com/watch?v=TVnADwzeOA8&list=PL-8S7CQuqZzyAIGwj7yKRyNH1Hrf7dY3L&index=9)
* zagadnienia:
    * drzewa czerwono-czarne
    * b-drzewa
    * 1-2-3 drzewa

#### Wykład 14 - Kopce dwumianowe (30.04.2020)
* notatki: [KLo](https://github.com/annakaras/aisd/blob/master/Wykład/Notatki%20KLo/15.%20Kopce%20dwumianowe.pdf), [AK](https://github.com/annakaras/aisd/tree/master/Wykład/Notatki%20do%20wykładu/15.%20Kopce%20dwumianowe)
* [wykład](https://www.youtube.com/watch?v=n7xIrsbAwlg&list=PL-8S7CQuqZzyAIGwj7yKRyNH1Hrf7dY3L&index=10)
* zagadnienia:
    * kopce dwumianowe
    * analiza zamortyzowana
* MIT: [Amortization: Amortized Analysis](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-046j-design-and-analysis-of-algorithms-spring-2015/lecture-videos/lecture-5-amortization-amortized-analysis/)

#### Wykład 15 - Kopce Fibonacciego (06.05.2020)
* notatki: [KLo](https://github.com/annakaras/aisd/blob/master/Wykład/Notatki%20KLo/16.%20Kopce%20Fibonacciego.pdf), [AK](https://github.com/annakaras/aisd/tree/master/Wykład/Notatki%20do%20wykładu/16.%20Kopce%20Fibonacciego)
* [wykład](https://youtu.be/ndSTQNG8rQ8)

#### ~~Wykład (07.05.2020)~~ dydaktyczny piątek

#### Wykład 16 - Drzewa zbalansowane cd. (13.05.2020)
* notatki: [KLo](https://github.com/annakaras/aisd/blob/master/Wykład/Notatki%20KLo/17.%20Drzewa%20splay.pdf), [AK](https://github.com/annakaras/aisd/tree/master/Wyk%C5%82ad/Notatki%20do%20wyk%C5%82adu/17.%20Drzewa%20Splay)
* [wykład](https://youtu.be/PpSJS7aL4KE)
* zagadnienia: drzewa Splay

#### Wykład 17 - Union-find (14.05.2020)
* notatki: [KLo](https://github.com/annakaras/aisd/blob/master/Wykład/Notatki%20KLo/18.%20Union%20find.pdf), [AK](https://github.com/annakaras/aisd/tree/master/Wyk%C5%82ad/Notatki%20do%20wyk%C5%82adu/18.%20Union%20Find)
* [wykład](https://www.youtube.com/watch?v=PnpLU1o0MfY&list=PL-8S7CQuqZzyAIGwj7yKRyNH1Hrf7dY3L&index=14&t=0s)

#### Wykład 18 - Haszowanie (20.05.2020)

* notatki: [KLo](https://github.com/annakaras/aisd/blob/master/Wyk%C5%82ad/Notatki%20KLo/19.%20Haszowanie.pdf), AK 
* [wykład](https://youtu.be/TshEUnrxBjE)

#### ~~Wykład (21.05.2020)~~ odwołany

Wykład 19 - (27.05.2020)

Wykład 20 - (28.05.2020)

Wykład 21 - (03.06.2020)

Wykład 22 - (04.06.2020)

#### ~~Wykład (10.06.2020)~~ dydaktyczny piątek

#### ~~Wykład (11.06.2020)~~ Boże Ciało

Wykład 23 - (17.06.2020)

Wykład 24 - (18.06.2020)

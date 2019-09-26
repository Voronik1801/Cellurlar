#include "bmp.h"
#include <chrono>
#include <omp.h>
#include <string>
#include <fstream>
#pragma warning(disable : 4996)

int const WIDTH = 1000, HEIGHT = 500; //размер клеточного поля

#define rad 2                         // осреднение по окрестности
#define linerad 3                     // осреднение по столбцу
#define Count 16                      // колличество копий
#define Iter 300                     // колличество итераций
#define T 4                           // количество потоков

int picture(int [][HEIGHT][WIDTH], Bmp &, int);
void plot();

#define bitUP  1
#define bitRIGHT  2
#define bitDOWN  4
#define bitLEFT  8
#define bitSTABLE 16
#define bitSTABLE2 32

#define PS_Width 64
#define PS_Hight 64
#define Size 64

template <typename Type1>
void INIT_RULE_S(Type1 count_s[Size], Type1 Rule_S[PS_Hight][PS_Width]);
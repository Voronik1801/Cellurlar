#include "bmp.h"
#include <chrono>
#include <omp.h>
#include <string>
#include <fstream>
#pragma warning(disable : 4996)

int const WIDTH = 1000, HEIGHT = 500; //размер клеточного поля

#define rad 2                         // осреднение по окрестности
#define linerad 5                     // осреднение по столбцу
#define Count 8                      // колличество копий
#define Iter 200                     // колличество итераций
#define T 4                           // количество потоков

int picture(int ***, int);
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
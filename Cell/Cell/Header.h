#include "bmp.h"
#include <chrono>
#include <omp.h>
#include <string>
#include <fstream>
#pragma warning(disable : 4996)

int const WIDTH = 1000, HEIGHT = 500; //������ ���������� ����

#define rad 2                         // ���������� �� �����������
#define linerad 5                     // ���������� �� �������
#define Count 12                      // ����������� �����
#define Iter 1000                     // ����������� ��������
#define T 4                           // ���������� �������

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
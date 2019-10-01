#include <stdio.h>
#include <stdlib.h>
#include "Header.h"
#include <iostream>
#include <fstream>
using namespace std;

int m[HEIGHT][WIDTH];          // движ. частицы
int r[HEIGHT][WIDTH];          // ч. покоя
double dens_M[HEIGHT][WIDTH];  // сред. масса движ. частиц
double dens_R[HEIGHT][WIDTH];  // сред. масса ч. покоя
double columns[WIDTH];         // сред. значение по столбцу
char begin_state[HEIGHT][WIDTH];
extern char** beg_state;
double diagram[2][(int)(Iter/10.0) + 1];
double diag[(int)(Iter / 10.0) + 1];
extern int h, w;
Bmp image(WIDTH, HEIGHT);

double NumRound(double d) // округление до десятых
{
   return (((d * 10.0 - floor(d * 10.0)) >= 0.5) ? ceil(d * 10.0) : floor(d * 10.0)) / 10.0;
}

void waveSpeed(double a[WIDTH], int iter)
{
   double min = 11, max = 0, aver;
   int j = 0, s[2] = {}, e[2] = {}, k = 0; //start, end of wave

   ofstream out;
   if (iter == 0)
      out.open("diagram4.txt");
   else
      out.open("diagram4.txt", std::ofstream::app);

   for (int i = linerad; i < WIDTH - linerad; i++) 
   {
      if (a[i] > max)
         max = a[i];
      if (a[i] < min)
         min = a[i];
   }
   aver = (max + min) / 2.0;
   while (j < WIDTH) // нахождение точек пересечения волны и средней линии
   {
      while (a[j] - 0.05 < aver && j < WIDTH)
         j++;
      s[k] = j == WIDTH ? 0 : j;
      while (a[j] + 0.05 > aver && j < WIDTH)
         j++;
      e[k] = j == WIDTH ? 0 : j;
      k++;
      if (k == 2)
         break;
   }
   double peak1[2], peak2[2]; // вершины волны

   k = 0;
   int i;
   while (e[k] != 0) // если есть волна, пересекаяющая среднюю линию
   {
      for (i = s[k], j; i <= e[k]; i++) // пробегает от начала пересечения до конца
      {
         while (NumRound(a[i]) <= NumRound(a[i + 2]) && i < e[k] - 3) // монотонно увеличивается
            i += 2;
         while (NumRound(a[i]) >= NumRound(a[i + 2]) && i < e[k] - 3) // монотонно уменьшается
            i += 2;
         peak1[k] = (s[k] + i) / 2.0; // индекс центра волны
         j = i;   // конец первой волны, начало второй, в случае когда волна не разошлась
         while (NumRound(a[i]) <= NumRound(a[i + 2]) && i < e[k] - 3) // монотонно увеличивается
            i += 2;
         while (NumRound(a[i]) >= NumRound(a[i + 2]) && i < e[k] - 3) // монотонно уменьшается
            i += 2;
         i != j ? peak2[k] = (e[k] + j) / 2.0 : peak2[k] = peak1[k]; // индекс второй волны, если i j совпадают волна не распалась или на этом промежутке
                                                                     // больше нет волны
         i = e[k];           // конец волны, выход из цикла
      }
      k++;     // k = 1 случай когда волна разделилась на две. пересечение с сред линией даёт 2 отрезка
      if (k == 2)
         break;
   }
   if (s[1] == 0 && e[1] == 0) // одна вола
   {
      out << iter << " " << peak1[0] << " " << peak2[0] << endl; //  remove
      diagram[0][(int)(iter / 10.0)] = peak1[0];
      diagram[1][(int)(iter / 10.0)] = peak2[0];
   }
   else                        // две волны
   {
      out << iter << " " << peak1[0] << " " << peak1[1] << endl; // remove
      diagram[0][(int)(iter / 10.0)] = peak1[0];
      diagram[1][(int)(iter / 10.0)] = peak1[1];
   }

   out.close();
}

void sum(double c[][WIDTH], int a[][WIDTH])
{
   int q;
   omp_set_num_threads(T);
#pragma omp parallel for private (q)
   for (int m = 0; m < HEIGHT; m++)
      for (q = 0; q < WIDTH; q++)
         c[m][q] += a[m][q];
}

void columnAver(double a[][WIDTH], double b[][WIDTH], double c[WIDTH], int iter) // а - массив масс (движ + покой)
{
   ofstream out;
   string avercol = "avercol" + to_string(iter) + ".txt";
   out.open(avercol);
   int t;
   for (int i = 0; i < WIDTH; i++)
   {
      if (i - linerad < 0 || i + linerad >= WIDTH)
         continue;
      for (int j = 0; j < HEIGHT; j++)  
         for (t = i - linerad; t <= i + linerad; t++)
               c[i] += a[j][t] + b[j][t];    
      c[i] /= (HEIGHT * (2 * linerad + 1));
      out << i << " " << c[i] << endl;
   }
   out.close();
}

void rounding(double c[][WIDTH], double a[][WIDTH])
{
   double s;
   int q, i, j;
   omp_set_num_threads(T);
#pragma omp parallel for private (s, q, i, j)
   for (int m = 0; m < HEIGHT; m++)
   {
      s = 0;
      for (q = 0; q < WIDTH; q++)
      {
         if (m - rad < 0 || q - rad < 0 || m + rad > HEIGHT - 1 || q + rad > WIDTH - 1)
            continue;
         else
            for (i = m - rad; i <= m + rad; i++)
               for (j = q - rad; j <= q + rad; j++)
                  s += a[i][j];
         s /= (double)((2 * rad + 1) * (2 * rad + 1));
         c[m][q] += s;
         s = 0;
      }
   }
}

void separate(int a[][WIDTH], int m[][WIDTH], int r[][WIDTH])
{
   int k = 0, t = 0, n, q, i;
   omp_set_num_threads(T);
#pragma omp parallel for private (k, t, n, q, i)
   for (int w = 0; w < HEIGHT; w++)
   {
      k = t = 0;
      for (q = 0; q < WIDTH; q++)
      {
         n = a[w][q];
         for (i = 0; i < 4; i++)
         {
            k += n & 1;
            n = n >> 1;
         }
         for (i = 0; i <= 2; i++)
         {
            t += (1 << i) * (n & 1);
            n = n >> 1;
         }
         m[w][q] = k;
         r[w][q] = 2 * t;
         t = k = 0;
      }
   }
}

int gett(int n)
{
   int k = 0, t=0;
   for (int i = 0; i < 4; i++)
   {
      k += n & 1;
      n = n >> 1;
   }
   for (int i = 0; i <= 2; i++)
   {
      t += (1 << i) * (n & 1);
      n = n >> 1;
   }
   return k + 2 * t;
}

int picture(int a[][HEIGHT][WIDTH], int iter)
{
   double aver_m[HEIGHT][WIDTH] = {}; 
   double aver_r[HEIGHT][WIDTH] = {};

   for (int i = 0; i < Count; i++)
   {
      separate(a[i], m, r); // разделение на движущиеся и покоя
      sum(aver_m, m);       // суммирование
      sum(aver_r, r); 
   }
   
   omp_set_num_threads(T);
#pragma omp parallel for
   for (int i = 0; i < HEIGHT; i++)  // ансамблирование
      for (int j = 0; j < WIDTH; j++)
      {
         aver_m[i][j] = aver_m[i][j] / Count; 
         aver_r[i][j] = aver_r[i][j] / Count;
      }

   memset(dens_R, 0, sizeof(double) * HEIGHT * WIDTH);
   memset(dens_M, 0, sizeof(double) * HEIGHT * WIDTH);
   memset(columns, 0, sizeof(double) * WIDTH);

   columnAver(aver_m, aver_r, columns, iter); //осреднение по столбцам
   waveSpeed(columns, iter); // скорость волны
   rounding(dens_M, aver_m); // осреднение по окрестности
   rounding(dens_R, aver_r);

   for (int i = 0; i < HEIGHT; i++)
      for (int j = 0; j < WIDTH; j++) 
         if (begin_state[i][j] == '1')
            image.setPixel(j, i, 255, 60, 60); // нарисовать зеркало
         else 
            image.setPixel(j, i, 0, (int)(255.0 / 10.0 * (dens_M[i][j] + dens_R[i][j])), (int)(255.0 / 10.0 * dens_R[i][j])); // draw picture

   string errMsg;
   string fileName = "pictFromIter" + to_string( iter ) + ".bmp";

   if (!image.write(fileName, errMsg))
      std::cout << errMsg << std::endl;
   else
      std::cout << "Successfully wrote file: [" << fileName << "]" << std::endl;

   return 0;
}

void plot()
{
   ofstream com;         // график плотностей
   com.open("commands.txt");
   com << "set terminal png size 1280, 600" << endl;
   com << "set output '" << "graph" << ".png'" << endl;
   com << "set xlabel \"Width\"" << endl;
   com << "set ylabel \"Weight\"" << endl;
   com << "set title \"Graph ("<< Iter << " iterations)\"" << endl;
   com << "set nokey" << endl;
   com << "set xtic (0,100,200,300,400,500,600,700,800,900,1000)" << endl;
   com << "set grid" << endl;
   com << "plot [0:1000][0.5:11] ";
   for (int i = 0; i <= Iter; i = i + 10) // Iter
   {
      com << "'avercol" << i << ".txt'" << " u 1:2 w lines";
      i + 10 <= Iter ? com << ", " : com << endl;
   }
   com.close();
   system("cd.");
   system("\"C:\\Program Files\\gnuplot\\bin\\gnuplot.exe\" C:\\Users\\SergeyP\\source\\repos\\CA3\\CA3\\commands.txt");

   ofstream out2; // скорость волны. оформление данных
   out2.open("Diagram.txt");
   out2 << 0 << " " << 0 << " " << 0 << endl;
   double c1, c2;
   for (int i = 1; i < (int)(Iter / 10); i+=2)
   {
      c1 = (double)(diagram[0][i - 1] - diagram[0][i]) / 10.0;
      c2 = (double)(diagram[1][i] - diagram[1][i - 1]) / 10.0;
      if (i < 10)
         out2 << i * 10 << " " << c1 << " " << c2 << endl;
      else  // remove
         if (abs(c1) < 1 && abs(c2) < 1)  
            out2 << i * 10 << " " << c1 << " " << c2 << endl;

   }
   out2.close();

   ofstream leftw;  // скорость левой волны
   leftw.open("commandsl.txt"); 
   leftw << "set output '" << "diagram_left" << ".png'" << endl;
   leftw << "set terminal png size 1280, 600" << endl;
   leftw << "set xlabel \"Iterations\"" << endl;
   leftw << "set ylabel \"Difference\"" << endl;
   leftw << "set title \"Speed to iteration ratio for left wave\"" << endl;
   leftw << "set grid" << endl;
   leftw << "plot [0:" <<Iter<< "][:] 'diagram.txt' u 1:2 w lines";
   leftw.close();
   system("cd.");
   system("\"C:\\Program Files\\gnuplot\\bin\\gnuplot.exe\" C:\\Users\\SergeyP\\source\\repos\\CA3\\CA3\\commandsl.txt");

   ofstream rightw;  // скорость правой волны
   rightw.open("commandsr.txt");
   rightw << "set output '" << "diagram_right" << ".png'" << endl;
   rightw << "set terminal png size 1280, 600" << endl;
   rightw << "set xlabel \"Iterations\"" << endl;
   rightw << "set ylabel \"Difference\"" << endl;
   rightw << "set title \"Speed to iteration ratio for right wave\"" << endl;
   rightw << "set grid" << endl;
   rightw << "plot [0:" << Iter << "][:] 'Diagram.txt' u 1:3 w lines";
   rightw.close();
   system("cd.");
   system("\"C:\\Program Files\\gnuplot\\bin\\gnuplot.exe\" C:\\Users\\SergeyP\\source\\repos\\CA3\\CA3\\commandsr.txt");

   ofstream common; // скорость волны
   common.open("commandsCom.txt");
   common << "set output '" << "diagram_Com" << ".png'" << endl;
   common << "set terminal png size 1280, 600" << endl;
   common << "set xlabel \"Iterations\"" << endl;
   common << "set ylabel \"Difference\"" << endl;
   common << "set title \"Compair speed left and right waves\"" << endl;
   common << "set grid" << endl;
   common << "plot [0:" << Iter << "][-0.5:2] 'Diagram.txt' u 1:2 w lines title \"LEFT\", 'Diagram.txt' u 1:3 w lines title \"RIGHT\" " ;
   common.close();
   system("cd.");
   system("\"C:\\Program Files\\gnuplot\\bin\\gnuplot.exe\" C:\\Users\\SergeyP\\source\\repos\\CA3\\CA3\\commandsCom.txt");
}

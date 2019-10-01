#include <iostream>
#include <conio.h>
#include "Header.h"
#include <fstream>
using namespace std;

//int state_next_s[Count][HEIGHT][WIDTH] ; //копия для итераций
//int state_3[Count][HEIGHT][WIDTH];
int S[PS_Hight][PS_Width];
double P_0_1[PS_Hight][PS_Width];
double P_0_5[PS_Hight][PS_Width];
double P_0_9[PS_Hight][PS_Width];
int count_s[Size];
//char begin_state[HEIGHT][WIDTH];
//double fl[HEIGHT][WIDTH];
char** beg_state;
float** den_state;
int*** state_31;
int*** state_n_3;
int h, w;
FILE *file;
fstream f;

void FILL() //заполнение массива начальных состояний, средними массами
{  
   state_n_3 = new int**[Count];
   state_31 = new int**[Count];
   for (int k = 0; k < Count; k++)
   {
      state_n_3[k] = new int* [h] {0};
      state_31[k] = new int* [h] {0};
      for (int i = 0; i < h; i++)
      {
         state_n_3[k][i] = new int[w] {0};
         state_31[k][i] = new int[w] {0};
      }
   }
  
   double r;
   int j;
   omp_set_num_threads(T);
   for (int k = 0; k < Count; k++)
   {
#pragma omp parallel for private (r, j)
      for (int i = 0; i < HEIGHT; i++)
      {
         for (j = 0; j < WIDTH; j++)
         {
            // added parentheses ((d)(r)+1)
            r = den_state[i][j] / 10;
            if (((double)(rand() % 100) + 1) / 101 < r) state_31[k][i][j] |= bitUP;
            if (((double)(rand() % 100) + 1) / 101 < r) state_31[k][i][j] |= bitRIGHT;
            if (((double)(rand() % 100) + 1) / 101 < r) state_31[k][i][j] |= bitDOWN;
            if (((double)(rand() % 100) + 1) / 101 < r) state_31[k][i][j] |= bitLEFT;
            if (((double)(rand() % 100) + 1) / 101 < r) state_31[k][i][j] |= bitSTABLE;
            if (((double)(rand() % 100) + 1) / 101 < r) state_31[k][i][j] |= bitSTABLE2;
         }
      }
   }
}
//
//void INIT_State(double state[HEIGHT][WIDTH]) //инициализация средних масс
//{
//   double k;
//   int i = 0, j = 0;
//
//   fscanf(file, "%lf", &k);
//   while (k != EOF && i != HEIGHT) 
//   {
//      state[i][j++] = k;
//      fscanf(file, "%lf", &k);
//      if (j == WIDTH)
//      {
//         j = 0;
//         i++;
//      }
//   }
//
//}
//
//void INIT_Begin_State(char begin[HEIGHT][WIDTH]) //инициализация начального состояния
//{
//   char k;
//   int i = 0, j = 0;
//
//   fscanf(file, "%c ", &k);
//   while (k != EOF && i != HEIGHT) 
//   {
//      begin[i][j++] = k;
//      fscanf(file, "%c ", &k);
//      if (j == WIDTH)
//      {
//         j = 0;
//         i++;
//      }
//   }
//
//}
//
//void INIT_RULE(int count_s[Size], double Rule[PS_Hight][PS_Width]) //инициализация правил
//{
//   double k;
//   int i = 0, j = 0;
//
//   fscanf(file, "%lf", &k);
//   while (k != EOF && i != PS_Hight) 
//   {
//      Rule[i][j++] = k;
//      fscanf(file, "%lf", &k);
//      if (j == count_s[i])
//      {
//         j = 0;
//         i++;
//      }
//   }
//
//}
//
//void INIT_S(int count_s[Size]) //инициализация массива исходов для правил
//{
//   int k;
//   int i = 0, j = 0;
//
//   fscanf(file, "%i", &k);
//   while (k != EOF && i != PS_Hight) 
//   {
//      S[i][j++] = k;
//      fscanf(file, "%i", &k);
//      if (j == count_s[i])
//      {
//         j = 0;
//         i++;
//      }
//   }
//
//}


void INIT_Count(int count[Size]) //инициализация массива для правил
{
   int k;
   int i = 0;
   f >> k;
   while (k != EOF && i != Size) 
   {
      count_s[i] = k;
      f >> k;
      i++;
   }
   
}

int prob(double P[PS_Hight][PS_Width], int k) //определение значения подходящей вероятности
{
   double l = ((double)(rand() % 100) + 1) / 101;
   int i = 0;
   while (i < PS_Width && l > P[k][i])
   {
      l -= P[k][i];
      i++;
   }
   if (i == PS_Width)
      return 0;
   else
      return i;
}

template <typename Ty, typename Ty2>
void INIT_RULE_S(Ty count_s[Size], Ty2 Rule_S[PS_Hight][PS_Width])
{
	double k;
	int i = 0, j = 0;
   f >> k;
	while (k != EOF && i != PS_Hight)
	{
		Rule_S[i][j++] = k;
      f >> k;
		if (j == count_s[i])
		{
			j = 0;
			i++;
		}
	}

}

//void INIT(double state[HEIGHT][WIDTH]) // состояние пространства
//{
//   int h, w;
//   fscanf(file, "%i %i", &h, &w);
//   try
//   {
//      bb_state = new char* [h];
//      for (int i = 0; i < h; i++)
//         bb_state[i] = new char[w];
//   }
//   catch (const std::exception&)
//   {
//      cout << "Lack of memory" << endl;
//   }
//   double k;
//   int i = 0, j = 0;
//
//   fscanf(file, "%lf", &k);
//   while (k != EOF && i != HEIGHT)
//   {
//      state[i][j++] = k;
//      fscanf(file, "%lf", &k);
//      if (j == WIDTH)
//      {
//         j = 0;
//         i++;
//      }
//   }
//
//}
//void INIT_B() // инициализация геометрии
//{
//   char k;
//   int h, w;
//   fscanf(file, "%i %i", &h, &w);
//   try
//   {
//      bb_state = new char* [h];
//      for (int i = 0; i < h; i++)
//         bb_state[i] = new char[w];
//   }
//   catch (const std::exception&)
//   {
//      cout << "Lack of memory" << endl;
//   }
//   int i = 0, j = 0;
//
//   fscanf(file, "%c ", &k);
//   while (k != EOF && i != HEIGHT)
//   {
//      bb_state[i][j++] = k;
//      fscanf(file, "%c ", &k);
//      if (j == WIDTH)
//      {
//         j = 0;
//         i++;
//      }
//   }
//
//}

void colide(int **state)
{
   int l, save, j;
   omp_set_num_threads(T);
   #pragma omp parallel for private (l, save, j)
   for (int i = 0; i < HEIGHT; i++)
   {
      for (j = 0; j < WIDTH; j++)
      {
         if (beg_state[i][j] == '1')
         {    
            if (!(((state[i][j] & bitUP) && (state[i][j] & bitDOWN))))
            {
               if (state[i][j] & bitUP)
               {
                  state[i][j] -= bitUP;
                  state[i][j] |= bitDOWN;
               }
               else
                  if (state[i][j] & bitDOWN)
                  {
                     state[i][j] -= bitDOWN;
                     state[i][j] |= bitUP;
                  }
            }
            if (!(((state[i][j] & bitLEFT) && (state[i][j] & bitRIGHT))))
            {
               if (state[i][j] & bitRIGHT)
               {
                  state[i][j] -= bitRIGHT;
                  state[i][j] |= bitLEFT;
               }
               else
                  if (state[i][j] & bitLEFT)
                  {
                     state[i][j] -= bitLEFT;
                     state[i][j] |= bitRIGHT;
                  }
            }
            continue;
         }

         l = state[i][j];

         if (count_s[l] != 1)
         {
            if (beg_state[i][j] == '0')
            {
               save = prob(P_0_1, l);
               state[i][j] = S[l][save];
            }
            else
               if (beg_state[i][j] == '2')
               {
                  save = prob(P_0_5, l);
                  state[i][j] = S[l][save];
               }
               else
                  if (beg_state[i][j] =='3')
                  {
                     save = prob(P_0_9, l);
                     state[i][j] = S[l][save];
                  }
         }
      }
   }
}

void move(int **state, int **state_next_s) 
{
   int j;
   omp_set_num_threads(T);
   #pragma omp parallel for private (j)
   for (int i = 0; i < HEIGHT; i++) 
      for (j = 0; j < WIDTH; j++) 
         state_next_s[i][j] = (state[i][j] & bitSTABLE) |
            (state[i][(j + 1) % WIDTH] & bitLEFT) |
            (state[i][(j - 1 + WIDTH) % WIDTH] & bitRIGHT) |
            (state[(i + 1) % HEIGHT][j] & bitDOWN) |
            (state[(i - 1 + HEIGHT) % HEIGHT][j] & bitUP) |
            (state[i][j] & bitSTABLE2);
   int C;
   #pragma omp parallel for private(C, j)
   for (int i = 0; i < HEIGHT; i++) 
      for (j = 0; j < WIDTH; j++) 
      {
         C = state[i][j];
         state[i][j] = state_next_s[i][j];
         state_next_s[i][j]=C;
      }
}

void iteration(int **state, int **state_next_s)
{
   colide(state);             //столкновение частиц
   move(state, state_next_s); //движение частиц
}

template <typename Type>
void INIT(Type ***ss)
{
   Type **state_s = *ss;
   Type k;
   f >> h >> w;

   state_s = new Type* [h];
   for (int i = 0; i < h; i++)
      state_s[i] = new Type[w];

   int i = 0, j = 0;
   f >> k;
   while (k != EOF && i != HEIGHT)
   {
      state_s[i][j++] = k;
      f >> k;
      //fscanf(file, "%lf", &k);
      if (j == WIDTH)
      {
         j = 0;
         i++;
      }
   }
   *ss = state_s;
}


void begin()
{
   f.open("Geometry.txt", ios_base::in);
   //fopen_s(&file, "Geometry.txt", "r"); //геометрия области, 0-частица, 1- зеркало, 2 - другая среда
   INIT(&beg_state);       //чтение из файла геометрии
   f.close();

   f.open("Density.txt", ios_base::in);
   //fopen_s(&file, "Density.txt", "r");  // начальное состояние области
   INIT(&den_state);                      //чтение из файла геометрии
   f.close();

}

void Rule(int count[Size], double P_0_1[PS_Hight][PS_Width], double P_0_5[PS_Hight][PS_Width], double P_0_9[PS_Hight][PS_Width], int S[PS_Hight][PS_Width]) 
{
   f.open("Rule3.txt", ios_base::in);           //массив с колличеством исходов их частицы при столконовении
   INIT_Count(count);                           //чтение из файла массива
   f.close();

   f.open("matrixes0.1.txt", ios_base::in);     //инициализация првила. вероятность 0.1
   INIT_RULE_S(count, P_0_1);                   //чтение из файла вероятности
   f.close();

   f.open("matrixes0.5.txt", ios_base::in);     //инициализация првила. вероятность 0.5
   INIT_RULE_S(count, P_0_5);                   //чтение из файла вероятности
   f.close();

   f.open("matrixes0.9.txt", ios_base::in);     //инициализация првила. вероятность 0.9
   INIT_RULE_S(count, P_0_9);                   //чтение из файла вероятности
   f.close();

   f.open("Rule2.txt", ios_base::in);           //состояни для правил      
   INIT_RULE_S(count, S);                       //чтение из файла состояний
   f.close();

}

int main()
{
   begin(); //инициализация начальных состояний

   FILL(); // заполнение частицами массива начальными состояниями
   
   Rule(count_s, P_0_1, P_0_5, P_0_9, S); //инициализация правил 

   omp_set_num_threads(T);
   for (int j = 0; j <= Iter; j++)
   {
      auto start = std::chrono::high_resolution_clock::now();
      for (int i = 0; i < Count; i++)
      {
         iteration(state_31[i], state_n_3[i]);  //итерация : сдвиг, столкновение
      }
      auto end = std::chrono::high_resolution_clock::now();
      std::chrono::duration<double> diff = end - start;
      cout << "Time iteration " << diff.count() << endl;

      if (j % 10 == 0)
      {
         auto start1 = std::chrono::high_resolution_clock::now();

     //    picture(state_31, j);  //предача данных для отрисовки картинок

         auto end1 = std::chrono::high_resolution_clock::now();
         std::chrono::duration<double> diff1 = end1 - start1;
         cout << "Time average " << diff1.count() << endl;
      }
   }

   //plot();       //построение графиков и bmp-изображений

   system("pause");
   return 0;
}
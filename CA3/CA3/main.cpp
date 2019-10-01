#include <iostream>
#include <conio.h>
#include "Header.h"
using namespace std;

int state_next_s[Count][HEIGHT][WIDTH]; //êîïèÿ äëÿ èòåðàöèé
int state_3[Count][HEIGHT][WIDTH];
int S[PS_Hight][PS_Width];
double P_0_1[PS_Hight][PS_Width];
double P_0_5[PS_Hight][PS_Width];
double P_0_9[PS_Hight][PS_Width];
int count_s[Size];
char begin_state[HEIGHT][WIDTH];
double fl[HEIGHT][WIDTH];
FILE* file;

void FILL() //çàïîëíåíèå ìàññèâà íà÷àëüíûõ ñîñòîÿíèé, ñðåäíèìè ìàññàìè
{
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

				r = fl[i][j] / 10;
				if ((double)(rand() % 100 + 1) / 101 < r) state_3[k][i][j] |= bitUP;
				if ((double)(rand() % 100 + 1) / 101 < r) state_3[k][i][j] |= bitRIGHT;
				if ((double)(rand() % 100 + 1) / 101 < r) state_3[k][i][j] |= bitDOWN;
				if ((double)(rand() % 100 + 1) / 101 < r) state_3[k][i][j] |= bitLEFT;
				if ((double)(rand() % 100 + 1) / 101 < r) state_3[k][i][j] |= bitSTABLE;
				if ((double)(rand() % 100 + 1) / 101 < r) state_3[k][i][j] |= bitSTABLE2;
			}
		}
	}
}

void INIT_State(double state[HEIGHT][WIDTH]) //èíèöèàëèçàöèÿ ñðåäíèõ ìàññ
{
	double k;
	int i = 0, j = 0;

	fscanf(file, "%lf", &k);
	while (k != EOF && i != HEIGHT)
	{
		state[i][j++] = k;
		fscanf(file, "%lf", &k);
		if (j == WIDTH)
		{
			j = 0;
			i++;
		}
	}

}

void INIT_Begin_State(char begin[HEIGHT][WIDTH]) //èíèöèàëèçàöèÿ íà÷àëüíîãî ñîñòîÿíèÿ
{
	char k;
	int i = 0, j = 0;

	fscanf(file, "%c ", &k);
	while (k != EOF && i != HEIGHT)
	{
		begin[i][j++] = k;
		fscanf(file, "%c ", &k);
		if (j == WIDTH)
		{
			j = 0;
			i++;
		}
	}

}

void INIT_RULE(int count_s[Size], double Rule[PS_Hight][PS_Width]) //èíèöèàëèçàöèÿ ïðàâèë
{
	double k;
	int i = 0, j = 0;

	fscanf(file, "%lf", &k);
	while (k != EOF && i != PS_Hight)
	{
		Rule[i][j++] = k;
		fscanf(file, "%lf", &k);
		if (j == count_s[i])
		{
			j = 0;
			i++;
		}
	}

}

void INIT_S(int count_s[Size]) //èíèöèàëèçàöèÿ ìàññèâà èñõîäîâ äëÿ ïðàâèë
{
	int k;
	int i = 0, j = 0;

	fscanf(file, "%i", &k);
	while (k != EOF && i != PS_Hight)
	{
		S[i][j++] = k;
		fscanf(file, "%i", &k);
		if (j == count_s[i])
		{
			j = 0;
			i++;
		}
	}

}

void INIT_Count(int count[Size]) //èíèöèàëèçàöèÿ ìàññèâà äëÿ ïðàâèë
{
	int k;
	int i = 0;

	fscanf(file, "%i", &k);
	while (k != EOF && i != Size)
	{
		count_s[i] = k;
		fscanf(file, "%i", &k);
		i++;
	}

}

int prob(double P[PS_Hight][PS_Width], int k) //îïðåäåëåíèå çíà÷åíèÿ ïîäõîäÿùåé âåðîÿòíîñòè
{
	double l = (double)(rand() % 100 + 1) / 101;
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

void colide(int state[][WIDTH])
{
	int l, save, j;
	omp_set_num_threads(T);
#pragma omp parallel for private (l, save, j)
	for (int i = 0; i < HEIGHT; i++)
	{
		for (j = 0; j < WIDTH; j++)
		{
			if (begin_state[i][j] == '1')
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
				if (begin_state[i][j] == '0')
				{
					save = prob(P_0_1, l);
					state[i][j] = S[l][save];
				}
				else
					if (begin_state[i][j] == '2')
					{
						save = prob(P_0_5, l);
						state[i][j] = S[l][save];
					}
					else
						if (begin_state[i][j] == '3')
						{
							save = prob(P_0_9, l);
							state[i][j] = S[l][save];
						}
			}
		}
	}
}

void move(int state[][WIDTH], int state_next_s[][WIDTH])
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
			state_next_s[i][j] = C;
		}
}

void iteration(int state[][WIDTH], int state_next_s[][WIDTH])
{
	colide(state);             //ñòîëêíîâåíèå ÷àñòèö
	move(state, state_next_s); //äâèæåíèå ÷àñòèö
}

void begin()
{
	fopen_s(&file, "Geometry.txt", "r"); //ãåîìåòðèÿ îáëàñòè, 0-÷àñòèöà, 1- çåðêàëî, 2 - äðóãàÿ ñðåäà
	INIT_Begin_State(begin_state);       //÷òåíèå èç ôàéëà ãåîìåòðèè
	fclose(file);

	fopen_s(&file, "Density.txt", "r");  // íà÷àëüíîå ñîñòîÿíèå îáëàñòè
	INIT_State(fl);                      //÷òåíèå èç ôàéëà ãåîìåòðèè
	fclose(file);

}

void Rule(int count[Size], double P_0_1[PS_Hight][PS_Width], double P_0_5[PS_Hight][PS_Width], double P_0_9[PS_Hight][PS_Width], int S[PS_Hight][PS_Width])
{
	fopen_s(&file, "Rule3.txt", "r"); //ìàññèâ ñ êîëëè÷åñòâîì èñõîäîâ èõ ÷àñòèöû ïðè ñòîëêîíîâåíèè
	INIT_Count(count);                //÷òåíèå èç ôàéëà ìàññèâà
	fclose(file);

	fopen_s(&file, "matrixes0.1.txt", "r"); //èíèöèàëèçàöèÿ ïðâèëà. âåðîÿòíîñòü 0.1
	INIT_RULE(count, P_0_1);                //÷òåíèå èç ôàéëà âåðîÿòíîñòè
	fclose(file);

	fopen_s(&file, "matrixes0.5.txt", "r"); //èíèöèàëèçàöèÿ ïðâèëà. âåðîÿòíîñòü 0.5
	INIT_RULE(count, P_0_5);                //÷òåíèå èç ôàéëà âåðîÿòíîñòè
	fclose(file);

	fopen_s(&file, "matrixes0.9.txt", "r"); //èíèöèàëèçàöèÿ ïðâèëà. âåðîÿòíîñòü 0.9
	INIT_RULE(count, P_0_9);                //÷òåíèå èç ôàéëà âåðîÿòíîñòè
	fclose(file);

	fopen_s(&file, "Rule2.txt", "r");       //ñîñòîÿíè äëÿ ïðàâèë
	INIT_S(count);                          //÷òåíèå èç ôàéëà ñîñòîÿíèé
	fclose(file);

}

int main()
{
	Bmp img(WIDTH, HEIGHT);

	begin(); //èíèöèàëèçàöèÿ íà÷àëüíûõ ñîñòîÿíèé

	FILL(); // çàïîëíåíèå ÷àñòèöàìè ìàññèâà íà÷àëüíûìè ñîñòîÿíèÿìè

	Rule(count_s, P_0_1, P_0_5, P_0_9, S); //èíèöèàëèçàöèÿ ïðàâèë 

	omp_set_num_threads(T);
	for (int j = 0; j <= Iter; j++)
	{
		auto start = std::chrono::high_resolution_clock::now();
		for (int i = 0; i < Count; i++)
		{
			iteration(state_3[i], state_next_s[i]);  //èòåðàöèÿ : ñäâèã, ñòîëêíîâåíèå
		}
		auto end = std::chrono::high_resolution_clock::now();
		std::chrono::duration<double> diff = end - start;
		cout << "Time iteration " << diff.count() << endl;

		if (j % 10 == 0)
		{
			auto start1 = std::chrono::high_resolution_clock::now();

			picture(state_3, img, j);  //ïðåäà÷à äàííûõ äëÿ îòðèñîâêè êàðòèíîê

			auto end1 = std::chrono::high_resolution_clock::now();
			std::chrono::duration<double> diff1 = end1 - start1;
			cout << "Time average " << diff1.count() << endl;
		}
	}

	plot();       //ïîñòðîåíèå ãðàôèêîâ è bmp-èçîáðàæåíèé

	system("pause");
	return 0;
}
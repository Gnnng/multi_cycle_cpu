#include <stdio.h>

FILE *fin;
FILE *fout;

int main(int argc, char **argv) {
	char str[255];
	int i = 0;
	fin = fopen(argv[1], "r");
	fout = fopen("test_ram_temp.ram", "w");
	while(fgets(str, 254, fin)) {
		i++;
		str[32] = '\n';
		str[33] = 0;
		if (i > 4)
			fputs(str, fout);
	}	
}
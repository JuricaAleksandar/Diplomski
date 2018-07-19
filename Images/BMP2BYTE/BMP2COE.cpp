#include <direct.h>
#include "EasyBMP.h"
#include "string.h"

int main(int argc, char **argv)
{	
	if(argc == 1 || strstr(argv[1], ".bmp") == NULL)
	{
		printf("Enter .bmp image name!\nExample: BMP2COE simbad.bmp\n");
		return 0;
	}

	FILE *fptr;
	if((fptr = fopen(argv[1],"r")) == NULL)
	{
		printf("No file with name: %s!\n",argv[1]);
		return 0;
	}
	BMP input;
	char filename[200];
	char* tmp;
	input.ReadFromFile(argv[1]);
	
	unsigned int input_width = input.TellWidth();
	unsigned int input_height = input.TellHeight();
	
	strcpy(filename, argv[1]);
	
	tmp = strchr(filename,'.');
	memset(tmp, 0, 200 - strlen(filename));

	if(_mkdir(filename) != 0)
	{
		printf("Failed to create folder!\n");
		return 0;
	}
	
	int len = strlen(filename);
	*tmp = 92;
	tmp++;
	strncpy(tmp, filename, len);
	tmp += len;
	
	strcpy(tmp,"x.coe");

	for(int file_num = 0; file_num < 4; file_num++)
	{
		*tmp = file_num + '0';
		fptr = fopen(filename,"w");
		fprintf(fptr,"memory_initialization_radix=16;\nmemory_initialization_vector=\n");
		for(int j = 0 + file_num * input_height / 4; j < (file_num + 1) * input_height / 4; j++)
		{
			for(int i = 0; i < input_width; i++)
			{
				RGBApixel pix;
				pix = input.GetPixel(i, j);
				fprintf(fptr,"%x,\n",(unsigned char)pix.Red);
				fprintf(fptr,"%x,\n",(unsigned char)pix.Green);
				if(i == input_width - 1 && j == (file_num + 1) * input_height / 4 - 1)
				{
					fprintf(fptr,"%x;",(unsigned char)pix.Blue);	
				}
				else
				{
					fprintf(fptr,"%x,\n",(unsigned char)pix.Blue);
				}
			}
		}	
		fclose(fptr);
	}		
	
	return 0;
}
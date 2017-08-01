main: load_image.o ball_image_processing_plugin.o 
	g++  load_image.o ball_image_processing_plugin.o -o test -lboost_system

load_image.o: load_image.cpp 
	g++ -fPIC -std=c++0x -fopenmp -Wall -Werror -fmessage-length=0 -Ofast -I ./ -c load_image.cpp

ball_image_processing_plugin.o: image_processing_plugin.h ball_image_processing_plugin.cpp 
	g++ -fPIC -std=c++0x -fopenmp -Wall -Werror -fmessage-length=0 -Ofast -I ./ -c ball_image_processing_plugin.cpp

clean :
	rm test *.o

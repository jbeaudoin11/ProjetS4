main: load_image.o ball_image_processing_plugin.o 
	g++  load_image.o ball_image_processing_plugin.o -o test

load_image.o: load_image.cpp 
	g++ -std=c++11 -c load_image.cpp -I ./

ball_image_processing_plugin.o: image_processing_plugin.h ball_image_processing_plugin.cpp 
	g++ -std=c++11 -c ball_image_processing_plugin.cpp -I ./

clean :
	rm test *.o

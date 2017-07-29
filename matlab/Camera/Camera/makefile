main: load_image.o ball_image_processing_plugin.o 
	g++  load_image.o ball_image_processing_plugin.o -o test -lboost_system

load_image.o: load_image.cpp 
	g++ -std=c++11 -O2 -I ./ -c load_image.cpp

ball_image_processing_plugin.o: image_processing_plugin.h ball_image_processing_plugin.cpp 
	g++ -std=c++11 -O2 -I ./ -c ball_image_processing_plugin.cpp

clean :
	rm test *.o

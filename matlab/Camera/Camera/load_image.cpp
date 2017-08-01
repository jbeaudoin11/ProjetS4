#include <boost/shared_array.hpp>
#include <boost/filesystem.hpp>
#include <boost/range/iterator_range.hpp>
#include <cstdlib>
#include <chrono>
#include <iostream>
#include <fstream>
#include <string>

#include "ball_image_processing_plugin.cpp"

// #define BENCHMARK_IT 1000
#define BENCHMARK_IT 10000

using namespace std;
using namespace boost;
// using namespace boost::filesystem;

namespace {
	const unsigned int IMAGE_WIDTH = 480;
	const unsigned int IMAGE_HEIGHT = 480;
	const unsigned int IMAGE_SIZE = IMAGE_WIDTH * IMAGE_HEIGHT * 3;
};

int main( int argc, char **argv)
{
	// Read images
	vector<shared_array<uint8_t>> imgs;

	for(int f=1; f<argc; f++) {		
		ifstream image_file(argv[f], ios::binary);
		image_file.seekg(0, image_file.beg);

		shared_array<uint8_t> image(new uint8_t[IMAGE_SIZE]);
		image_file.read(reinterpret_cast<char *>(image.get()), IMAGE_SIZE);
		imgs.push_back(image);
	}

	// cout << to_string(imgs.size()) << endl;

	// Benchmark
	BallImageProcessingPlugin plugin;
	double x, y, dx, dy;
	int imgs_len = imgs.size();
	
	clock_t start_time = clock();
	int i = BENCHMARK_IT;
	// int i = 144;
	// int i = 8;
	while(i--) {
		plugin.OnImage(imgs[i % imgs_len], IMAGE_WIDTH, IMAGE_HEIGHT, x, y);
		plugin.OnBallPosition(x, y, dx, dy);

		// if(x < 0) {
		// 	cout << "WRONG " << to_string(i % imgs_len) << endl; 
		// }
		// cout << "(" << to_string(x) << ", " << to_string(y) << ") " << "[" << to_string(dx) << ", " << to_string(dy) << "]" << endl;
	}
	clock_t end_time = clock();
	double duration = (end_time - start_time) / (double) CLOCKS_PER_SEC;

	cout << "IT : " << to_string(BENCHMARK_IT) << endl;
	cout << "TIME : " << to_string(duration) << endl;
	cout << "IMG/S : " << to_string(BENCHMARK_IT/duration) << endl;

	return EXIT_SUCCESS;
}

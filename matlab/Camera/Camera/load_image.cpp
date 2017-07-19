#include <boost/shared_array.hpp>
#include <boost/filesystem.hpp>
#include <boost/range/iterator_range.hpp>
#include <cstdlib>
#include <chrono>
#include <iostream>
#include <fstream>
#include <string>

#include "ball_image_processing_plugin.cpp"

#define BENCHMARK_IT 1000

using namespace std;
using namespace boost;
using namespace boost::filesystem;

namespace {
	const unsigned int IMAGE_WIDTH = 480;
	const unsigned int IMAGE_HEIGHT = 480;
	const unsigned int IMAGE_SIZE = IMAGE_WIDTH * IMAGE_HEIGHT * 3;
};

int main( int argc, char **argv)
{
	// Read images
	vector<shared_array<uint8_t>> imgs;

	directory_iterator end();
	for(auto& file : make_iterator_range(directory_iterator(path("../benchmark_imgs/")))) {
		cout << file.path().string() << endl;

		ifstream image_file(file.path().string(), ios::binary);
		// image_file.seekg(0, image_file.beg);

		// Read file
		shared_array<uint8_t> image(new uint8_t[IMAGE_SIZE]);
		image_file.read(reinterpret_cast<char *>(image.get()), IMAGE_SIZE);
		imgs.push_back(image);
	}

	return EXIT_SUCCESS;


	// // Benchmark
	// BallImageProcessingPlugin plugin;
	// double x, y;
	// int img_index = 0;
	// int imgs_len = imgs.size();
	
	// clock_t start_time = clock();
	// int i = BENCHMARK_IT;
	// while(i--) {
	// 	plugin.OnImage(imgs[i], IMAGE_WIDTH, IMAGE_HEIGHT, x, y);
	// 	img_index = img_index % imgs_len;

	// 	// cout << "(" << to_string(x) << ", " << to_string(y) << ") "<< endl;
	// }
	// clock_t end_time = clock();
	// double duration = (end_time - start_time) / (double) CLOCKS_PER_SEC;

	// cout << "IT : " << to_string(BENCHMARK_IT) << endl;
	// cout << "TIME : " << to_string(duration) << endl;
	// cout << "IMG/S : " << to_string(BENCHMARK_IT/duration) << endl;

	// return EXIT_SUCCESS;
}

#include <boost/shared_array.hpp>
#include <cstdlib>
#include <iostream>
#include <fstream>

#include "ball_image_processing_plugin.cpp"

using namespace std;

namespace {
	const unsigned int IMAGE_WIDTH = 480;
	const unsigned int IMAGE_HEIGHT = 480;
	const unsigned int IMAGE_SIZE = IMAGE_WIDTH * IMAGE_HEIGHT * 3;
};

int main( int argc, char **argv)
{
	// if(argc != 2)
	// {
	// 	cerr << "Erreur: Vous devez specifier seulement l'image a charger" << endl;
	// 	return EXIT_FAILURE;
	// }

	// Open image file
	// ifstream image_file("imgs\\" + argv[1], ios::binary);
	// ifstream image_file(argv[1], ios::binary);
	ifstream image_file("imgs/image_0.rgb", ios::binary);
	if(!image_file)
	{
		cerr << "Erreur: Chemin de l'image invalide" << endl;
		return EXIT_FAILURE;
	}

	// Check file size
	image_file.seekg(0, image_file.end);
	if(image_file.tellg() != IMAGE_SIZE)
	{
		cerr << "Erreur: La taille de l'image specifiee est incorrecte" << endl;
		return EXIT_FAILURE;
	}
	image_file.seekg(0, image_file.beg);

	// Read file
	boost::shared_array<uint8_t> image(new uint8_t[IMAGE_SIZE]);
	image_file.read(reinterpret_cast<char *>(image.get()), IMAGE_SIZE);

	BallImageProcessingPlugin plugin;
	double x, y;

	plugin.OnImage(image, IMAGE_WIDTH, IMAGE_HEIGHT, x, y);

	return EXIT_SUCCESS;
}

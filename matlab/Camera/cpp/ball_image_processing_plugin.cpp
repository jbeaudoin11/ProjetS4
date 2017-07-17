#include <cstdint>
#include <string>

#include <image_processing_plugin.h>
using namespace std;

enum ColorLayer {
	r = 0,
	g = 1,
	b = 2
};

struct Circle {
	int x;
	int y;
	int r;
}

class BallImageProcessingPlugin : public ImageProcessingPlugin {
	public:
		BallImageProcessingPlugin(); 			//vous devez utiliser ce constructeur et aucun autre
		virtual ~BallImageProcessingPlugin();
		
		/*! \brief Receive an image to process.
		*
		*  This function will be called every time we need the to send the X,Y position and differentials to
		*  the **firmware**.
		*
		*  \param in_ptrImage Image data.
		*  \param in_W Image width (= 480).
		*  \param in_H Image height (= 480).
		*  \param out_dXPos X coordinate (sub-)pixel position of the ball.
		*  \param out_dYPos Y coordinate (sub-)pixel position of the ball.
		*
		*/
		virtual void OnImage(
			const boost::shared_array<uint8_t> in_ptrImage,
			unsigned int in_W,
			unsigned int in_H,
			double & out_dXPos,
			double & out_dYPos
		);
		
		/*! \brief Receive an image to process.
		*
		*  This function will be called every time we need the to send the X,Y position and differentials to
		*  the **firmware**.
		*
		*  \param in_dXPos X coordinate position of the ball in <arbitrary input units.
		*  \param in_dYPos Y coordinate position of the ball.
		*  \param out_dXDiff X speed of the ball in <input units> per second.
		*  \param out_dYDiff Y speed of the ball in <input units> per second.
		*
		*/
		virtual void OnBallPosition(
			double in_dXPos,
			double in_dYPos,
			double &out_dXDiff,
			double &out_dYDiff
		);

	private:

	/*
		Pre processing the image,
		generate a binary version of the image
	*/
	vector<vector<bool>> _ImgPreProcessing(
		const boost::shared_array<uint8_t> &img,
		const unsigned int &W,
		const unsigned int &H
	);

	/*
		Get a specific color matrix from the image
	*/
	vector<vector<uint8_t>> _getColorLayer(
		const boost::shared_array<uint8_t> &img,
		const unsigned int &W,
		const unsigned int &H
		const ColorLayer &layer
	);

	/*
		Generate a treshold/binary version of a matrix
	*/
	vector<vector<bool>> _generateTresholdVersion(
		const vector<vector<uint8_t>> &gray_mat,
		const unsigned int &W,
		const unsigned int &H
	);

	/*
		Search the ball area (white plate circle)
	*/
	Circle _searchPlateArea(
		const vector<vector<bool>> &mat,
		const unsigned int &W,
		const unsigned int &H
	);

	/*
		Search for the white circle at a given row
	*/
	Circle _searchCircle(
		const vector<vector<bool>> &mat,
		const unsigned int &W,
		const unsigned int &H,
		const unsigned int &y
	);

	/*
		Search for the ball in the plate area
	*/
	void _searchBallInCircle(
		const vector<vector<bool>> &mat,
		const unsigned int &W,
		const unsigned int &H,
		const Circle &area
	);

};

BallImageProcessingPlugin::BallImageProcessingPlugin() {
//Insérez votre code ici
}

BallImageProcessingPlugin::~BallImageProcessingPlugin() {
//Insérez votre code ici
}

void BallImageProcessingPlugin::OnImage(
	const boost::shared_array<uint8_t> in_ptrImage,
	unsigned int in_W,
	unsigned int in_H,
	double &out_dXPos,
	double &out_dYPos
) {

	vector<vector<uint8_t>> green = _getColorLayer(img, W, H, ColorLayer.g);
	
	for(y=0;y<20;y++){
		for(x=0;x<20;x++){
			cout << to_string(green[y][x]) << " ";
		}	
		cout << endl;
	}

	out_dXPos = -1.0;
	out_dYPos = -1.0;
}

void BallImageProcessingPlugin::OnBallPosition(
	double in_dXPos,
	double in_dYPos,
	double &out_dXDiff,
	double &out_dYDiff
) {
	//insérez votre code ici
	out_dXDiff = 0.0;
	out_dYDiff = 0.0;
}

vector<vector<bool>> BallImageProcessingPlugin::_ImgPreProcessing(
	const boost::shared_array<uint8_t> &img,
	const unsigned int &W,
	const unsigned int &H
) {
	return _generateTresholdVersion(_getColorLayer(img, W, H, ColorLayer.g), W, H);
}

vector<vector<uint8_t>> BallImageProcessingPlugin::_getColorLayer(
	const boost::shared_array<uint8_t> &img,
	const unsigned int &W,
	const unsigned int &H
	const ColorLayer &layer
) {
	vector<vector<uint8_t>> mat;
	mat.resize(H, vector<uint8_t>(W, 0));

	img[z, y, x]

	for(y=0;y<H;y++){
		for(x=0;x<W;x++){
			mat[y][x] = img[layer*(W*H) + y*W + x];
		}	
	}
	
	return mat;
}

vector<vector<bool>> BallImageProcessingPlugin::_generateTresholdVersion(
	const vector<vector<uint8_t>> &gray_mat,
	const unsigned int &W,
	const unsigned int &H
) {

}








//ne rien modifier passé ce commentaire
extern "C"
{
	ImageProcessingPlugin * Load();
	void Unload( ImageProcessingPlugin * in_pPlugin );
}

void Unload( ImageProcessingPlugin * in_pPlugin )
{
	delete in_pPlugin;
}

ImageProcessingPlugin * Load()
{
	//si vous changez le nom de la classe asssurez-vous de le changer aussi ci-dessous
	return new BallImageProcessingPlugin;
}

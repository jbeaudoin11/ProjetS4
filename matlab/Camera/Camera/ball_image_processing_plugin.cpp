#ifndef BALL_IMAGE_PROCESSING_PLUGIN_CPP_
#define BALL_IMAGE_PROCESSING_PLUGIN_CPP_

#include <cstdint>
#include <cmath>
#include <utility>
#include <string>
#include <iostream>
#include <algorithm>

#include "image_processing_plugin.h"

#define RADIUS_OFFSET 1

#define H 480
#define H_1_5 96
#define H_2_5 192
#define H_3_5 288
#define H_4_5 384
#define H_1_2 240
#define H_1_4 120

#define W 480
#define W_1_2 240
#define W_1_4 120

#define SEARCH_BALL_GRID_CELL_SIZE 4
#define SEARCH_BALL_REGION_SIZE 40

using namespace std;

enum ColorLayer {
	RED = 0,
	GREEN = 1,
	BLUE = 2
};

// Utilities
pair<int, int> max_i(const int a, const int b) {
	return (a>b) ? pair<int, int>(a, 0) : pair<int, int>(b, 1);
}
pair<int, int> min_i(const int a, const int b) {
	return (a<b) ? pair<int, int>(a, 0) : pair<int, int>(b, 1);
}

class Circle {
	public:
		int x = -1;
		int y = -1;
		int r = -1;

		Circle() {}

		Circle(int _x, int _y, int _r) {
			x = _x;
			y = _y;
			r = _r;
		}

		bool isInArea(int _x, int _y) {
			// TODO
			return false;
		}
};


class BallImageProcessingPlugin : public ImageProcessingPlugin {
	public:
		inline BallImageProcessingPlugin(); 			//vous devez utiliser ce constructeur et aucun autre
		inline virtual ~BallImageProcessingPlugin();

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
		inline virtual void OnImage(
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
		inline virtual void OnBallPosition(
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
		inline vector<vector<bool>> _ImgPreProcessing(
			const boost::shared_array<uint8_t> &img
		);

		/*
			Get a specific color matrix from the image
		*/
		inline vector<vector<uint8_t>> _getColorLayer(
			const boost::shared_array<uint8_t> &img,
			const ColorLayer &layer
		);

		/*
			Generate a treshold/binary version of a matrix
		*/
		inline vector<vector<bool>> _generateTresholdVersion(
			const vector<vector<uint8_t>> &gray_mat
		);

		/*
			Search the ball area (white plate circle)
		*/
		inline Circle _searchPlateArea(
			const vector<vector<bool>> &mat
		);

		/*
			Search for the white circle at a given row
		*/
		inline Circle _searchCircle(
			const vector<vector<bool>> &mat,
			const unsigned int &y
		);

		/*
			Search for the ball in the plate area
		*/
		inline pair<int, int> _searchBallInCircle(
			const vector<vector<bool>> &mat,
			const Circle &area
		);

		/*
			Search the position of the first black pixel in the area and assume it's the ball
		*/
		inline pair<int, int> _searchFirstBlackPixelInCircle(
			const vector<vector<bool>> &mat,
			const Circle &area
		);

		/*
			Calculate the center of mass of the ball
		*/
		inline pair<int, int> _calculateCenterOfMassOfTheBall(
			const vector<vector<bool>> &mat,
			const Circle &area,
			const pair<int, int> &pixel_pos
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

	// Make some preprocessing so we have a binary matrix
	vector<vector<bool>> mat = _ImgPreProcessing(in_ptrImage);

	// Search the circular plate area in the image
	Circle plate_area = _searchPlateArea(mat);

	cout << "(" << to_string(plate_area.x) << ", " << to_string(plate_area.y) << ") " << to_string(plate_area.r) << endl;

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
	const boost::shared_array<uint8_t> &img
) {
	return _generateTresholdVersion(_getColorLayer(img, GREEN));
}

vector<vector<uint8_t>> BallImageProcessingPlugin::_getColorLayer(
	const boost::shared_array<uint8_t> &img,
	const ColorLayer &layer
) {
	vector<vector<uint8_t>> mat;
	mat.resize(H, vector<uint8_t>(W, 0));

	for(int y=0;y<H;y++){
		for(int x=0;x<W;x++){
			mat[y][x] = img[(y*H+x) * 3 + layer]; // from 3D coords to index
		}
	}

	return mat;
}

vector<vector<bool>> BallImageProcessingPlugin::_generateTresholdVersion(
	const vector<vector<uint8_t>> &gray_mat
) {
	// Get 4 pixels
	vector<uint8_t> values(4, 0);
	values[0] = gray_mat[floor(H_1_5)][W_1_2];
	values[1] = gray_mat[floor(H_2_5)][W_1_2];
	values[2] = gray_mat[floor(H_3_5)][W_1_2];
	values[3] = gray_mat[floor(H_4_5)][W_1_2];
	uint8_t treshold_val = *max_element(values.begin(), values.end());

	// Define de k ratio
	float k = 0.99;
	if(treshold_val < 50) {
		k = 0.4;
	} else if(treshold_val < 100) {
		k = 0.75;
	} else if(treshold_val < 200) {
		k = 0.85;
	}
	treshold_val *= k;

	// Generate the binary matrix
	vector<vector<bool>> mat;
	mat.resize(H, vector<bool>(W, false));
	for(int y=0;y<H;y++){
		for(int x=0;x<W;x++){
			mat[y][x] = gray_mat[y][x] > treshold_val;
		}
	}

	return mat;
}

Circle BallImageProcessingPlugin::_searchPlateArea(
	const vector<vector<bool>> &mat
) {

	// Search 4 times a circle to be more robust
	vector<Circle> circles(4, Circle());
	circles[0] = _searchCircle(mat, H_1_5);
	circles[1] = _searchCircle(mat, H_2_5);
	circles[2] = _searchCircle(mat, H_3_5);
	circles[3] = _searchCircle(mat, H_4_5);

	vector<bool> validated_circles(4, false);

	// Basic radius validation test
	for(int i=0; i<4; i++) {
		int r = circles[i].r;
		validated_circles[i] = (r <= W_1_2 && r <= H_1_2) && (r > W_1_4 && r > H_1_4);
	}

	// Compare radiuses with each other
	for(int i=0; i<4; i++) {
		int nb_diff_lte_2 = 0;
		for(int j=1; j<4; j++) {
			if(abs(circles[i].r - circles[j].r) <= 2) {
				nb_diff_lte_2++;
			}
		}
		validated_circles[i] = nb_diff_lte_2 > 1;
	}

	// Generate the mean value of the position and center for valid circles
	int x=0, y=0, r=0, validated_circles_cnt=0;
	for(int i=0; i<4; i++) {
		if(validated_circles[i]) {
			Circle c = circles[i];
			x += c.x;
			y += c.y;
			r += c.r;
			validated_circles_cnt++;
		}
	}

	if(!validated_circles_cnt) {
		return Circle();
	}

	return Circle(x/validated_circles_cnt, y/validated_circles_cnt, r/validated_circles_cnt - RADIUS_OFFSET);
}

Circle BallImageProcessingPlugin::_searchCircle(
	const vector<vector<bool>> &mat,
	const unsigned int &y
) {
	Circle plate_area;

	unsigned int x_l = 0;
	unsigned int x_r = W-1;

	//******** HORIZONTAL ********
	// Search the first "white" pixel from left for a height of y
	bool found = false;
	for(int x=0; x<W_1_2; x++) {
		if(mat[y][x]) {
			x_l = x;
			found = true;
			break;
		}
	}

	if(!found) {
		return plate_area;
	}

	// Search the first "white" pixel from right for a height of y
	found = false;
	for(int x=W-1; x>=W_1_2; x--) {
		if(mat[y][x]) {
			x_r = x;
			found = true;
			break;
		}
	}

	if(!found) {
		return plate_area;
	}

	//******** VERTICAL ********
	unsigned int y_t = 0, y_b = 0;
	if(y < H_1_2) {
		y_t = y;
		y_b = 0;

		// Search the first "white" pixel from bot for a x of x_r
		found = false;
		for(int _y=H-1; _y>=0; _y--) {
			if(mat[_y][x_r]) {
				y_b = _y;
				found = true;
				break;
			}
		}

		if(!found) {
			return plate_area;
		}
	} else {
		y_t = 0;
		y_b = y;

		// Search the first "white" pixel from top for a x of x_r
		found = false;
		for(int _y=0; _y<H; _y++) {
			if(mat[_y][x_r]) {
				y_t = _y;
				found = true;
				break;
			}
		}

		if(!found) {
			return plate_area;
		}
	}

	//******** CALCULATIONS ********
	int dx = (x_r - x_l)/2;
	int dy = (y_b - y_t)/2;

	if( dx <= 0 || dy <= 0) {
		return plate_area;
	}

	// Center
	plate_area.x = x_l + dx;
	plate_area.y = y_t + dy;

	// Radius
	plate_area.r = (int) sqrt((pow(dx, 2) + pow(dy, 2)));

	return plate_area;
}

pair<int, int> BallImageProcessingPlugin::_searchBallInCircle(
	const vector<vector<bool>> &mat,
	const Circle &area
) {
	int y_t = max(0, area.y - area.r);
	int y_b = min(H-1, area.y + area.r);

	int dy=0, dx=0, x_l=0, x_r=0;
	bool found = false;

	pair<int, int> pixel_pos = _searchFirstBlackPixelInCircle(mat, area);
	if(pixel_pos.first < 0) {
		return pixel_pos;
	}

	return _calculateCenterOfMassOfTheBall(mat, area, pixel_pos);
}

pair<int, int> BallImageProcessingPlugin::_searchFirstBlackPixelInCircle(
	const vector<vector<bool>> &mat,
	const Circle &area
) {
	int y_t = area.y - area.r;
	int y_b = area.y + area.r;

	int dy=0;
	int dx=0;
	int x_l=0;
	int x_r=0;

	// Search the first black pixel in the circle from top
	for(int y=y_t; y<=y_b; y+=SEARCH_BALL_GRID_CELL_SIZE) {
		dy = area.y - y;
		dx = (int) sqrt((double) (pow(area.r, 2) - pow(dy, 2)));

		x_l = area.x - dx;
		x_r = area.x + dx;
	
		for(int x=x_l; x<=x_r; x+=SEARCH_BALL_GRID_CELL_SIZE) {
			if(!mat[y][x]) {
				return pair<int, int>(x, y);
			}
		}
	}

	return pair<int, int>(-1, -1);
}

pair<int, int> BallImageProcessingPlugin::_calculateCenterOfMassOfTheBall(
	const vector<vector<bool>> &mat,
	const Circle &area,
	const pair<int, int> &pixel_pos
) {
	int y_t = max(area.y - area.r, pixel_pos.second);
	int y_b = min(area.y + area.r, pixel_pos.second + SEARCH_BALL_REGION_SIZE);

	int dy=0;
	int dx=0;
	int x_l=0, i_l=0;
	int x_r=0, i_r=0;

	int nb_pix_row = 0;
	int nb_pix_x = 0;
	int nb_pix_y = 0;
	int mass_x = 0;
	int mass_y = 0;

	bool found = false;

	// Calculate, in a "rectangle" area, the center of mass of the ball
	for(int y=y_t; y<=y_b; y+=SEARCH_BALL_GRID_CELL_SIZE) {
		dy = area.y - y;
		dx = (int) sqrt((double) (pow(area.r, 2) - pow(dy, 2)));

		tie(x_l, i_l) = max_i(area.x - dx, pixel_pos.x);
		tie(x_r, i_r) = min_i(area.x + dx, , pixel_pos.x + SEARCH_BALL_REGION_SIZE);

		// Find the first back pixel from left
		if(!i_l) { // If we are not the circle edge
			found = false;
			for(int x=x_l; x<=x_r; x++) {
				if(!mat[y][x]) {
					x_l = x;
					found = true;
					break;
				}
			}
			
			if(!found) continue;
		}

		// Find the first back pixel from right
		if(!i_r) { // If we are not the circle edge
			found = false;
			for(int x=x_r; x>=x_l; x--) {
				if(!mat[y][x]) {
					x_l = x;
					found = true;
					break;
				}
			}
			
			if(!found) continue;
		}

		nb_pix_row = (x_r - x_l) + 1;
		if(nb_pix_row == 1) continue; // There was no black pixel in this line

		nb_pix_x += nb_pix_row;
		for(int i=x_l; i<=x_r; i++) {
			mass_x += i;
		}

		nb_pix_y += nb_pix_row;
		mass_y += nb_pix_row * y;
	}

	if(!nb_pix_x) return pair<int, int>(-1, -1);

	return pair<int, int>(mass_x/nb_pix_x, mass_y/nb_pix_y);
}


//ne rien modifier passé ce commentaire
// extern "C"
// {
// 	ImageProcessingPlugin * Load();
// 	void Unload( ImageProcessingPlugin * in_pPlugin );
// }

// void Unload( ImageProcessingPlugin * in_pPlugin )
// {
// 	delete in_pPlugin;
// }

// ImageProcessingPlugin * Load()
// {
// 	//si vous changez le nom de la classe asssurez-vous de le changer aussi ci-dessous
// 	return new BallImageProcessingPlugin;
// }

#endif /* BALL_IMAGE_PROCESSING_PLUGIN_CPP_ */

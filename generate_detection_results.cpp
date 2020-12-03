#define _CRT_SECURE_NO_WARNINGS
#pragma warning( disable : 4996)
#include <iostream>
#include <stdio.h>
#include <time.h>
#include <opencv2/opencv.hpp>
#include <opencv2/highgui.hpp>

using namespace std;
using namespace cv;

// For needle detection
void needleDetection(Mat ori_image)
{
	Mat ori_img, HSV;
	Mat threshold1;

	// Copy the original image
	ori_img = ori_image.clone();

	//convert frame from BGR to HSV colorspace
	cvtColor(ori_img, HSV, COLOR_BGR2HSV);

	// Image thresholding
	//inRange(HSV, Scalar(0, 0, 110), Scalar(40, 45, 170), threshold1); // Ground truth value
	//inRange(HSV, Scalar(0, 0, 110), Scalar(40, 50, 185), threshold1); // threshold values from 3NN
	//inRange(HSV, Scalar(0, 0, 110), Scalar(40, 50, 175), threshold1); // threshold values from 1NN
	inRange(HSV, Scalar(75, 0, 120), Scalar(175, 40, 210), threshold1); // threshold values from 4-means
																						
	// Show the result of needle detection
	namedWindow("Needle detection", WINDOW_NORMAL);
	imshow("Needle detection", threshold1);
}

// For thread detection
void threadDetection(Mat ori_image)
{
	Mat thread_HSV, thread_binary;

	//convert frame from BGR to HSV colorspace
	cvtColor(ori_image, thread_HSV, COLOR_BGR2HSV);

	// Image thresholding
	//inRange(thread_HSV, Scalar(95, 15, 160), Scalar(130, 40, 195), thread_binary); // Ground truth value
	//inRange(thread_HSV, Scalar(75, 0, 125), Scalar(175, 40, 215), thread_binary); // threshold values from 3NN
	inRange(thread_HSV, Scalar(100, 0, 120), Scalar(175, 40, 210), thread_binary); // threshold values from 1NN

	// Show the result of thread detection
	namedWindow("Thread detection", WINDOW_NORMAL);
	imshow("Thread detection", thread_binary);
}

// For membrane detection
void membraneDetection(Mat ori_image)
{
	Mat mem_HSV, mem_binary;

	//convert frame from BGR to HSV colorspace
	cvtColor(ori_image, mem_HSV, COLOR_BGR2HSV);

	// Image thresholding
	//inRange(mem_HSV, Scalar(0, 0, 180), Scalar(90, 10, 210), mem_binary); // Ground truth value
	//inRange(mem_HSV, Scalar(0, 0, 180), Scalar(60, 20, 210), mem_binary); // threshold values from 3NN
	inRange(mem_HSV, Scalar(0, 0, 150), Scalar(90, 20, 210), mem_binary); // threshold values from 1NN

	// Show the result of membrane detection
	namedWindow("Membrane detection", WINDOW_NORMAL);
	imshow("Membrane detection", mem_binary);
}

int main(int argc, char* argv[])
{
	string file_path = "E:/project_for_Matlab_and_ADS/suturing_project/check_pixel_value/dis_img_1.png";
	Mat ori_img;
	int user_input = 0;
	int key_pressed = 0;

	// 
	cout << "Hi there! This program is for testing threshold." << endl;
	cout << "------------------------------------------------------" << endl;
	cout << "Press 1 to test threshold for needle detection" << endl;
	cout << "Press 2 to test threshold for thread detection" << endl;
	cout << "Press 3 to test threshold for membrane detection" << endl;
	cout << "------------------------------------------------------" << endl;

	// To control user input
	while (1) {
		cin >> user_input;

		if ((user_input == 1) || (user_input == 2) || (user_input == 3)) {
			cout << "User input: " << user_input << endl;
			break;
		}
		else {
			cout << "Invalid input! Please only press 1 or 2." << endl;
		}
	}

	// Read an image
	ori_img = imread(file_path, IMREAD_COLOR);

	//
	if(ori_img.empty())
	{
		std::cout << "Could not read the image: " << file_path << std::endl;
		return 1;
	}

	//
	if ((user_input == 1)) {
		needleDetection(ori_img);
	}
	else if (user_input == 2) {
		threadDetection(ori_img);
	}
	else if (user_input == 3) {
		membraneDetection(ori_img);
	}

	// Display the original image
	cv::namedWindow("The original image. Press esc to exit.", WINDOW_NORMAL);
	cv::imshow("The original image. Press esc to exit.", ori_img);
	key_pressed = waitKey(0);

	// Press 'esc' to exit the program 
	if (key_pressed == 27)
	{
		cout << "Esc key is pressed by user. Stoppig the program" << endl;
	}

	destroyAllWindows();
	system("pause");
	return 0;
}
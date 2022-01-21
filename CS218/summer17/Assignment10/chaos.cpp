#include <cstdlib>
#include <iostream>
#include <GL/gl.h>
#include <GL/glut.h>
#include <GL/freeglut.h>

using	namespace	std;

// ----------------------------------------------------------------------
//  CS 218 -> Assignment #10
//  Chaos Program.
//  Provided main.

//  Uses openGL (which must be installed).
//  openGL installation:
//	sudo apt-get update
//	sudo apt-get upgrade
//	sudo apt-get install binutils-gold
//	sudo apt-get install libgl1-mesa-dev
//	sudo apt-get install freeglut3 freeglut3-dev


// ----------------------------------------------------------------------
//  External functions (in seperate file).

extern "C" int getIterations(int, char* [], int *, int *);
extern "C" void drawChaos();

// ----------------------------------------------------------------------
//  Global variables
//	Must be accessible for openGL display routine, drawChaos().

int	degree = 0;
int	drawColor = 0x000000;
int	iterations = 0;
int	rotateSpeed = 0;

// ----------------------------------------------------------------------
//  Key handler function.
//	Terminates for 'x', 'q', or ESC key.
//	Updates zoomFactor for 'z' (zoom in) and 'Z' (zoom out).

void	keyHandler(unsigned char key, int x, int y)
{
	if (key == 'x' || key == 'q' || key == 27 || key == 100) {
		glutLeaveMainLoop();
		exit(0);
	}
}

// ----------------------------------------------------------------------
//  Main routine.

int main(int argc, char* argv[])
{
	bool	stat;

	double	left = -550.0;
	double	right = 550.0;
	double	bottom = -550.0;
	double	top = 550.0;

	stat = getIterations(argc, argv, &iterations, &rotateSpeed);

	// Debug call for draw function
	//	drawChaos();

	if (stat) {
		glutInit(&argc, argv);
		glutInitDisplayMode(GLUT_RGB | GLUT_SINGLE);
		glutInitWindowSize(500, 500);
		glutInitWindowPosition(100, 100);
		glutCreateWindow("CS 218 Assignment #10, Chaos Program");
		glClearColor(0.0, 0.0, 0.0, 0.0);
		glClear(GL_COLOR_BUFFER_BIT);
		glMatrixMode(GL_PROJECTION);
		glLoadIdentity();
		glOrtho(left, right, bottom, top, -510.0, 510.0);
		glPointSize(0.5);
	
		glutKeyboardFunc(keyHandler);
		glutDisplayFunc(drawChaos);

		glutMainLoop();
	}

	return 0;
}


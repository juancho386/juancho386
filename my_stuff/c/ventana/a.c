#include <stdio.h>
#include <stdlib.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Xos.h>

int main(int argv, char *argc[]) {
	Display *dpy;
	int screen;
	Window win;
	XEvent event;
	dpy = XOpenDisplay(NULL);
	screen=DefaultScreen(dpy);
	win = XCreateSimpleWindow(dpy, RootWindow(dpy,screen), 100, 100, 500, 300, 1, 
		BlackPixel(dpy,screen),WhitePixel(dpy,screen));
	XSelectInput(dpy,win,ExposureMask | KeyPressMask);
	XMapWindow(dpy,win);
	while(1) {
		XNextEvent(dpy, &event);
	}

}

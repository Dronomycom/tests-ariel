#include "ofApp.h"

void ofApp::setup()
{
    ofPixels pixels;
    ofLoadImage(pixels, ofToDataPath("test.png"));
    
    cout << pixels.getWidth() << " " << pixels.getHeight() << endl;
    assert(pixels.getBytesPerPixel() == 3);
    
    int r, g, b;
    tie(r, g, b) = getRGB(pixels, 1, 1);
    cout << r << " " << g << " " << b << endl;
}

void ofApp::draw()
{}

tuple<int, int, int> ofApp::getRGB(const ofPixels &pixels, int x, int y)
{
    int index = (y * pixels.getWidth() + x) * 3;
    return make_tuple(pixels[index], pixels[index + 1], pixels[index + 2]);
}

#pragma once

#include "ofMain.h"

class ofApp : public ofBaseApp
{
public:
    void setup();
    void draw();
    
    tuple<int, int, int> getRGB(const ofPixels &pixels, int x, int y);
};

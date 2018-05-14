#pragma once

#include "ofMain.h"

class ofApp : public ofBaseApp
{
public:
    void setup();
    void draw();
    
protected:
    ofTexture colorTexture;
    ofEasyCam cam;
    ofMesh mesh;
};
